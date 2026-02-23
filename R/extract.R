#' @title Extract corporate name matches from text
#' @description Searches user-provided text against the built-in corporations database
#' and returns matches with associated metadata (e.g., CIK, FED_RSSD).
#'
#' @param data A data frame or character vector containing the text to search.
#' @param col_name Column name in the data frame containing text to search through. Default is "text".
#' @param data_return_cols Optional vector of column names to include from the input 'data'.
#' @param regex_return_cols Optional vector of column names to include from the built-in corporations data (e.g., "FED_RSSD", "CIK").
#' @param do_fuzzy_matching Logical; if TRUE, applies fuzzy matching to the regular expression matches and includes another column of confidence scores for the matches.
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
                   do_fuzzy_matching = TRUE,
                   remove_acronyms = FALSE,
                   do_clean_text = TRUE,
                   verbose = TRUE,
                   unique_match = FALSE,
                   cl = NULL) {

  # corporations_data was saved via usethis::corporations_data.
  regex_lookup <- corporations_data

  if (verbose) {
    message("Cleaning corporate aliases and removing suffixes...")
  }
  op <- pbapply::pboptions(type = if (verbose) "timer" else "none")
  on.exit(pbapply::pboptions(op))

  raw_aliases <- unlist(pbapply::pblapply(regex_lookup$aliases, clean_org_alias))
  regex_lookup$pattern <- sapply(strsplit(raw_aliases, "\\|"), function(parts) {
    cleaned_parts <- trimws(parts)
    paste(unique(cleaned_parts), collapse = "|")
  })

  regex_lookup <- regex_lookup[nchar(regex_lookup$pattern) > 1, ]
  regex_lookup$pattern <- paste0("\\b(?:", regex_lookup$pattern, ")\\b")

  # regex_lookup <- regex_lookup[nchar(regex_lookup$aliases) > 1, ]
  # regex_lookup$pattern <- paste0("\\b(?:", regex_lookup$aliases, ")\\b")

  # Call the regextable dependency
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
    cl = cl,
  )

  if (nrow(result) == 0) return(result)

  if (do_fuzzy_matching) {
    if (verbose) message("Calculating fuzzy match confidence scores...")

    # Clean text found by the regex on the 'match' column and from the col_name column
    result$match_clean <- clean_org_alias(result$match)
    result$cleaned_col_name<- clean_org_alias(result[[col_name]])

    result$confidence_score <- stringdist::stringsim(
      result$cleaned_col_name,   # cleaned text from data
      result$match_clean, # This is the cleaned version the match
      method = "jw"
    )

    # Remove the temporary cleaning column
    result$match_clean <- NULL
    result$cleaned_col_name <- NULL

    # Return the results ranked by confidence scores
    return(result[order(-result$confidence_score), ])
  }

  return (result)
}

