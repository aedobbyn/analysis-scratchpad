
fun_tib <- tibble(
  x = list(sample(1:100, 4)),
  fun = list(mean)
)

non_fun_tib <- tibble(
  x = list(sample(1:100, 4)),
  fun = NA
)

foo <- function(tbl) {
  # q_fun <- enquo(tbl$fun[[1]])
  f <- tbl$fun[[1]]
  
  if (!is.na(f)) {
    return(f(tbl$x %>% as_vector()))
  } else {
    return(tbl$x)
  }
}

foo(fun_tib)
foo(non_fun_tib)
