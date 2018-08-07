

suffix <- 
"eggproducts.csv?v=42942"

reg <- "[a-z].csv\\?v=42942"

download.file()

here("../..", "fresh_fruit")



library(stringr)

base_url <- "https://www.ers.usda.gov/webdocs/DataFiles/50472/"

partial_paths <- c(
  "fruitfresh.csv?v=42942",
  "fruitfrozen.csv?v=42942",
  "fruitjuice.csv?v=42942"
)

full_paths <- 
  base_url %>% 
  str_c(partial_paths) 

download.file(full_paths[1],
              "some/path/fresh_fruit.csv"
)



if you look in the chrome inspector, all the CSVs have a path that follows the pattern `"[a-z]+\.csv\?v=42942"` (I didn't know you could use regex search in the inspector?!) after "https://www.ers.usda.gov/webdocs/DataFiles/50472/"

so it should be possible to create the full paths and download all the CSVs.

```                                                                                                         
library(stringr)

base_url <- "https://www.ers.usda.gov/webdocs/DataFiles/50472/"

partial_paths <- c(
  "fruitfresh.csv?v=42942",
  "fruitfrozen.csv?v=42942",
  "fruitjuice.csv?v=42942"
)

full_paths <- 
  base_url %>% 
  str_c(partial_paths) 

download.file(full_paths[1],
 "some/path/fresh_fruit.csv"
 )
```

you actually don't even need the `?v=42942` for it to download, I'd probably take it out in case it changes (maybe a version param?).

you can name the files using the part of the `partial_path` right before `.csv` becuase they're actually pretty informative (not sure if they're unique though).

I figure when you map over all the full paths you can name the files using the part of the `partial_path` right before `.csv` because they're probably unique? I guess you'd want to check that first though

maybe useful for the course you're teaching @fanny


here("../..", "fresh_fruit")


library(rvest)

links <- 
  "https://www.ers.usda.gov/data-products/food-availability-per-capita-data-system.aspx" %>% 
  read_html() %>% 
  html_node("#data_table a") %>% 
  html_text()

