# Extract corporate name matches from text

Searches user-provided text against the built-in corporations database
and returns matches with associated metadata (e.g., CIK, FED_RSSD).

## Usage

``` r
extract(
  data,
  col_name = "text",
  method = c("exact", "token"),
  mode = c("match", "search"),
  data_return_cols = NULL,
  regex_return_cols = NULL,
  remove_acronyms = FALSE,
  do_clean_text = TRUE,
  verbose = TRUE,
  unique_match = FALSE,
  cl = NULL
)
```

## Arguments

- data:

  A data frame or character vector containing the text to search.

- col_name:

  Column name in the data frame containing text to search through.
  Default is "text".

- method:

  String; "exact" (one to one match of name strings) or "token"
  (matching based on a token score).

- mode:

  String; "match" (direct comparison) or "search" (extract from long
  text).

- data_return_cols:

  Optional vector of column names to include from the input 'data'.

- regex_return_cols:

  Optional vector of column names to include from the built-in
  corporations data (e.g., "FED_RSSD", "CIK").

- remove_acronyms:

  Logical; if TRUE, removes all-uppercase patterns from the search.

- do_clean_text:

  Logical; if TRUE, applies basic text cleaning to the input before
  matching.

- verbose:

  Logical; if TRUE, displays progress messages.

- unique_match:

  Logical; if TRUE, stops searching after first match to find at most
  one match per row. If FALSE, returns all matches for all patterns.

- cl:

  A cluster object or integer for parallel evaluation via
  \[pbapply::pblapply()\].

## Value

A tibble with columns: \`row_id\`, selected \`data\` columns, selected
\`regex_return_cols\`, \`pattern\`, and \`match\`.
