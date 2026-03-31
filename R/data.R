#' corporations_data dataset
#'
#' A crosswalk lookup table of hundreds of thousands of corporations for regular expression matching and company searching
#' @format A tibble with 5 columns:
#' \describe{
#'   \item{aliases}{aliases of a certain company (each one seperated by '|')}
#'   \item{cik}{Central Index Key of a corporation (numeric)}
#'   \item{FED_RSSD}{Research, Statistics, Supervision, and Discount identifier (numeric)}
#'   \item{ticker}{Stock ticker of a corporation}
#'   \item{naics}{North American Industry Classification System (NAICS) codes (numeric)}
#' }
#' @source Generated for the `corporations` package
#' @docType data
#' @name corporations_data
NULL

#' project_2025_coalition_and_contributors dataset
#'
#' Sample text dataset used for demonstration of `corporations`.
#'
#' Extracted corporations and individual mentioned inside Project 2025's “Mandate for Leadership: The Conservative Promise”.
#' @format A tibble with 4 columns:
#' \describe{
#'   \item{type}{Reference to either a organization or individual contributor in the document}
#'   \item{organization}{The organization itself or one that is associated with the individual}
#'   \item{individual}{The individual's name if type is 'Individual'}
#'   \item{role}{The relationship between the organization/individual with Project 2025}
#' }
#' @source \url{https://static.heritage.org/project2025/2025_MandateForLeadership_FULL.pdf}
#' @docType data
#' @name project_2025_coalition_and_contributors
NULL



