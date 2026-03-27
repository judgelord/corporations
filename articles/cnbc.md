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
#>  [1] "Politics"                                                                            
#>  [2] "Delta suspends air travel perk for members of Congress due to DHS shutdown"          
#>  [3] "Finance"                                                                             
#>  [4] "Jamie Dimon says Iran war makes Middle East peace prospects better long-term"        
#>  [5] "CNBC Property Play"                                                                  
#>  [6] "Home flippers see smallest profits since Great Recession, real estate data firm says"
#>  [7] ""                                                                                    
#>  [8] "Inside Wealth"                                                                       
#>  [9] "More women enter wealth management, but few in advisory roles, study finds"          
#> [10] ""                                                                                    
#> [11] "Retail"                                                                              
#> [12] "Gap says it will launch checkout within Google's Gemini AI platform"                 
#> [13] ""                                                                                    
#> [14] "Autos"                                                                               
#> [15] "EV battery startup pivots to defense industry amid Iran war"                         
#> [16] "Airlines"                                                                            
#> [17] "United Airlines ditches more economy seats for bigger premium cabins"                
#> [18] "Finance"                                                                             
#> [19] "Moody's cuts rating on private credit fund co-run by KKR to junk on bad loans"       
#> [20] "Air Freight and Logistics"                                                           
#> [21] "FedEx launches same-day delivery with OneRail to rival Amazon, Walmart"              
#> [22] ""                                                                                    
#> [23] "CNBC Sport"                                                                          
#> [24] "Pro Padel League raises $15 million as investors bet on sport’s U.S. growth"         
#> [25] ""                                                                                    
#> [26] "Finance"                                                                             
#> [27] "Apollo gives investors 45% of requested withdrawals from private credit fund"        
#> [28] ""                                                                                    
#> [29] "Retail"                                                                              
#> [30] "Estée Lauder is in talks to merge with Puig amid ongoing turnaround plan"            
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
