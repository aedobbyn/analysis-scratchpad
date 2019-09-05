
library(janeaustenr)
library(tidytext)
library(tidyverse)

man_park <- tibble(text = mansfieldpark[13:30],
                   chunk = seq(1, 6) %>% rep(3) %>% sort())


man_park %>% 
  # group_by(chunk) %>% 
  rowwise() %>% 
  unnest_tokens(word, text) %>% 
  View()


man_park %>% 
  group_by(chunk) %>% 
  mutate(
    bigrams = unnest_tokens(., word, text, collapse = FALSE, drop = FALSE) %>% list()
  ) %>% 
  View()



tokenize_man_park <- function(tbl, grouper, input_name) {
  
  q_grouper <- enquo(grouper)
  q_input_name <- enquo(input_name)
  
  out <- tbl %>% 
    group_by(!!q_grouper) %>%
    unnest_tokens(word, !!q_input_name, token = "ngrams", n = 2, collapse = FALSE, drop = FALSE)
  
  out
}


man_park %>% tokenize_man_park(chunk, text) %>% 
  View()

  


