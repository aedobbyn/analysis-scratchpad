
library(rtweet)
library(tidyverse)

painstaking <- 
  get_timeline("dobbleobble") %>% 
  filter(status_id == "1094317715265908737")

painstaking$favourite_count
