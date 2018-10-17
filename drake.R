
library(drake)
library(DBI)
library(tidyverse)

# Funs
connect_to_db <- function() {
  dbConnect(RSQLite::SQLite(), "db")
}

seed_db <- function(conn) {
  dbWriteTable(conn, "mtcars", mtcars, overwrite = TRUE)
}

get_res <- function(conn) {
  dbGetQuery(conn, "SELECT * FROM mtcars") %>%
    as_tibble()
}

update_db_records <- function(tbl, conn) {
  new <- tbl %>%
    map_dfr(log)

  dbWriteTable(conn,
    "mtcars",
    new,
    append = FALSE,
    overwrite = TRUE
  )
}

test_is_original <- function() {
  testthat::expect_equal(
    mtcars %>%
      as_tibble(),
    get_res(con)
  )
}

test_is_log <- function() {
  testthat::expect_equal(
    mtcars %>%
      map_dfr(log),
    get_res(con)
  )
}


# Create db and write mtcars table
con <- connect_to_db()
seed_db(con)
test_is_original()

# Connection for updating is a target in the plan
plan_1 <- drake_plan(
  this_con = connect_to_db(),

  seeded = get_res(this_con),

  processed_data =
    update_db_records(seeded, this_con),

  strings_in_dots = "literals"
)

# Check that we updated mtcars
clean()
make(plan_1)
test_is_log()

# Overwrite table to original mtcars
seed_db(con)
test_is_original()

# Connection for updating is a global object
plan_2 <- drake_plan(
  seeded = get_res(con),
  
  processed_data =
    update_db_records(seeded, con),

  strings_in_dots = "literals"
)

# Check that we updated mtcars
clean()
make(plan_2)
test_is_log()
