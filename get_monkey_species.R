library(tidyverse)
library(dobtools)
library(rvest)

url <- "http://www.monkeyworlds.com/types-of-monkeys/"

page <- read_html(url) 
species <- page %>% 
  html_nodes(".entry-title") %>% 
  html_text()

species <- species[!species %in% c("Monkey Species", "Types of Monkeys")]

phrase <- " says hang tight!"

phrases <- map_chr(species, stringr::str_c, phrase) %>% 
  stringr::str_c("The ", .)




