
library(rtweet)
library(tidyverse)

search_tweets(q = "#MalortCourt",
              n = 500)

try_get_timeline <- possibly(get_timeline, otherwise = NULL)
  

get_mc_tweets <- function(iters = 5) {
  
  m_id <- NULL
  out <- NULL
    
  for (i in seq_along(iters)) {
    
    this <- 
      try_get_timeline("ChicagoNemesis",
                   n = 3200)
    
    if (is.null(this)) {
      return(out)
    }
    
    m_id <- 
      this %>% 
      filter(status_id == min(as.numeric(status_id)))
    
    mcs <- 
      this %>% 
      filter(str_detect(text, "#malortcourt|#MalortCourt"))
    
    out <-
      out %>% 
      bind_rows(mcs)
  }
  
  out
}










