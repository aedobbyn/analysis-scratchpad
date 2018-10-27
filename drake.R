
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

db <- function(code) {
  con <- connect_to_db()
  on.exit(dbDisconnect(con))
  eval(substitute(code))
}

con <- connect_to_db()
seed_db(con)
dbDisconnect(con)

plan <- drake_plan(
  seeded = db(get_res(con)),
  is_processed = db(update_db_records(seeded, con)),
  processed_data = db(get_res(con))
)

clean()
make(plan)

loadd(is_processed)
is_processed

loadd(processed_data)
processed_data

testthat::expect_equal(mtcars %>% as_tibble(), processed_data)























library(drake)
library(DBI)
library(tidyverse)
pkgconfig::set_config("drake::strings_in_dots" = "literals")

connect_to_db <- function() {
  dbConnect(RSQLite::SQLite(), "db")
}

seed_db <- function(con) {
  dbWriteTable(con, "mtcars", mtcars, overwrite = TRUE)
}

get_res <- function(con) {
  dbGetQuery(con, "SELECT * FROM mtcars") %>%
    as_tibble()
}

update_db_records <- function(con) {
  new <- get_res(con) %>%
    map_dfr(log)
  dbWriteTable(
    con,
    "mtcars",
    new,
    append = FALSE,
    overwrite = TRUE
  )
}

is_log <- function(con) {
  identical(
    mtcars %>%
      map_dfr(log),
    get_res(con)
  )
}

mt_3 <- function(con) {
  dbGetQuery(con, "SELECT * FROM mtcars
                   LIMIT 3") %>%
    as_tibble()
}

db <- function(code, query) {
  con <- connect_to_db()
  on.exit(dbDisconnect(con))
  eval(substitute(code))
  fastdigest::fastdigest(query(con))
}

plan <- drake_plan(
  con = "phony",
  seeding_step = db(seed_db(con), 
                    query = mt_3),
  processing_step = db(update_db_records(con), 
                       query = mt_3)
)

clean()
make(plan)

con <- connect_to_db()
is_log(con)
dbDisconnect(con)






