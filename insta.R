
library(stringr)


src <- readLines(here::here("insta_src.txt")) %>% 
  str_c(collapse = "")

reg <- '(https.+\\.jpg.+cat=[0-9]+,)'

src_clean <- src %>% 
  str_remove_all('"') %>% 
  str_replace_all("\\\\u0026", "&")

imgs <- src_clean %>% 
  str_extract_all(reg)


src %>% 
  str_split("src")
  
