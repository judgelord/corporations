

<!--DO NOT EDIT .md file, only README.qmd-->

# corporations

## Description

`corporations` extracts regular-expression-based pattern matches from a
vector of text using a built-in extensive crosswalk table of
corporations. This includes companies with a central index key (a unique
10-digit, permanent identification number assigned by the U.S.
Securities and Exchange Commission), Compustat (database managed by the
S&P Global Market Intelligence), and FDIC-insured companies. The
corprations_extract function requires one inputs

1.  `input_data`: A vector of text to search (typically a data frame
    with a `text` column)

For each matching substring, `corprations::corporations_extract` returns

- the row number of `data`  
- the `pattern`
- the matched substring
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
