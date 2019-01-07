
fib <- function(x) {
  out <- c(0, 1)
  
  vec <- seq(x)
  
  for (i in seq_along(vec)) {
    if (i < x) {
      this <- out[length(out) - 1] + out[length(out)]
      
      out <- c(out, this)
    }
  }
  
  out
}

fib(10)
