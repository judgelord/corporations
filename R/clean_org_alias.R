#' @title Clean Corporate Suffixes
#' @description Removes common legal suffixes and trailing punctuation from entity names.
#' @param x A character vector of names.
#' @return A cleaned character vector.
#' @noRd
clean_org_alias <- function(x) {
  x <- tolower(x)
  suffixes <- c("\\binc\\b", "\\bcorp\\b", "\\bcorporation\\b",
                "\\bllc\\b", "\\blp\\b", "\\bltd\\b", "\\bincorporated\\b",
                "\\bllp\\b", "\\bco\\b")

  suffix_pattern <- paste0("(?:", paste(suffixes, collapse = "|"), ")")

  x <- gsub(paste0("[,.]?\\s*", suffix_pattern, "[.]?"), "", x, perl = TRUE)

  x <- gsub("[[:punct:]]+$", "", x)
  x <- trimws(x)
  x <- gsub("\\s+", " ", x)
  x <- gsub("\\.", "", x)

  return(x)
}
