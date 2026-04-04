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
#>  [1] "Health and Science"                                                                   
#>  [2] "Eli Lilly opposes White House push to codify most favored nation drug pricing"        
#>  [3] "Retail"                                                                               
#>  [4] "Wall Street loses patience with Nike as turnaround drags, China weakness deepens "    
#>  [5] "Retail"                                                                               
#>  [6] "Walmart-owned Sam's Club raises its annual membership fee to $60 "                    
#>  [7] ""                                                                                     
#>  [8] "CNBC Sport"                                                                           
#>  [9] "Tiger Woods won't captain 2027 Ryder Cup team as golf future remains uncertain"       
#> [10] ""                                                                                     
#> [11] "Finance"                                                                              
#> [12] "Visa launches new AI tools to manage the charge dispute process"                      
#> [13] ""                                                                                     
#> [14] "CNBC Property Play"                                                                   
#> [15] "Apartment rents weaken further as war and job cuts weigh on demand"                   
#> [16] "Autos"                                                                                
#> [17] "Volkswagen deal with EV maker Xpeng shows how China tech threatens Western automakers"
#> [18] "Retail"                                                                               
#> [19] "Nike shares fall 9% on weak outlook, expected 20% sales decline in China "            
#> [20] "CNBC Sport"                                                                           
#> [21] "Tom Brady, famed health nut, explains his junk food endorsements in retirement"       
#> [22] ""                                                                                     
#> [23] "Autos"                                                                                
#> [24] "Mercedes U.S. CEO sets ambitious sales goal despite 'tougher' market"                 
#> [25] ""                                                                                     
#> [26] "Entertainment"                                                                        
#> [27] "'Project Hail Mary' is the box office proof point Amazon has been waiting for"        
#> [28] ""                                                                                     
#> [29] "Food & Beverage"                                                                      
#> [30] "McCormick buys Unilever food business in deal that values it at nearly $45 billion"   
#> [31] "Pharmaceuticals"
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
