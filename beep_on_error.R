library(tidyverse)
library(beepr)

beep_on_error <- function(inp, error_beep = 9) {
  # q_inp <- substitute(inp)
  # 
  # msg <- paste0("An error occurred in ", deparse(q_inp))
  msg <- "bar"
  e <- simpleError(msg)
  
  tryCatch(inp, error = function(e) {
    message(paste0(msg, ": ", e$message))
    beep(error_beep)
  })
}

beep_on_error() %>% log("foo")

beep_on_error(log("foo"))

beep_on_error(log(3))


beep_on_error <- function(f, error_beep = 9, arg) {
  g <- purrr::safely(f, otherwise = "Beep pls")
  
  outcome <- g(arg)
  
  if (outcome$result == "Beep pls") {
    beep(1)
  } else {
    beep(2)
  }
  return(NULL)
}

beep_on_error(log, arg = "foo")
beep_on_error(log, arg = 1)

log("a") %>% beep_on_error()

beep_on_error(log(1))

