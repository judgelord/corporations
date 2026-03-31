# corporations_data dataset

A crosswalk lookup table of hundreds of thousands of corporations for
regular expression matching and company searching

## Format

A tibble with 5 columns:

- aliases:

  aliases of a certain company (each one seperated by '\|')

- cik:

  Central Index Key of a corporation (numeric)

- FED_RSSD:

  Research, Statistics, Supervision, and Discount identifier (numeric)

- ticker:

  Stock ticker of a corporation

- naics:

  North American Industry Classification System (NAICS) codes (numeric)

## Source

Generated for the \`corporations\` package
