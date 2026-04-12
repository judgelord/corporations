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
#>  [1] "The U.S. housing markets where million-dollar listings are standard"                       
#>  [2] "Retail"                                                                                    
#>  [3] "Why the U.S. Navy’s retail business is fighting Walmart and Amazon to fund its own future "
#>  [4] "Airlines"                                                                                  
#>  [5] "Delta cuts growth plans, sees $300 million boost from its refinery"                        
#>  [6] "Retail"                                                                                    
#>  [7] "Levi Strauss revenue jumps, as DTC makes up more than half of sales for first time"        
#>  [8] ""                                                                                          
#>  [9] "Airlines"                                                                                  
#> [10] "Jet fuel supply concerns grow with Iran war as airlines cut flights"                       
#> [11] ""                                                                                          
#> [12] "Airlines"                                                                                  
#> [13] "Delta, Southwest raise checked bag fees $10 amid jet fuel price surge"                     
#> [14] ""                                                                                          
#> [15] "CNBC Property Play"                                                                        
#> [16] "Iran war upends spring housing market. Here's what real estate agents are seeing"          
#> [17] "Health and Science"                                                                        
#> [18] "Novo Nordisk's Wegovy pill launch draws a new wave of patients into GLP-1s"                
#> [19] "Autos"                                                                                     
#> [20] "Chrysler CEO touts minivan 'resurgence' but stays quiet on plans"                          
#> [21] "Health and Science"                                                                        
#> [22] "Trump admin finalizes better-than-feared Medicare Advantage payment rate"                  
#> [23] ""                                                                                          
#> [24] "Finance"                                                                                   
#> [25] "Jamie Dimon in annual letter cites risks in geopolitics, AI and private markets"           
#> [26] ""                                                                                          
#> [27] "Entertainment"                                                                             
#> [28] "The Chinese box office isn't the Hollywood kingmaker it used to be. Here's why"            
#> [29] ""                                                                                          
#> [30] "Politics"                                                                                  
#> [31] "Trump tariff fallout: Industries grapple with lingering effects one year later"
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
