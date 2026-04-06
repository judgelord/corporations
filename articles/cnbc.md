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
#>  [2] "FDA approves Eli Lilly's GLP-1 pill, opening next phase for weight loss drugs"        
#>  [3] "Health and Science"                                                                   
#>  [4] "Eli Lilly opposes White House push to codify most favored nation drug pricing"        
#>  [5] "Retail"                                                                               
#>  [6] "Wall Street loses patience with Nike as turnaround drags, China weakness deepens "    
#>  [7] ""                                                                                     
#>  [8] "Retail"                                                                               
#>  [9] "Walmart-owned Sam's Club raises its annual membership fee to $60 "                    
#> [10] ""                                                                                     
#> [11] "CNBC Sport"                                                                           
#> [12] "Tiger Woods won't captain 2027 Ryder Cup team as golf future remains uncertain"       
#> [13] ""                                                                                     
#> [14] "Finance"                                                                              
#> [15] "Visa launches new AI tools to manage the charge dispute process"                      
#> [16] "CNBC Property Play"                                                                   
#> [17] "Apartment rents weaken further as war and job cuts weigh on demand"                   
#> [18] "Autos"                                                                                
#> [19] "Volkswagen deal with EV maker Xpeng shows how China tech threatens Western automakers"
#> [20] "Retail"                                                                               
#> [21] "Nike shares fall 9% on weak outlook, expected 20% sales decline in China "            
#> [22] ""                                                                                     
#> [23] "CNBC Sport"                                                                           
#> [24] "Tom Brady, famed health nut, explains his junk food endorsements in retirement"       
#> [25] ""                                                                                     
#> [26] "Autos"                                                                                
#> [27] "Mercedes U.S. CEO sets ambitious sales goal despite 'tougher' market"                 
#> [28] ""                                                                                     
#> [29] "Entertainment"                                                                        
#> [30] "'Project Hail Mary' is the box office proof point Amazon has been waiting for"        
#> [31] "Food & Beverage"
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
