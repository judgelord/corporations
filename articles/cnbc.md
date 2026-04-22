# CNBC

## Find corporation names in messy website text with inconsistent name formats of the latest CNBC business news headlines

### load packages

``` r
library(corporations)
```

This vignette also uses `rvest`.

``` r
library(rvest) # for web scraping 
```

### Corporations Mentioned on the CNBC business page

Using `rvest` we scrape the cnbc.com and get all linked stories.

``` r
html <- read_html("https://www.cnbc.com/business/") # The CNBC Business page
links <- html_nodes(html, "a") # "a" nodes are linked text

cnbc <- html_text(links)

cnbc <- cnbc[160:190]
cnbc
#>  [1] "Food & Beverage"                                                               
#>  [2] "Some grocers are using AI to cut food waste and boost profit margins"          
#>  [3] "Media"                                                                         
#>  [4] "Netflix reiterates guidance, says Reed Hastings to exit board"                 
#>  [5] "Health and Science"                                                            
#>  [6] "Trump nominates Erica Schwartz as CDC director"                                
#>  [7] ""                                                                              
#>  [8] "Health and Science"                                                            
#>  [9] "RFK Jr.'s peptide policy could boost Hims & Hers as its GLP-1 business evolves"
#> [10] ""                                                                              
#> [11] "Airlines"                                                                      
#> [12] "Airline CEOs urged by lawmaker to lower fares if fuel prices come down"        
#> [13] ""                                                                              
#> [14] "Inside Wealth"                                                                 
#> [15] "How the wealthy are planning to cut their 2026 tax bills"                      
#> [16] "Autos"                                                                         
#> [17] "Why foreign automakers dominate the sedan market"                              
#> [18] "Restaurants"                                                                   
#> [19] "PepsiCo earnings beat estimates as Doritos, Lay's price cuts win back shoppers"
#> [20] "Airlines"                                                                      
#> [21] "Spirit Airlines could liquidate as early as this week, sources say"            
#> [22] ""                                                                              
#> [23] "Finance"                                                                       
#> [24] "Goldman Sachs bond traders stumbled as Wall Street rivals thrived"             
#> [25] ""                                                                              
#> [26] "Autos"                                                                         
#> [27] "Ford EV chief leaving automaker amid new restructuring efforts"                
#> [28] ""                                                                              
#> [29] "Travel"                                                                        
#> [30] "For cruise lines, Iran conflict and oil prices threaten to dent profits"       
#> [31] "Restaurants"
```

``` r
# Load the data as a tibble (dataframe) and remove empty strings
cnbc_df <- data.frame(headline = cnbc, stringsAsFactors = FALSE)
cnbc_df <- cnbc_df[trimws(cnbc_df$headline) != "", , drop = FALSE]

# Run the extract function
# Note: we tell the function to look in the "headline" column
results <- corporations::extract(
  data = cnbc_df,
  col_name = "headline",
  mode = "search",
  regex_return_cols = c("aliases", "cik", "ticker"),
  verbose = TRUE
 )

results %>% head() %>% print(width = Inf)
#> # A tibble: 6 × 7
#>   row_id headline aliases                                      cik ticker 
#>    <int> <chr>    <chr>                                      <dbl> <chr>  
#> 1      5 Science  Science Corp                             1873836 ""     
#> 2      5 Science  Science Inc                               828325 ""     
#> 3      7 CDC      Cdc Corp|China Com Corp|Chinadotcom Corp 1076770 "CDCAQ"
#> 4      7 CDC      Cdc Corp                                 1395500 ""     
#> 5      9 Science  Science Corp                             1873836 ""     
#> 6      9 Science  Science Inc                               828325 ""     
#>   pattern                               match  
#>   <chr>                                 <chr>  
#> 1 "\\b(?:science)\\b"                   Science
#> 2 "\\b(?:science)\\b"                   Science
#> 3 "\\b(?:cdc|china com|chinadotcom)\\b" CDC    
#> 4 "\\b(?:cdc)\\b"                       CDC    
#> 5 "\\b(?:science)\\b"                   Science
#> 6 "\\b(?:science)\\b"                   Science
```
