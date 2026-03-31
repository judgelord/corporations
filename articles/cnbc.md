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
#>  [1] "CNBC Sport"                                                                          
#>  [2] "Tom Brady says he asked NFL about potential comeback, but doesn't plan to return"    
#>  [3] "Real Estate"                                                                         
#>  [4] "Fannie Mae accepts first crypto-backed mortgage product"                             
#>  [5] "Retail"                                                                              
#>  [6] "Olaplex to be acquired by German company Henkel in $1.4 billion deal"                
#>  [7] ""                                                                                    
#>  [8] "Inside Wealth"                                                                       
#>  [9] "Family offices make opportunistic bets on real estate"                               
#> [10] ""                                                                                    
#> [11] "Airlines"                                                                            
#> [12] "Trump says he could send National Guard to airports 'for more help'"                 
#> [13] ""                                                                                    
#> [14] "CNBC Property Play"                                                                  
#> [15] "JLL CEO says growth is now uncertain in the Middle East"                             
#> [16] "Politics"                                                                            
#> [17] "Delta suspends air travel perk for members of Congress due to DHS shutdown"          
#> [18] "Finance"                                                                             
#> [19] "Jamie Dimon says Iran war makes Middle East peace prospects better long-term"        
#> [20] "CNBC Property Play"                                                                  
#> [21] "Home flippers see smallest profits since Great Recession, real estate data firm says"
#> [22] ""                                                                                    
#> [23] "Inside Wealth"                                                                       
#> [24] "More women enter wealth management, but few in advisory roles, study finds"          
#> [25] ""                                                                                    
#> [26] "Retail"                                                                              
#> [27] "Gap says it will launch checkout within Google's Gemini AI platform"                 
#> [28] ""                                                                                    
#> [29] "Autos"                                                                               
#> [30] "EV battery startup pivots to defense industry amid Iran war"                         
#> [31] "Airlines"
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
#> Would you like to download the model now? (Yes/no/cancel)

results %>% head() %>% print(width = Inf)
#> # A tibble: 0 × 0
```
