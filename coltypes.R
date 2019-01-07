library(tidyverse)

types <- tibble::tribble(
  ~name, ~dat_type,
  "percent_over_avg_2018", "numeric",
  "usi_avg_2018", "numeric",
  "n_2018", "integer"
)

df <- tibble::tribble(
  ~percent_over_avg_2018, ~usi_avg_2018, ~n_2018,
  "0.56",        "45.9",   "107",
  "0.75",        "45.9",    "79",
  "0.11",        "45.9",     "9",
  "0",           "45.9",     "5",
  "0.75",        "45.9",     "8",
  "0.31",        "45.9",    "60"
)

(types <- 
  types %>% 
  mutate(
    fn = str_c("as.", dat_type),
    shortcut = dat_type %>% str_sub(1, 1),
    dat_type = 
      case_when(
        dat_type == "numeric" ~ "number",
        TRUE ~ dat_type
      ),
    col_expr = glue::glue("{name} = col_{dat_type}()")
  ))

foo <- types$col_expr %>% str_c(collapse = ", ")
foo <- types$shortcut %>% as.list()

bar <- cols(eval(substitute((foo))))
# bar <- glue::glue("cols({foo})")

tc <- enquo(bar)

df %>% 
  type_convert(eval(substitute(bar)))

df %>% 
  type_convert(cols(percent_over_avg_2018 = col_number(), usi_avg_2018 = col_number(), n_2018 = col_integer()))




df %>% 
  transmute_at(.vars = c("percent_over_avg_2018", "usi_avg_2018", "n_2018"),
               .funs = types$fn)



update_type <- function(tbl, col, fn) {
  tbl[[col]] <- fn(tbl[[col]])
  # q_col = enquo(col)
  # 
  # tbl <- 
  #   tbl %>% 
  #   as_tibble() %>% 
  #   mutate(
  #     col = !!q_col %>% fn
  #   )
  # 
  # tbl
  
  tbl
}



update_type <- function(tbl, col, fn) {
  tbl[[col]] <- fn(tbl[[col]])
  
  tbl
}

update_type <- function(vec, fn) {
  fn(vec)
}


map2(.x = c(mtcars[["mpg"]], mtcars[["cyl"]], mtcars[["hp"]]), .y = c("as.character", "as.integer", "as.character"), .f = update_type)

map2_dfc(.x = c("mpg", "cyl", "hp"), c("as.character", "as.integer", "as.character"), .f = update_type)



df %>% 
  type_convert(col_types = types$dat_type)




