#' @title Report corporations matches
#' @description Flag incorrect name matches or suggest missing aliases.
#' @param results The tibble returned from the extract() function.
#' @export
report_fix <- function(results) {

  message("--- Name Match Review ---")
  print(results[, setdiff(names(results), c("row_id", "cik", "ticker", "naics"))])

  action <- readline(prompt = "\nChoose an action:\n1: A match is WRONG\n2: A match is MISSING\n3: Exit\nSelection: ")

  if (action == "3" || action == "") return(invisible(NULL))

  # The match is wrong
  if (action == "1") {
    row_idx <- as.numeric(readline(prompt = "Which row number is wrong? "))

    if (is.na(row_idx) || row_idx > nrow(results) || row_idx < 1) {
      message("Invalid selection.")
      return(invisible(NULL))
    }

    wrong_name <- results$match[row_idx]
    message(paste0("\nYou flagged '", wrong_name, "' as incorrect."))

    correct_name <- readline(prompt = "What is a correct company alias for this entry? ")
    description  <- readline(prompt = "Optional: Provide a brief description/reason for this fix: ")

    send_to_github(input = wrong_name, suggestion = correct_name, type = "Correction", desc = description)
  }

  # A match is missing
  if (action == "2") {
    missing_input <- readline(prompt = "What text in your data did the algorithm miss an alias for? (e.g. 'BP'): ")
    correct_name  <- readline(prompt = "Which company name should it have matched to? ")
    description   <- readline(prompt = "Optional: Provide a brief description/reason for this fix: ")

    send_to_github(input = missing_input, suggestion = correct_name, type = "Missing Alias", desc = description)
  }
}

#' @noRd
send_to_github <- function(input, suggestion, type, desc = "") {

  desc_text <- if (nchar(trimws(desc)) > 0) desc else "No additional description provided."

  body_content <- paste0(
    "### Name Match Feedback (", type, ")\n\n",
    "- **Text found in user data:** `", input, "`\n",
    "- **Should match this company name:** `", suggestion, "`\n",
    "- **Description/Notes:** ", desc_text, "\n\n",
    "Please update the main corporations data crosswalk."
  )

  base_url <- "https://github.com/judgelord/corporations/issues/new"

  issue_title <- URLencode(paste0(type, ": ", input), reserved = TRUE)
  issue_body  <- URLencode(body_content, reserved = TRUE)

  final_url <- paste0(base_url, "?title=", issue_title, "&body=", issue_body)

  message("\nOpening GitHub to submit your feedback...")

  utils::browseURL(final_url)
}
