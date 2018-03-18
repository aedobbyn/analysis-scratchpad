
library(tidyverse)
library(stringr)
library(dbplyr)

# --- Set Up ---
dat <- tribble(
  ~user_id, ~item_id,
  1, 1,
  1, 4,
  1, 19,
  1, 10,
  1, 13,
  1, 1,
  1, 11,
  1, 18,
  1, 212,
  1, 654,
  2, 1,
  2, 28,
  2, 568,
  2, 112,
  2, 354,
  3, 4,
  3, 4,
  3, 19,
  3, 212,
  3, 654,
  3, 4,
  3, 4,
  3, 253,
  3, 187,
  3, 212
)

# --- Prep --- 
pre <- dat %>% 
  group_by(user_id) %>% 
  arrange(user_id, item_id) %>% 
  add_count(item_id) %>% 
  rename(
    n_items = n
  ) %>% 
  distinct(user_id, item_id, .keep_all = TRUE) %>% 
  top_n(5, n_items) %>% 
  slice(1:5) %>% 
  arrange(user_id, desc(n_items)) 

# --- Solve ---
# Hacky
solution_one <- pre %>% 
  mutate(collapsed = str_c(item_id, collapse = ", ")) %>% 
  slice(1) %>% 
  select(user_id, collapsed)

# Less hacky
solution_two <- pre %>%
  select(-n_items) %>% 
  nest() %>% 
  mutate(
    collapsed = data %>% 
      map(flatten_dbl) %>%
      map_chr(str_c, collapse = ", "))

# Ideal
solution_three <- pre %>%
  nest() %>% 
  mutate(
    collapsed = data %>% 
      map("item_id") %>% 
      map_chr(str_c, collapse = ", "))

solution_three



# ----- Translate to SQL ------
translate_sql(dat %>% 
  group_by(user_id) %>% 
  arrange(user_id, item_id) %>% 
  add_count(item_id) %>% 
  distinct(user_id, item_id, .keep_all = TRUE) %>% 
  top_n(5, n) %>% 
  slice(1:5) %>% 
  arrange(user_id, desc(n)) %>%      # start hacky solution
  mutate(collapsed = str_c(item_id, collapse = ", ")) %>% 
  slice(1) %>% 
  select(user_id, collapsed),
  variant = mysql_var)


