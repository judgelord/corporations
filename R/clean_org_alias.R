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

  # name <- iconv(name, to = "ASCII//TRANSLIT")
  # name <- stringr::str_replace_all(name, "(?i)\\s[0-9]*\\s[km]b\\s*pdf", "")
  # name <- stringr::str_to_lower(name)
  # corp_suffix_re <- "(?i)\\b(inc|corp|ltd|llc|plc|co|company|limited)\\b"
  # name <- stringr::str_replace_all(name, corp_suffix_re, "")
  # punc_re <- "[\\s\\.,:;/'\"`´‘’“”\\(\\)\\[\\]\\{\\}_—\\-?$=!]+"
  # name <- stringr::str_replace_all(name, punc_re, " ")
  # name <- stringr::str_replace_all(name, "\\s*(?:,\\s*)+", ", ")
  # name <- stringr::str_squish(name)

  # 1. Unicode & PDF metadata cleanup
  name <- iconv(name, to = "ASCII//TRANSLIT")
  # Fixed: Added double backslash for \\s and \\b
  name <- stringr::str_replace_all(name, "(?i)\\s[0-9]*\\s[km]b\\s*pdf", "")

  # 2. Convert to lowercase
  name <- stringr::str_to_lower(name)

  # 3. Remove corporate suffixes
  corp_suffix_re <- "(?i)\\b(inc|corp|ltd|llc|plc|co|company|limited)\\b"
  name <- stringr::str_replace_all(name, corp_suffix_re, "")

  # 4. Remove punctuation & symbol noise
  # Double backslashes used for R character string compliance
  punc_re <- "[\\s\\.,:;/'\"`´‘’“”\\(\\)\\[\\]\\{\\}_—\\-?$=!]+"
  name <- stringr::str_replace_all(name, punc_re, " ")

  # 5. Normalize commas (ensure ", " format)
  # FIXED: Changed \s* to \\s*
  name <- stringr::str_replace_all(name, "\\s*(?:,\\s*)+", ", ")

  # 6. Final cleanup of spaces
  name <- stringr::str_squish(name)

  return(name)
}
