
library(rtweet)
library(tidyverse)

search_tweets(q = "#MalortCourt",
              n = 500)

try_get_timeline <- possibly(get_timeline, otherwise = NULL)
  

get_mc_tweets <- function(reg = "#malortcourt|#MalortCourt", 
                          iters = 5, 
                          n_per_pull = 3200, 
                          verbose = TRUE) {
  
  m_id <- NULL
  out <- NULL
    
  for (i in seq(iters)) {
    
    if (verbose) message(glue::glue("Starting iteration {i}."))
    
    this <- 
      try_get_timeline("ChicagoNemesis",
                       n = n_per_pull, 
                   max_id = m_id) 
    
    # max_id "returns results with an ID less than (that is, older than) or equal to 'max_id'", so should always be 1 row
    if (nrow(this) <= 1) { 
      if (verbose) message(glue::glue("Done after iteration {i}."))
      return(out)
    }
    
    m_id <- 
      this %>% 
      filter(status_id == min(as.numeric(status_id))) %>% 
      pull(status_id)
    
    mcs <- 
      this %>% 
      filter(str_detect(text, reg))
    
    out <-
      out %>% 
      bind_rows(mcs)
  }
  
  out
}

raw <- get_mc_tweets()


# Actual months malort court took place
month_year_dict <- 
  tribble(
    ~c_year, ~c_month,
    2015, 10,
    2016, 12,
    2017, 10, 
    2018, 10, 
    2019, 01
  )


dat <-
  raw %>% 
  select(text, created_at, 
         favorite_count, retweet_count, 
         hashtags, media_url, status_id) %>% 
  mutate(
    year = lubridate::year(created_at),
    month = lubridate::month(created_at)
  ) %>% 
  left_join(month_year_dict, 
            by = c("year" = "c_year")) %>%
  rowwise() %>% 
  mutate(
    in_court =
      case_when(
        month == c_month ~ TRUE,
        TRUE ~ FALSE
      )
  ) %>% 
  select(-c_month)


