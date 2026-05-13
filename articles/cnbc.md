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
#>  [1] "Advertising"                                                                      
#>  [2] "At TV upfronts, AI is in and corporate shuffles are reshaping the lineup"         
#>  [3] "Retail"                                                                           
#>  [4] "Target is trying to win back busy families, starting with the baby aisle"         
#>  [5] "Media"                                                                            
#>  [6] "Meet the YouTube advisors behind MrBeast and other million-dollar channels"       
#>  [7] ""                                                                                 
#>  [8] "Autos"                                                                            
#>  [9] "Why one of the largest U.S. auto lenders isn't worried about 'forever loans'"     
#> [10] ""                                                                                 
#> [11] "Restaurants"                                                                      
#> [12] "Dunkin' owner Inspire Brands confidentially files for IPO"                        
#> [13] ""                                                                                 
#> [14] "Health and Science"                                                               
#> [15] "Fitness wearable Whoop to offer on-demand clinician access to U.S. users"         
#> [16] "Inside Wealth"                                                                    
#> [17] "Trump's $1 million 'Gold Card' fails to catch on among the world's wealthy "      
#> [18] "Inside Wealth"                                                                    
#> [19] "States crack down on tax break for wealthy investors"                             
#> [20] "CNBC Sport"                                                                       
#> [21] "CNBC Sport: Media 'upfront' advertising presentations have become an NFL showcase"
#> [22] ""                                                                                 
#> [23] "Restaurants"                                                                      
#> [24] "While many international brands retreat, McDonald’s is growing in China"          
#> [25] ""                                                                                 
#> [26] "Autos"                                                                            
#> [27] "Used car prices fall for first time this year as gas prices spike"                
#> [28] ""                                                                                 
#> [29] "Restaurants"                                                                      
#> [30] "McDonald's CEO says consumer spending could be 'getting a little bit worse'"      
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

results
#> # A tibble: 5 × 7
#>   row_id headline aliases                              cik ticker pattern  match
#>    <int> <chr>    <chr>                              <dbl> <chr>  <chr>    <chr>
#> 1      2 YouTube  Youtube Inc                      1343726 ""     "\\b(?:… YouT…
#> 2      8 Science  Science Corp                     1873836 ""     "\\b(?:… Scie…
#> 3      8 Science  Science Inc                       828325 ""     "\\b(?:… Scie…
#> 4      9 Whoop    Bobo Analytics, Inc.|Whoop, Inc. 1582746 ""     "\\b(?:… Whoop
#> 5     12 Card     Card Corp                        1629260 ""     "\\b(?:… Card
```
