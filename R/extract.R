#' @title Extract corporate name matches from text
#' @description Searches user-provided text against the built-in corporations database
#' and returns matches with associated metadata (e.g., CIK, FED_RSSD).
#'
#' @param data A data frame or character vector containing the text to search.
#' @param col_name Column name in the data frame containing text to search through. Default is "text".
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
extract <- function(data,
                    col_name = "text",
                    data_return_cols = NULL,
                    regex_return_cols = NULL,
                    remove_acronyms = FALSE,
                    do_clean_text = TRUE,
                    verbose = TRUE,
                    unique_match = FALSE,
                    cl = NULL) {

  # Setup Data
  regex_lookup <- corporations_data

  op <- pbapply::pboptions(type = if (verbose) "timer" else "none")
  on.exit(pbapply::pboptions(op))

  if (verbose) {
    message("Cleaning corporate aliases and removing suffixes...")
  }
  # Pattern Preparation
  raw_aliases <- unlist(pbapply::pblapply(regex_lookup$aliases, clean_org_alias))
  regex_lookup$pattern <- pbapply::pbsapply(strsplit(raw_aliases, "\\|"), function(parts) {
    cleaned_parts <- trimws(parts)
    paste(unique(cleaned_parts), collapse = "|")
  }, cl = cl)

  regex_lookup <- regex_lookup[nchar(regex_lookup$pattern) > 1, ]
  # Word boundaries to ensure substrings do not match
  regex_lookup$pattern <- paste0("\\b(?:", regex_lookup$pattern, ")\\b")

  # Extraction via regextable package
  result <- regextable::extract(
    data = data,
    regex_table = regex_lookup,
    col_name = col_name,
    pattern_col = "pattern",
    data_return_cols = data_return_cols,
    regex_return_cols = regex_return_cols,
    remove_acronyms = remove_acronyms,
    do_clean_text = do_clean_text,
    verbose = verbose,
    unique_match = unique_match,
    cl = cl
  )

  if (nrow(result) == 0) return(result)

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
  result <- result[result$token_score >= 0.6, ]

  # Order results based on substring similarity
  result$match_clean <- NULL
  result$input_clean <- NULL
  result$token_score <- NULL

  if (verbose) message("Finished Matching!")

  return(result[order(-result$similarity), ])
}


#' @export
safe_clean_one <- function(x) {
  if (is.na(x) || is.null(x) || length(x) == 0) return("")
  txt <- as.character(x[1])
  cleaned <- tryCatch(clean_org_alias(txt), error = function(e) NULL)
  if (is.null(cleaned) || length(cleaned) == 0 || all(cleaned == "")) return(txt)
  return(as.character(cleaned[1]))
}


# Token verification function
# This checks if the unique words in the input are present in the match.
#' @export
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
