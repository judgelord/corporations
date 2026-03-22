# Subset corporations based on user filters

Creates a subset of corporation data based on particular kinds of
corporations that a user would like to know more about. (e.g., companies
with stock tickers, by NAICS code)

## Usage

``` r
filter(
  naics_codes = NULL,
  public_only = FALSE,
  search_term = NULL,
  corporations_return_cols = c("aliases", "cik", "FED_RSSD")
)
```

## Arguments

- naics_codes:

  Optional vector of NAICS codes to filter the dictionary. If NULL
  (default), all industries are included.

- public_only:

  Logical; if TRUE, subsets the dictionary to only include corporations
  with stock tickers.

- search_term:

  Optional character string; if provided, filters the company names
  using a partial string match (case-insensitive).

- corporations_return_cols:

  Optional vector of column names to include from the built-in
  corporations data (e.g., "FED_RSSD", "CIK").

- verbose:

  Logical; if TRUE, displays progress messages.

## Value

A tibble containing the filtered subset of the corporations database,
including columns such as \`aliases\`, \`ticker\`, \`cik\`, and
\`naics\`.
