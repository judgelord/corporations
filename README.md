

<!--DO NOT EDIT .md file, only README.qmd-->

# corporations

## Description

The `corporations` `extract()` function is a regular-expression-based
pattern match tool to match vector of text with a built-in extensive
crosswalk table of corporations using the
[regextable](https://github.com/judgelord/regextable) package as a
dependency. The crosswalk table includes companies with a central index
key (a unique 10-digit, permanent identification number assigned by the
U.S. Securities and Exchange Commission), Compustat (database managed by
the S&P Global Market Intelligence), and FDIC-insured companies. The
`extract()` function requires one input

1.  `input_data`: A vector of text to search (typically a data frame
    with a `text` column)

For each matching substring, `corprations::extract` returns

- the row number of `data`
- the `text` column from `data`
- the `pattern`
- the matched substring
- the `confidence_score` based on Jaro-Winkler similarity matching to
  for result ordering purposes
- Optionally, other columns in `input_data` or the `corporations_data`

## Installation

    devtools::install_github("judgelord/corporations")

``` r
library(corporations)
```

## Data

The examples below use an subset of the corporations_data crosswalk
table of members of corporations and a example text data from the listed
contributors in Project 2025’s “Mandate for Leadership: The Conservative
Promise”.

``` r
data("project_2025_coalition_and_contributors")
head(project_2025_coalition_and_contributors)
#>           type                        organization individual                  role
#> 1 Organization            Alabama Policy Institute            Advisory Board Member
#> 2 Organization          Alliance Defending Freedom            Advisory Board Member
#> 3 Organization  American Accountability Foundation            Advisory Board Member
#> 4 Organization American Center for Law and Justice            Advisory Board Member
#> 5 Organization                    American Compass            Advisory Board Member
#> 6 Organization           The American Conservative            Advisory Board Member

data("corporations_data_sample")
head(corporations_data_sample)
#>                                                      aliases                                                clean_alias
#> 1   DEFINED ASSET FUNDS MUNICIPAL INVT TR FD NEW YORK SER 33   defined asset funds municipal invt tr fd new york ser 33
#> 2      CORPORATE INCOME FUND SEVENTY NINTH SHORT TERM SERIES      corporate income fund seventy ninth short term series
#> 3  DEFINED ASSET FUNDS MUNICIPAL INVT TR FD MON PYMT SER 155  defined asset funds municipal invt tr fd mon pymt ser 155
#> 4  DEFINED ASSET FUNDS MUNICIPAL INVT TR FD MON PYMT SER 156  defined asset funds municipal invt tr fd mon pymt ser 156
#> 5 NUVEEN TAX EXEMPT UNIT TRUST SERIES 169 NATIONAL TRUST 169 nuveen tax exempt unit trust series 169 national trust 169
#> 6          K TRON INTERNATIONAL INC|K Tron International Inc                                       k tron international
#>   cik FED_RSSD ticker naics sources
#> 1   3       NA   <NA>    NA     cik
#> 2  13       NA   <NA>    NA     cik
#> 3  14       NA   <NA>    NA     cik
#> 4  17       NA   <NA>    NA     cik
#> 5  18       NA   <NA>    NA     cik
#> 6  20       NA   KTII    NA cik,sec
```

## Text cleaning

Before matching, by default, `clean_text()` from the
[regextable](https://github.com/judgelord/regextable) is applied to
standardize text for better matching in messy text. It converts text to
lowercase, removes excess punctuation, replaces line breaks and dashes
with spaces, and collapses multiple spaces into a single space. Text
cleaning is applied only during matching and does not modify the
original input data. Users can disable this behavior by setting
`do_clean_text = FALSE`.

``` r
text <- "  HELLO---WORLD  "
cleaned_text <- regextable::clean_text(text)
print(cleaned_text)
#> [1] "hello world"
```

## The function supports two distinct modes of operation:

1.  `match` (Default): Direct comparison. Best for short strings or
    lists of entities where you expect the text to be a company name.

2.  `search`: Deep extraction. Uses an NLP model (UDpipe) to identify
    Proper Nouns within longer unstructured text (sentences) before
    running the regex match. NOTE: When using mode = “search”, the
    package will prompt you to download a ~15MB NLP model on its first
    run. This model allows the package to “read” the sentence structure.

## Extract regex-based matches from text

### Description

`extract()` performs regex-based matching on a text column using the
corporations lookup table. All patterns that match each row are first
filtered based on a token similarity scoring system. Then the matches
that are confident are returned along with the corresponding pattern and
optional metadata from the corporations table. If multiple patterns
match the same text, multiple rows are returned, one per match.

### Required Parameters

- **`data`**: A data frame or character vector containing the text to
  search.

### Optional Parameters

- **`col_name`**: (default `"text"`) Column name in the data frame
  containing text to search through.
- **`mode`**: (default `match`) Use `match` for direct matching or
  `search` for matching after extraction from longer text.
- **`data_return_cols`**: (default `NULL`) Vector of additional columns
  from `data` to include in the output.
- **`regex_return_cols`**: (default `NULL`) Vector of additional columns
  from `corporations_data` to include in the output (e.g., “FED_RSSD”,
  “CIK”).
- **do_fuzzy_matching**: (default `TRUE`) If TRUE, applies fuzzy
  matching to the regular expression matches and includes another column
  of confidence scores for the matches.
- **`remove_acronyms`**: (default `FALSE`) If `TRUE`, removes
  all-uppercase patterns from `regex_table`.
- **`do_clean_text`**: (default `TRUE`) If `TRUE`, cleans text before
  matching.
- **`verbose`**: (default `TRUE`) If `TRUE`, displays progress messages.
- **`unique_match`** (default `FALSE`) If `TRUE`, stops searching after
  first match to find at most one match per row.
- **`cl`**: (default `NULL`) A cluster object or integer specifying
  child processes for parallel evaluation (ignored on Windows).

## Filtering and Verification

Matches are automatically filtered using a token verification check. The
function identifies “significant” words (ignoring suffixes like “Inc” or
“Corp”) and requires at least a 60% overlap between the input text and
the corporations data entry to be considered a valid match.

### Returns

A data frame with one row per match, including:

- `row_id`: the internal row number of the text in the input data
- the `col_name` (default “text”) column from `data`
- Optional columns from the input data (if data_return_cols specified)
- Optional columns from `corporations_data` (if regex_return_cols
  specified)
- `pattern`: the regex pattern matched
- `match`: the substring matched in the text
- `simililarity`: this is the similarity matching score based on
  Jaro-Winkler Similarity of the filtered results for ordering purposes

### Basic Usage

The simplest use of `extract()` with only the required arguments and
specific return columns specified that demonstrate use cases. This finds
all matches in the text column using the `corporations_data` and allows
users to directly link company names with unique identifiers, determine
which are publicly traded companies, and more.

``` r
# Extract patterns using only required arguments and the default mode = "match"
result <- extract(
  data = project_2025_coalition_and_contributors,
  col_name = "organization",
  data_return_cols = c("organization"),
  regex_return_cols = c("cik", "FED_RSSD", "ticker", "naics", "sources")
)

head(result)
#> # A tibble: 6 × 10
#>   row_id organization                        cik FED_RSSD ticker  naics sources           pattern       match similarity
#>    <int> <chr>                             <dbl>    <dbl> <chr>   <dbl> <chr>             <chr>         <chr>      <dbl>
#> 1     47 Patrick Henry College           1205813       NA ""         NA cik               "\\b(?:patri… Patr…      1    
#> 2     71 Korn Ferry                        56679       NA "KFY"  561311 cik,compustat,sec "\\b(?:korn … Korn…      1    
#> 3     76 Booz Allen Hamilton               13222       NA ""         NA cik               "\\b(?:booz … Booz…      1    
#> 4     78 River Financial Inc.            1641601       NA ""         NA cik               "\\b(?:river… Rive…      1    
#> 5     78 River Financial Inc.            1846407       NA ""         NA cik               "\\b(?:river… Rive…      1    
#> 6     73 Taft Stettinius & Hollister LLP  909789       NA ""         NA cik               "\\b(?:taft … Taft…      0.957
```
