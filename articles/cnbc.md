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
#>  [1] "Restaurants"                                                                                                 
#>  [2] "Starbucks launches beta app in ChatGPT to fuel new drink discovery"                                          
#>  [3] "Airlines"                                                                                                    
#>  [4] "United CEO had been considering a merger last fall, months before bringing it up to the Trump administration"
#>  [5] "Finance"                                                                                                     
#>  [6] "Morgan Stanley tops estimates as trading revenue beats by nearly $1 billion "                                
#>  [7] ""                                                                                                            
#>  [8] "Food & Beverage"                                                                                             
#>  [9] "Nearly 60% of U.S. farmers say their finances are getting worse: Survey"                                     
#> [10] ""                                                                                                            
#> [11] "Finance"                                                                                                     
#> [12] "Bank of America tops estimates, CEO Moynihan says consumer banking is 'healthy'"                             
#> [13] ""                                                                                                            
#> [14] "Retail"                                                                                                      
#> [15] "Walmart is refreshing the look of Great Value, its largest private-label brand"                              
#> [16] "Finance"                                                                                                     
#> [17] "Dimon says Anthropic's Mythos reveals 'more vulnerabilities' for cyberattacks"                               
#> [18] "Airlines"                                                                                                    
#> [19] "What a United-American merger would mean, from antitrust hurdles to airfare"                                 
#> [20] "Autos"                                                                                                       
#> [21] "Lucid names auto industry outsider as CEO, expands Uber deal"                                                
#> [22] ""                                                                                                            
#> [23] "Finance"                                                                                                     
#> [24] "JPMorgan tops estimates on Wall Street results, Dimon warns of 'complex' risks"                              
#> [25] ""                                                                                                            
#> [26] "Finance"                                                                                                     
#> [27] "Citigroup beats estimates, boosted by gains in fixed income "                                                
#> [28] ""                                                                                                            
#> [29] "Inside Alts"                                                                                                 
#> [30] "Blackstone’s Solotar: Investors should separate private credit ‘signal from the noise’"                      
#> [31] "Media"
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
#> # A tibble: 0 × 0
```
