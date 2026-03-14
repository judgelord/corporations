#' @title Extract corporate name matches from text
#' @description Searches user-provided text against the built-in corporations database
#' and returns matches with associated metadata (e.g., CIK, FED_RSSD).
#'
#' @param data A data frame or character vector containing the text to search.
#' @param col_name Column name in the data frame containing text to search through. Default is "text".
#' @param mode String; "match" (direct comparison) or "search" (extract from long text).
#' @param data_return_cols Optional vector of column names to include from the input 'data'.
#' @param regex_return_cols Optional vector of column names to include from the built-in corporations data (e.g., "FED_RSSD", "CIK").
#' @param remove_acronyms Logical; if TRUE, removes all-uppercase patterns from the search.
#' @param do_clean_text Logical; if TRUE, applies basic text cleaning to the input before matching.
#' @param verbose Logical; if TRUE, displays progress messages.
#' @param unique_match Logical; if TRUE, stops searching after first match to find at most one match per row. If FALSE, returns all matches for all patterns.
#' @param cl A cluster object or integer for parallel evaluation via [pbapply::pblapply()].
#'
#' @return A tibble with columns: `row_id`, selected `data` columns, selected `regex_return_cols`,
#' `pattern`, and `match`.
#' @export
#' @importFrom dplyr mutate
#' @importFrom dplyr sample_frac
#' @importFrom pbapply pbsapply
#' @importFrom stringdist stringsim
#' @importFrom udpipe udpipe_download_model udpipe_load_model udpipe_annotate
extract <- function(data,
                    col_name = "text",
                    mode = c("match", "search"),
                    data_return_cols = NULL,
                    regex_return_cols = NULL,
                    remove_acronyms = FALSE,
                    do_clean_text = TRUE,
                    verbose = TRUE,
                    unique_match = FALSE,
                    cl = NULL) {
  # Search mode logic
  mode <- match.arg(mode)
  if (mode == "search") {
    if (verbose) message("Extracting entities from input data in search mode...")

    if (is.character(data)) data <- tibble::tibble(!!col_name := data)

    # Define a permanent directory on the user's machine for this package
    model_dir <- tools::R_user_dir("YourPackageName", which = "data")
    if (!dir.exists(model_dir)) dir.create(model_dir, recursive = TRUE)

    model_path <- file.path(model_dir, "english-ewt.udpipe")

    if (!file.exists(model_path)) {
      # Ask the user for permission
      message("This package requires a one-time download of a 20MB NLP model to your machine.")
      ans <- askYesNo("Would you like to download the model now?")

      # 2. Check the answer
      if (isTRUE(ans)) {
        if (verbose) message("Downloading NLP model for one-time setup...")
        m_info <- udpipe::udpipe_download_model(language = "english", model_dir = model_dir)
        file.rename(m_info$file_model, model_path)
      } else {
        # 3. If they say no, the function cannot run in search mode
        stop("Search mode requires the NLP model. Download cancelled by user.")
      }
    }

    ud_model <- udpipe::udpipe_load_model(model_path)

    anno <- as.data.frame(udpipe::udpipe_annotate(ud_model, x = data[[col_name]]))

    # Filter for Proper Nouns
    entities <- anno[anno$upos == "PROPN", ]
    if (nrow(entities) == 0) return(tibble::tibble())

    # Ensure token_id is numeric to prevent math errors
    token_ids <- as.numeric(entities$token_id)

    # Group sequential Proper Nouns (e.g., "Goldman" + "Sachs")
    # Check if the difference between current and previous ID is exactly 1
    if (length(token_ids) > 1) {
      entities$diff <- c(1, diff(token_ids))
      # If the diff is not 1, it's a new group (a different entity in the same text)
      entities$group <- cumsum(entities$diff != 1)
    } else {
      entities$group <- 0
    }

    # Update 'data' dataframe from extracted entities
    entities_agg <- aggregate(token ~ doc_id + group, data = entities, paste, collapse = " ")

    # Convert doc_id (e.g., "doc1") to row index (1)
    row_indices <- as.integer(gsub("doc", "", entities_agg$doc_id))

    # Reconstruct 'data' to keep original columns/metadata
    data <- data[row_indices, , drop = FALSE]
    data[[col_name]] <- entities_agg$token
  }

  # Setup Data
  regex_lookup <- corporations_data

  op <- pbapply::pboptions(type = if (verbose) "timer" else "none")
  on.exit(pbapply::pboptions(op))

  if (verbose) {
    message("Cleaning corporate aliases and removing suffixes...")
  }
  # Pattern Preparation
  regex_lookup$pattern <- pbapply::pbsapply(regex_lookup$aliases, function(x) {
    raw <- clean_org_alias(x)
    parts <- unlist(strsplit(raw, "\\|"))
    paste(unique(trimws(parts)), collapse = "|")
  }, cl = cl)

  regex_lookup <- regex_lookup[nchar(regex_lookup$pattern) > 1, ]
  # Word boundaries to ensure substrings do not match
  regex_lookup$pattern <- paste0("\\b(?:", regex_lookup$pattern, ")\\b")

  # Convert to tibble if is a character vector
  if (is.character(data)) {
    data <- tibble::tibble(!!col_name := data)
  }

  if (is.data.frame(data)) {
    original_nrow <- nrow(data)

    # Keep rows where col_name is not NA and is not an empty string
    data <- data[!is.na(data[[col_name]]) & trimws(as.character(data[[col_name]])) != "", , drop = FALSE]

    if (verbose && (nrow(data) < original_nrow)) {
      message(sprintf("Removed %d rows containing NA or empty strings in '%s'.",
                      original_nrow - nrow(data), col_name))
    }
  }

  if (nrow(data) == 0) {
    if (verbose) message("No valid data remaining after cleaning.")
    return(tibble::tibble())
  }

  # Extraction via regextable package
  final_return_cols <- unique(c(col_name, data_return_cols))
  result <- regextable::extract(
    data = data,
    regex_table = regex_lookup,
    col_name = col_name,
    pattern_col = "pattern",
    data_return_cols = final_return_cols,
    regex_return_cols = regex_return_cols,
    remove_acronyms = remove_acronyms,
    do_clean_text = do_clean_text,
    verbose = verbose,
    unique_match = unique_match,
    cl = cl
  )

  if (is.null(result) || nrow(result) == 0) {
    return(tibble::tibble())
  }

  if (!col_name %in% names(result)) {
    if (verbose) message("Warning: col_name not found in results. Returning raw matches.")
    return(result)
  }

  # Only continue running if the column has data
  valid_rows <- which(!is.na(result[[col_name]]) & result[[col_name]] != "")
  if (length(valid_rows) == 0) {
    return(tibble::tibble())
  }

  result <- result[valid_rows, ]

  if (verbose) message("Verifying matches via token consistency...")

  # Clean input and the match columns for comparison
  result$match_clean <- clean_org_alias(result$match)
  result$input_clean <- clean_org_alias(result[[col_name]])

  # Apply the Token Check and Jaro-Winkler Similarity
  result$token_score <- mapply(verify_tokens, result$input_clean, result$match_clean)

  result$similarity <- stringdist::stringsim(
    result$input_clean,
    result$match_clean,
    method = "jw"
  )

  # Only keep the match if at least 60% of the input tokens match.
  # result <- result[result$token_score >= 0.6, ]

  # Only keep the match is the match is exactly the same as the cleaned name
  result <- result[result$match_clean == result$input_clean, ]

  # Order results based on substring similarity
  result$match_clean <- NULL
  result$input_clean <- NULL
  result$token_score <- NULL

  if (verbose) message("Finished Matching!")

  return(result[order(-result$similarity), ])
}


# Token verification function
# This checks if the unique words in the input are present in the match.
#' @noRd
verify_tokens <- function(input_str, match_str) {
  in_tokens <- unlist(strsplit(tolower(input_str), "\\s+"))
  ma_tokens <- unlist(strsplit(tolower(match_str), "\\s+"))

  # Words to ignore (These do not help distinguish companies)
  noise <- c("inc", "corp", "ltd", "llc", "co", "company", "limited", "and", "the")
  in_sig <- setdiff(in_tokens, noise)
  ma_sig <- setdiff(ma_tokens, noise)

  if (length(in_sig) == 0) return(0)

  # Calculate what percentage of the input's significant words exist in the match
  # "American Moment" (2 words) -> "American Corp" (1 word match) = 0.50
  overlap <- length(intersect(in_sig, ma_sig)) / length(in_sig)
  return(overlap)
}
