
library(tidyverse)
library(fuzzyjoin)   # https://github.com/dgrtwo/fuzzyjoin/blob/master/R/fuzzy_join.R
# Another option: https://stackoverflow.com/questions/6683380/techniques-for-finding-near-duplicate-records
## RecordLinkage and rrefine

nd_dat <- tibble(
  name = c("John Smith", "Sally Ride", "Ruth Bader"),
  company = c("Evil Corp", "NASA", "NYC Appellate Court"),
  job_title = c("Analyst", "Astronaut", "Judge"),
  phone_number = c(sample(0:9, 10) %>% str_c(collapse = ""),
                   sample(0:9, 10) %>% str_c(collapse = ""),
                   sample(0:9, 10) %>% str_c(collapse = "")),
  dist_col = rep("foo", 4)
)

ld_dat <- tibble(
  name = c("John J Smith", "Sally Ride", "Ruth Bader-Ginsburg"),
  company = c("Uber Technologies", "National Aeronautics and Space Administration", "US Supreme Court"),
  job_title = c("Senior Analyst", "Astronaut", "Justice"),
  phone_number = c(sample(0:9, 10) %>% str_c(collapse = ""),
                   sample(0:9, 10) %>% str_c(collapse = ""),
                   sample(0:9, 10) %>% str_c(collapse = "")),
  dist_col = rep("bar", 4)
)



nd_dat %>% stringdist_full_join(ld_dat, 
                           by = c("name" = "name",
                                  "company" = "company",
                                  "job_title" = "job_title",
                                  "phone_number" = "phone_number"),
                           method = "cosine",
                           distance_col = "dist_col",
                           max_dist = 2) %>% 
  group_by(name.x) %>% 
  arrange(name.dist_col, company.dist_col) %>% 
  slice(1) %>% 
  View()

