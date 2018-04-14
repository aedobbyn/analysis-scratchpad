library(tidyverse)
library(beepr)

beep_on_error <- function(f, ...) {
  g <- purrr::possibly(f, otherwise = "Beep pls")
  
  # tryCatch(f(...), error = beep(1)
  # )
  
  outcome <- g()

  if (outcome == "Beep pls") {
    beep(1)
  } else {
    beep(2)
  }
  return(NULL)
}

beep_on_error(log, "a")

beep_on_error(log(1))

