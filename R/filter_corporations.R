#' @title Subset corporations based on user filters
#' @description Creates a subset of corporation data based on particular kinds of corporations that a user
#' would like to know more about. (e.g., companies with stock tickers, by NAICS code)
#'
#' @param corporations_return_cols Optional vector of column names to include from the built-in corporations data (e.g., "FED_RSSD", "CIK").
#' @param public_only Logical; if TRUE, subsets the dictionary to only include corporations with stock tickers.
#' @param naics_codes Optional vector of NAICS codes to filter the dictionary. If NULL (default), all industries are included.
#' @param search_term Optional character string; if provided, filters the company names using a partial string match (case-insensitive).
#' @param verbose Logical; if TRUE, displays progress messages.
#'
#' @return A tibble containing the filtered subset of the corporations database, including columns such as `aliases`, `ticker`, `cik`, and `naics`.
#' @export
filter_corporations <- function(naics_codes = NULL,
                                public_only = FALSE,
                                corporations_return_cols = c("aliases", "cik", "FED_RSSD"),
                                search_term = NULL
                                ) {

  # using sample data
  corporations_filter <- corporations_data_sample

  # Filter by NAICS (Optional)
  if (!is.null(naics_codes)) {
    corporations_filter <- corporations_filter[corporations_filter$naics %in% naics_codes, ]
  }

  # Filter for Public Companies
  if (public_only) {
    corporations_filter <- corporations_filter[!is.na(corporations_filter$ticker), ]
  }

  # Optional: string search
  if (!is.null(search_term)) {
    corporations_filter <- corporations_filter[grepl(search_term, corporations_filter$aliases, ignore.case = TRUE), ]
  }

  return(corporations_filter)
}
