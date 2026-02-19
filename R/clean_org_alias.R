#' Clean Organization Aliases
#'
#' Standardizes organization names by removing corporate suffixes, PDF metadata,
#' and normalizing punctuation/whitespace for regex matching.
#'
#' @param name A character string containing the organization name.
#' @return A cleaned, lowercase character string.
#' @export
#' @import stringr
clean_org_alias <- function(name) {
  if (is.na(name) || name == "" || name == "NA") {
    return("")
  }

  name <- iconv(name, to = "ASCII//TRANSLIT")
  name <- stringr::str_replace_all(name, "(?i)\\s[0-9]*\\s[km]b\\s*pdf", "")
  name <- stringr::str_to_lower(name)
  corp_suffix_re <- "(?i)\\b(inc|corp|ltd|llc|plc|co|company|limited)\\b"
  name <- stringr::str_replace_all(name, corp_suffix_re, "")
  punc_re <- "[\\s\\.,:;/'\"`´‘’“”\\(\\)\\[\\]\\{\\}_—\\-?$=!]+"
  name <- stringr::str_replace_all(name, punc_re, " ")
  name <- stringr::str_replace_all(name, "\\s*(?:,\\s*)+", ", ")
  name <- stringr::str_squish(name)

  return(name)
}
