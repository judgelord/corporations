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
#>  [2] "Family offices make opportunistic bets on real estate"                               
#>  [3] "Airlines"                                                                            
#>  [4] "Trump says he could send National Guard to airports 'for more help'"                 
#>  [5] "CNBC Property Play"                                                                  
#>  [6] "JLL CEO says growth is now uncertain in the Middle East"                             
#>  [7] ""                                                                                    
#>  [8] "Politics"                                                                            
#>  [9] "Delta suspends air travel perk for members of Congress due to DHS shutdown"          
#> [10] ""                                                                                    
#> [11] "Finance"                                                                             
#> [12] "Jamie Dimon says Iran war makes Middle East peace prospects better long-term"        
#> [13] ""                                                                                    
#> [14] "CNBC Property Play"                                                                  
#> [15] "Home flippers see smallest profits since Great Recession, real estate data firm says"
#> [16] "Inside Wealth"                                                                       
#> [17] "More women enter wealth management, but few in advisory roles, study finds"          
#> [18] "Retail"                                                                              
#> [19] "Gap says it will launch checkout within Google's Gemini AI platform"                 
#> [20] "Autos"                                                                               
#> [21] "EV battery startup pivots to defense industry amid Iran war"                         
#> [22] ""                                                                                    
#> [23] "Airlines"                                                                            
#> [24] "United Airlines ditches more economy seats for bigger premium cabins"                
#> [25] ""                                                                                    
#> [26] "Finance"                                                                             
#> [27] "Moody's cuts rating on private credit fund co-run by KKR to junk on bad loans"       
#> [28] ""                                                                                    
#> [29] "Air Freight and Logistics"                                                           
#> [30] "FedEx launches same-day delivery with OneRail to rival Amazon, Walmart"              
#> [31] "CNBC Sport"
```

``` r
# Load the data as a tibble (dataframe) and remove empty strings
cnbc_df <- data.frame(headline = cnbc, stringsAsFactors = FALSE)
cnbc_df <- cnbc_df[trimws(cnbc_df$headline) != "", , drop = FALSE]

# Run the extract function
# Note: we tell the function to look in the "headline" column
results <- extract(
  data = cnbc_df,
  col_name = "headline",
  mode = "search",
  regex_return_cols = c("aliases", "cik"),
  verbose = TRUE
 )
#> Would you like to download the model now? (Yes/no/cancel)

results %>% head() %>% print(width = Inf)
#> # A tibble: 0 × 0
```
