#' @title Extract corporate name matches from text
#' @description Searches user-provided text against the built-in corporations database
#' and returns matches with associated metadata (e.g., CIK, FED_RSSD).
#'
#' @param input_data A data frame or character vector containing the text to search.
#' @param col_name Column name in the data frame containing text to search through. Default is "text".
#' @param data_return_cols Optional vector of column names to include from the input 'data'.
#' @param regex_return_cols Optional vector of column names to include from the
#' built-in corporations data (e.g., "FED_RSSD", "CIK").
#' @param remove_acronyms Logical; if TRUE, removes all-uppercase patterns from the search.
#' @param verbose Logical; if TRUE, displays progress messages.
#' @param cl A cluster object or integer for parallel evaluation via [pbapply::pblapply()].
#'
#' @return A tibble with columns: `row_id`, selected `data` columns, selected `regex_return_cols`,
#' `pattern`, and `match`.
#' @export
corporations_extract <- function(input_data,
                                 col_name = "text",
                                 data_return_cols = NULL,
                                 regex_return_cols = NULL,
                                 remove_acronyms = FALSE,
                                 verbose = TRUE,
                                 cl = NULL) {

  # corporations_data was saved via usethis::corporations_data.
  regex_lookup <- corporations_data
  regex_lookup$pattern <- regex_lookup$aliases

  # Call the regextable dependency
  result <- regextable::extract(
    data = input_data,
    regex_table = regex_lookup,
    col_name = col_name,
    data_return_cols = data_return_cols,
    regex_return_cols = regex_return_cols,
    remove_acronyms = remove_acronyms,
    verbose = verbose,
    cl = cl
  )

  return(result)
}
