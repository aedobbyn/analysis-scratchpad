
library(here)
library(dobtools)

replace_x <- function(x, replacement = NA_character_) {
  if (length(x) == 0 || length(x[[1]]) == 0) {
    replacement
  } else {
    x
  }
}


res_w_nulls %>% purrr::modify_depth(replace_x, 2)


monkeylearn_rates <- data.frame(
  plan = c("free", "team", "business"),
  req_min = c(20, 60, 120)
)

monkeylearn_plan <- Sys.getenv("MONKEYLEARN_PLAN")
if (identical(monkeylearn_plan, "")) {
  warning("Please indicate your Monkeylearn plan in the MONKEYLEARN_PLAN environment variable\n
          Now using 'free' by default") # nolint
  monkeylearn_plan <- "free"
}

monkeylearn_rate <- monkeylearn_rates$req_min[monkeylearn_rates$plan == monkeylearn_plan]

monkeylearn_url <- function() {
  "https://api.monkeylearn.com/v2/"
}

monkeylearn_url_extractor <- function(extractor_id) {
  paste0(
    monkeylearn_url(),
    "extractors/",
    extractor_id,
    "/extract/"
  )
}


monkey_post <- ratelimitr::limit_rate(
  httr::POST,
  ratelimitr::rate(n = 5, period = 1),
  ratelimitr::rate(n = monkeylearn_rate, period = 60)
)

monkeylearn_get_extractor <- function(request, key, extractor_id) {
  monkey_post(monkeylearn_url_extractor(extractor_id),
              httr::add_headers(
                "Accept" = "application/json",
                "Authorization" = paste("Token ", key),
                "Content-Type" =
                  "application/json"
              ),
              body = request
  )
}


monkeylearn_parse_each <- function(output, verbose = TRUE) {
  text <- httr::content(output,
                        as = "text",
                        encoding = "UTF-8"
  )
  temp <- jsonlite::fromJSON(text)
  results <- NULL
  
  if (methods::is(temp$result, "list")) {
    if (length(temp$result[[1]]) == 0) {
      results$result[[1]] <- NA_character_
      
      if (verbose) {
        message("No results for this call; returning NA.")
      }
    } else {
      results <- temp
    }
  } else { # Not sure what other type of output we'd get
    results <- temp
    # results$text_md5 <- map(temp$result, digest::digest)
  }
  
  out <- results
  return(out)
}

text <- "Hi, my email is john@example.com and my credit card is 4242-4242-4242-4242 so you can charge me with $10. My phone number is 15555 9876. We can get in touch on April 16, at 10:00am"
text2 <- "Hi, my email is mary@example.com and my credit card is 4242-4232-4242-4242. My phone number is 16655 9876. We can get in touch on April 16, at 10:00am"
inp <- c(text, text2)


out <- inp %>% monkeylearn_get_extractor(key = "b11c29e15516b8470ed7faa5c596756e8b8fbb61", extractor_id = "ex_dqRio5sG") %>% 
  monkeylearn_parse_each()
out$result





library(here)
library(magrittr)
library(stringr)

res_w_nulls <- readRDS(here("../../res_w_nulls.rds"))
res_w_nulls

replace_nulls <- function(x)  {
  suppressWarnings({
    levels(x) <- x %>% stringr::str_replace("list()|
                                            character\\(0\\)", NA_character_)
  })
}

res_w_nulls %>% 
  apply(2, replace_nulls)







employees <- list(
  list(id = 1,
       dept = "IT",
       age = 29,
       sportsteam = "softball"),
  list(id = 2,
       dept = "IT",
       age = 30,
       sportsteam = NULL),
  list(id = 3,
       dept = "IT",
       age = 29,
       sportsteam = "hockey"),
  list(id = 4,
       dept = NULL,
       age = 29,
       sportsteam = "softball"))

library(data.table)
employee.df <- rbindlist(employees)

nullToNA <- function(x) {
  x[sapply(x, is.null)] <- NA
  return(x)
}

employees <- lapply(employees, nullToNA)
employee.df <- rbindlist(employees)







m <- res_w_nulls %>% purrr::modify_depth(2, replace_x) %>% tibble::as_tibble() %>% tidyr::unnest()




library(magrittr)

foo <- tibble::tibble(
  a = c(list(list()), list(list())),
  b = c(list(1), list(2)),
  c = c(list("d"), list(character(0)))
) %>% as.data.frame()

foo

replace_x <- function(x, replacement = NA_character_) {
  if (length(x) == 0 || length(x[[1]]) == 0) {
    replacement
  } else {
    x
  }
}

foo %>% purrr::modify_depth(2, replace_x)





dat <- do.call(rbind, lapply(employees, rbind))
nullToNA(dat)



# A tidyverse solution that I find easier to read is to write a function that works on a single element and map it over all of your NULLs
# I'll use @rich-scriven's rbind and lapply approach to create a matrix, and then turn that into a dataframe
# Then we can use `purrr::modify_depth()` at a depth of 2 to apply `replace_x()`
library(magrittr)

employees <- list(
  list(id = 1,
       dept = "IT",
       age = 29,
       sportsteam = "softball"),
  list(id = 2,
       dept = "IT",
       age = 30,
       sportsteam = NULL),
  list(id = 3,
       dept = "IT",
       age = 29,
       sportsteam = "hockey"),
  list(id = 4,
       dept = NULL,
       age = 29,
       sportsteam = "softball"))

replace_x <- function(x, replacement = NA_character_) {
  if (length(x) == 0 || length(x[[1]]) == 0) {
    replacement
  } 
}

dat <- do.call(rbind, lapply(employees, rbind)) %>% 
  as.data.frame()

dat

out <- dat %>% 
  purrr::modify_depth(2, replace_x)

out



library(magrittr)

foo <- tibble::tibble(
  a = c(list(list()), list(list())),
  b = c(list(1), list(2)),
  c = c(list("d"), list(character(0)))
) %>% as.data.frame()

replace_nulls <- function(x)  {
  suppressWarnings({
    levels(x) <- x %>% stringr::str_replace("list()|
                                            character\\(0\\)", NA_character_)
  })
}

foo %>% 
  apply(2, replace_nulls) %>% as.data.frame()


library(magrittr)
foo <- tibble::tibble(
  a = c(list(list()), list(list())),
  b = c(list(1), list(2)),
  c = c(list("d"), list(character(0)))
) %>% as.data.frame()

f <- function(x, .default = NA) ifelse(lengths(x), x, .default)
bar <- purrr::map_df(foo, f)

bar

assertthat::are_equal(bar$a[1], bar$c[3])

purrr::modify(foo, f)

library(magrittr)
foo <- tibble::tibble(
  a = c(list(list()), list(list())),
  b = c(list(1), list(2)),
  c = c(list("d"), list(character(0)))
) %>% tibble::as_tibble()
f <- function(x, .default = NA) ifelse(lengths(x), x, .default)
g <- function(x, .default = NA) ifelse(length(x), x, .default)
purrr::modify(foo, f)
#> # A tibble: 2 x 3
#>   a     b         c
#>   <lgl> <list>    <list>
#> 1 NA    <dbl [1]> <chr [1]>
#> 2 NA    <dbl [1]> <lgl [1]>
purrr::map_dfc(foo, f)
#> # A tibble: 2 x 3
#>   a     b         c
#>   <lgl> <list>    <list>
#> 1 NA    <dbl [1]> <chr [1]>
#> 2 NA    <dbl [1]> <lgl [1]>
identical(purrr::modify(foo, f), purrr::map_dfc(foo, f))


purrr::map_dfr(foo, f)
purrr::modify(foo, g)


f <- function(x, .default = NA) modify(x, ~ if (length(.x) == 0) .default else .x)
purrr::modify(foo %>% tibble::as.tibble(), f)



compact <- function(x) {
  y <- Filter(Negate(is.null, x))
  y
}

compact <- function(x) Filter(Negate(is.null), x)

foo %>% modify_depth(2, compact)










