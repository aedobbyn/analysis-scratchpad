
library(tidyverse)

dry <- mean(sum(3, 4))

wet <- sum(3, 4) %>% mean()

c(b(a(1), "x"))

a(1) %>% b() %>% c

expr <- quote(mean(log(3)))

expr_out <- 
  str_c(expr[2] %>% as.character(),
        " %>% ",
        expr[1] %>% as.character(),
        "()")


irrigate <- function(ex) {
  ex <- substitute(ex)
  
  out <- str_c(ex[2] %>% as.character(),
               " %>% ",
               ex[1] %>% as.character(),
               "()")
  
  out
}

irrigate(mean(log(3)))






library(stringr)

irrigate <- function(ex) {
  ex <- substitute(ex)
  
  n_funs <- length(ex)
  
  water <- function(x) {
    str_c(x %>% as.character(),
          " %>% ")
  }
  
  out <- ""
  
  while(n_funs > 1) {
    out <- out %>% 
      str_c(water(ex[n_funs]))
    
    n_funs <- n_funs - 1
  }
  
  out <- out %>% 
    str_c(as.character(ex[1]), "()")
  
  out
}

irrigate(rnorm(log(3)))

irrigate(sum(log(rnorm(4))))




