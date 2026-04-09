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
#>  [1] "Entertainment"                                                                       
#>  [2] "The Chinese box office isn't the Hollywood kingmaker it used to be. Here's why"      
#>  [3] "Politics"                                                                            
#>  [4] "Trump tariff fallout: Industries grapple with lingering effects one year later"      
#>  [5] "Inside Wealth"                                                                       
#>  [6] "The cost to fly private is up as much as 20% with fuel prices soaring"               
#>  [7] ""                                                                                    
#>  [8] "Airlines"                                                                            
#>  [9] "Basic business class is here with new, stripped-down United Polaris fares"           
#> [10] ""                                                                                    
#> [11] "Airlines"                                                                            
#> [12] "United Airlines hikes checked bag fee by $10 as fuel prices continue to climb"       
#> [13] ""                                                                                    
#> [14] "Health and Science"                                                                  
#> [15] "Trump administration sets up to 100% tariffs on some imported drugs"                 
#> [16] "CNBC Sport"                                                                          
#> [17] "Regional sports networks are faltering even as ratings soar"                         
#> [18] "Inside Wealth"                                                                       
#> [19] "Family offices stall deal-making during Iran conflict"                               
#> [20] "Restaurants"                                                                         
#> [21] "Starbucks to award bonuses to baristas, expand tipping to promote turnaround efforts"
#> [22] ""                                                                                    
#> [23] "Finance"                                                                             
#> [24] "Blue Owl caps private credit funds redemptions at 5% after steep request levels"     
#> [25] ""                                                                                    
#> [26] "Inside Wealth"                                                                       
#> [27] "What happens when wealthy parents try to claw back money from their kids"            
#> [28] ""                                                                                    
#> [29] "Retail"                                                                              
#> [30] "Thorne is on pace for $650M in revenue as Gen Z fuels a boom"                        
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
#> # A tibble: 0 × 0
```
