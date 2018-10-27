
library(tidyverse)

dat <- tribble(
  ~game_id, ~home_lineup, ~awaylineup,  ~home_Plusminus,  ~Away_Plusminus,  ~home_team,   ~away_team,
  12345,  "L1",          "L2",          -2,              2,               "BOS",       "ATL",
  12345,  "L3",          "L4",           3,             -3,               "BOS",       "ATL",
  # 12345,  "L3",          "L4",           3,             -3,               "BOS",       "ATL",
  45678,  "L2",          "L1",           3,             -3,               "ATL",       "BOS",
  45678,  "L2",          "L7",           1,             -1,               "ATL",       "BOS",
  45678,  "L8",          "L1",           3,             -3,               "ATL",       "BOS"
)

long <- 
  dat %>% 
  gather(where, team, home_team:away_team) %>% 
  mutate(
    home_lineup = case_when(where == "home_team" ~ home_lineup,
                            TRUE ~ NA_character_),
    away_lineup = case_when(where == "away_team" ~ awaylineup,
                            TRUE ~ NA_character_),
    home_plusminus = case_when(where == "home_team" ~ home_Plusminus,
                            TRUE ~ NA_real_),
    away_plusminus = case_when(where == "away_team" ~ Away_Plusminus,
                            TRUE ~ NA_real_)
  ) %>% 
  select(-home_Plusminus, -Away_Plusminus, -awaylineup) %>% 
  gather(plus_minus_type, plus_minus, home_plusminus:away_plusminus) %>%
  gather(lineup_type, lineup, home_lineup:away_lineup, -where, -team) %>% 
  mutate(
    where = where %>% str_remove("_team"),
    lineup_type = lineup_type %>% str_remove("_") %>% str_remove("lineup"),
    plus_minus_type = lineup_type %>% str_remove("_Plusminus")
  ) %>% 
  drop_na()

long %>% 
  group_by(
    team, lineup
  ) %>% 
  summarise(
    PlusMinus = sum(plus_minus),
    Pergame = sum(plus_minus) / n()
  )



Team Lineup PlusMinus Pergame
BOS  L1     -8        -2.7
BOS  L3      3         3.0
BOS  L7     -1        -1.0
ATL  L2      6         2.0
ATL  L4     -6        -6.0
ATL  L8      3         3.0
