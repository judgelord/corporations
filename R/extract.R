#' @title Extract corporate name matches from text
#' @description Searches user-provided text against the built-in corporations database
#' and returns matches with associated metadata (e.g., CIK, FED_RSSD).
#'
#' @param data A data frame or character vector containing the text to search.
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
R
#' @title Extract corporate matches from text
#' @description Searches user-provided text against the built-in corporations database
#' and returns matches with associated metadata (e.g., CIK, FED_RSSD).
#'
#' @param data A data frame or character vector containing the text to search.
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
extract <- function(data,
                    col_name = "text",
                    data_return_cols = NULL,
                    regex_return_cols = NULL,
                    remove_acronyms = FALSE,
                    do_clean_text = TRUE,
                    verbose = TRUE,
                    cl = NULL) {

  # Checking for the internal dataset
  if (!exists("corporations_data")) {
    stop("The internal dataset 'corporations_data' could not be found.")
  }

  # Validate input and data
  if (is.character(data) && is.null(dim(data))) {
    data <- data.frame(text = data, stringsAsFactors = FALSE)
    col_name <- "text"
  }

  chk::chk_data(data)
  chk::chk_subset(col_name, names(data))

  if (!is.null(regex_return_cols)) {
    chk::chk_subset(regex_return_cols, names(corporations_data))
  }

  # Progress Bar Setup
  opb <- pbapply::pboptions(type = if (verbose) "timer" else "none")
  on.exit(pbapply::pboptions(opb), add = TRUE)

  data <- dplyr::mutate(data, row_id = dplyr::row_number())

  if (nrow(data) == 0) return(dplyr::tibble())

  # Prepare patterns
  patterns <- unique(stats::na.omit(corporations_data$pattern))
  if (remove_acronyms) {
    patterns <- patterns[!grepl("^[A-Z]{2,}$", patterns)]
  }

  # Text prep
  text_raw <- data[[col_name]]
  text_search <- text_raw

  if (do_clean_text && exists("clean_text")) {
    text_search <- clean_text(text_search)
  }

  matches_found <- extract_matches_all_internal(
    text_search = text_search,
    text_raw = text_raw,
    row_ids = data$row_id,
    patterns = patterns,
    id_col_name = "row_id",
    verbose = verbose,
    cl = cl
  )

  if (nrow(matches_found) == 0) return(dplyr::tibble())

  # Join Metadata from Internal Dataset
  meta_data <- corporations_data |>
    dplyr::select(dplyr::all_of(unique(c("pattern", regex_return_cols)))) |>
    dplyr::distinct()

  matches_found <- dplyr::left_join(
    matches_found,
    meta_data,
    by = "pattern"
  )

  # Merge back with input data
  result <- dplyr::left_join(matches_found, data, by = "row_id")

  # Column selection and ordering
  valid_data_cols <- if(!is.null(data_return_cols)) data_return_cols[data_return_cols %in% names(result)] else character(0)
  valid_regex_cols <- if(!is.null(regex_return_cols)) regex_return_cols[regex_return_cols %in% names(result)] else character(0)

  cols_to_keep <- c("row_id", valid_data_cols, valid_regex_cols, "pattern", "match")
  result <- result[, names(result) %in% cols_to_keep, drop = FALSE]

  if (verbose) message("Total matches found: ", nrow(result))

  return(dplyr::as_tibble(result))
}
