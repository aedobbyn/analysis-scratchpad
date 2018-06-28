library(tidyverse)
library(beepr)

beep_on_error <- function(expr, sound = 1) {
  q_expr <- substitute(expr)
  
  msg <- paste0("An error occurred in ", deparse(q_expr))
  e <- simpleError(msg)
  
  tryCatch(expr, error = function(e) {
    message(paste0(msg, ": ", e$message))
    beep(sound)
  })
}

beep_on_error(log("foo"))
beep_on_error(log(1))
