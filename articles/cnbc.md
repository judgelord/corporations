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
#>  [1] "Retail"                                                                                    
#>  [2] "Why the U.S. Navy’s retail business is fighting Walmart and Amazon to fund its own future "
#>  [3] "Airlines"                                                                                  
#>  [4] "Delta cuts growth plans, sees $300 million boost from its refinery"                        
#>  [5] "Retail"                                                                                    
#>  [6] "Levi Strauss revenue jumps, as DTC makes up more than half of sales for first time"        
#>  [7] ""                                                                                          
#>  [8] "Airlines"                                                                                  
#>  [9] "Jet fuel supply concerns grow with Iran war as airlines cut flights"                       
#> [10] ""                                                                                          
#> [11] "Airlines"                                                                                  
#> [12] "Delta, Southwest raise checked bag fees $10 amid jet fuel price surge"                     
#> [13] ""                                                                                          
#> [14] "CNBC Property Play"                                                                        
#> [15] "Iran war upends spring housing market. Here's what real estate agents are seeing"          
#> [16] "Health and Science"                                                                        
#> [17] "Novo Nordisk's Wegovy pill launch draws a new wave of patients into GLP-1s"                
#> [18] "Autos"                                                                                     
#> [19] "Chrysler CEO touts minivan 'resurgence' but stays quiet on plans"                          
#> [20] "Health and Science"                                                                        
#> [21] "Trump admin finalizes better-than-feared Medicare Advantage payment rate"                  
#> [22] ""                                                                                          
#> [23] "Finance"                                                                                   
#> [24] "Jamie Dimon in annual letter cites risks in geopolitics, AI and private markets"           
#> [25] ""                                                                                          
#> [26] "Entertainment"                                                                             
#> [27] "The Chinese box office isn't the Hollywood kingmaker it used to be. Here's why"            
#> [28] ""                                                                                          
#> [29] "Politics"                                                                                  
#> [30] "Trump tariff fallout: Industries grapple with lingering effects one year later"            
#> [31] "Inside Wealth"
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
