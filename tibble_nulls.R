
suppressPackageStartupMessages({
  library(tibble)
  library(dplyr)
})

x <-
  tibble(
    a = c("a", NA_character_, "d"),
    c = 1:3
    # a = rep(NA_character_, 3)
  )

y <- 
  tibble(
    a = letters[1:3],
    b = rep(list(tibble()), 3)
  )

(no_nulls <- 
    left_join(y, x))

(nulls <-
  left_join(x, y, by = "a"))


devtools::package_info(pkgs = c("tibble", "dplyr"))




