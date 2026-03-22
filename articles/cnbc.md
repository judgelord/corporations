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
#>  [1] "Media"                                                                               
#>  [2] "Disney embarks on new chapter as Josh D'Amaro takes over as CEO "                    
#>  [3] "Finance"                                                                             
#>  [4] "JPMorgan taps A'ja Wilson, Tom Brady for athlete wealth management push"             
#>  [5] "Health and Science"                                                                  
#>  [6] "FDA approves psoriasis pill from J&J that rivals shots Tremfya, Skyrizi"             
#>  [7] ""                                                                                    
#>  [8] "Retail"                                                                              
#>  [9] "Macy's store revamp shows progress, but company expects sales to fall this year"     
#> [10] ""                                                                                    
#> [11] "Retail"                                                                              
#> [12] "Lululemon reports weak guidance as proxy battle, tariffs weigh on bottom line"       
#> [13] ""                                                                                    
#> [14] "Airlines"                                                                            
#> [15] "Airlines raise revenue guidance, citing growth in demand"                            
#> [16] "Prediction Markets"                                                                  
#> [17] "Arizona charges Kalshi with criminal misdemeanors, alleging illegal gambling"        
#> [18] "Autos"                                                                               
#> [19] "Nissan joins Toyota, Honda in plans to export U.S. cars to Japan"                    
#> [20] "CNBC Property Play"                                                                  
#> [21] "Apartment concessions hit highest level in over a decade"                            
#> [22] ""                                                                                    
#> [23] "Autos"                                                                               
#> [24] "Nvidia adds Hyundai, BYD and other automakers to self-driving tech business"         
#> [25] ""                                                                                    
#> [26] "Finance"                                                                             
#> [27] "Apollo exec questions private equity's software loans: 'All the marks are wrong'"    
#> [28] ""                                                                                    
#> [29] "Retail"                                                                              
#> [30] "Peloton is launching bikes and treadmills for gyms, accelerating commercial strategy"
#> [31] "Entertainment"
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
