
a <- function(x = 1,
              y = 2) {
  x + y
}

a()

b <- function(...) {
  args <- list(...)
  print(args)
  # bargs <- unlist(args)
  # print(bargs)
  # x <- args$x
  # y <- args$y
  
  do.call(a, args)
}

b(x = 3, y = 8)



c <- function(...) {
  args <- match.call(...)
  print(args)
  print(get(...))
  # bargs <- unlist(args)
  # print(bargs)
  # x <- args$x
  # y <- args$y
  
  do.call(a, args)
}

c(x = 3, y = 8)



d <- function(...) {
  dots <- list(...) %>% 
    unlist() %>% 
    stringr::str_c(collapse = "")
  
  print(dots)
}

d(x = 4, z = 5)
