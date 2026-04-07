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
#>  [1] "Trump administration sets up to 100% tariffs on some imported drugs"                 
#>  [2] "CNBC Sport"                                                                          
#>  [3] "Regional sports networks are faltering even as ratings soar"                         
#>  [4] "Inside Wealth"                                                                       
#>  [5] "Family offices stall deal-making during Iran conflict"                               
#>  [6] "Restaurants"                                                                         
#>  [7] "Starbucks to award bonuses to baristas, expand tipping to promote turnaround efforts"
#>  [8] ""                                                                                    
#>  [9] "Finance"                                                                             
#> [10] "Blue Owl caps private credit funds redemptions at 5% after steep request levels"     
#> [11] ""                                                                                    
#> [12] "Inside Wealth"                                                                       
#> [13] "What happens when wealthy parents try to claw back money from their kids"            
#> [14] ""                                                                                    
#> [15] "Retail"                                                                              
#> [16] "Thorne is on pace for $650M in revenue as Gen Z fuels a boom"                        
#> [17] "Restaurants"                                                                         
#> [18] "Coca-Cola unveils ad campaign with 13 restaurant chains to boost drink sales"        
#> [19] "Health and Science"                                                                  
#> [20] "FDA approves Eli Lilly's GLP-1 pill, opening next phase for weight loss drugs"       
#> [21] "Health and Science"                                                                  
#> [22] "Eli Lilly opposes White House push to codify most favored nation drug pricing"       
#> [23] ""                                                                                    
#> [24] "Retail"                                                                              
#> [25] "Wall Street loses patience with Nike as turnaround drags, China weakness deepens "   
#> [26] ""                                                                                    
#> [27] "Retail"                                                                              
#> [28] "Walmart-owned Sam's Club raises its annual membership fee to $60 "                   
#> [29] ""                                                                                    
#> [30] "CNBC Sport"                                                                          
#> [31] "Tiger Woods won't captain 2027 Ryder Cup team as golf future remains uncertain"
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
