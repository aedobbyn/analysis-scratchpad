
fib <- function(x) {
  out <- 0
  
  val <- 1
  
  vec <- seq(x)
  
  for (i in seq_along(vec)) {
    if (i < x) {
      this <- vec[i] + out[length(out)]
      
      out <- c(out, this)
    }
  }
  
  out
}

fib(5)
