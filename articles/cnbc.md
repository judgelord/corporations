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
#>  [1] "Inside Wealth"                                                                   
#>  [2] "Iran war wipes out $100 billion from luxury stocks"                              
#>  [3] "Autos"                                                                           
#>  [4] "Infiniti hopes new SUV can turn around fortunes in the U.S."                     
#>  [5] "Airlines"                                                                        
#>  [6] "American is 'seriously considering' bringing back seat-back screens "            
#>  [7] ""                                                                                
#>  [8] "Retail"                                                                          
#>  [9] "Target faces a new boycott over ICE response as retailer carries out turnaround" 
#> [10] ""                                                                                
#> [11] "Airlines"                                                                        
#> [12] "United Airlines, flight attendants reach labor deal, with raises"                
#> [13] ""                                                                                
#> [14] "CNBC Sport"                                                                      
#> [15] "MLB faces a historic shift as potential lockout, media and league changes loom"  
#> [16] "Retail"                                                                          
#> [17] "Major outgoing CEOs are citing AI as a factor in their decisions to step down"   
#> [18] "CNBC Sport"                                                                      
#> [19] "Tom Brady says he asked NFL about potential comeback, but doesn't plan to return"
#> [20] "Real Estate"                                                                     
#> [21] "Fannie Mae accepts first crypto-backed mortgage product"                         
#> [22] ""                                                                                
#> [23] "Retail"                                                                          
#> [24] "Olaplex to be acquired by German company Henkel in $1.4 billion deal"            
#> [25] ""                                                                                
#> [26] "Inside Wealth"                                                                   
#> [27] "Family offices make opportunistic bets on real estate"                           
#> [28] ""                                                                                
#> [29] "Airlines"                                                                        
#> [30] "Trump says he could send National Guard to airports 'for more help'"             
#> [31] "CNBC Property Play"
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
