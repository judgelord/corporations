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

#' house_hearing_excerpt dataset
#'
#' Sample text dataset used for demonstration of `corporations` and `search` mode extraction.
#'
#' An excerpt of text converted to a tibble from a 119 Congress hearing titled "Embedded Threats:
#' Foreign Ownership, Hidden Hardware, and Licensing Failures in America’s Transportation Systems"
#' @format A tibble with 1 column:
#' \describe{
#'   \item{text}{A column wiht each row containing a sentence from the excerpt}
#' }
#' @source \url{https://www.congress.gov/119/chrg/CHRG-119hhrg62658/CHRG-119hhrg62658.pdf}
#' @docType data
#' @name house_hearing_excerpt
NULL



