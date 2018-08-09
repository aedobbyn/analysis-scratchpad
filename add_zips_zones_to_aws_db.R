library(here)
library(RMySQL)
library(tidyverse)

source(here("keys.R"))

con <- dbConnect(MySQL(),
                 username = user,
                 password = pw,
                 dbname = db_name,
                 host = host,
                 port = 3306)

# Turn  bools to 1s and 0s (could make this prettier)
bool_to_tinyint <- function(x) {
  if (is.na(x)) {
    return(x)
  } else if (x == TRUE) {
    x <- 1
  } else if (x == FALSE) {
    x <- 0
  } else {
    x <- NA
  }
  x
}

# Read in all the data
all_zip_zones <- read_csv("/Users/amanda/Desktop/Projects/postal/data-raw/2018-06-19_zip_zones.csv")

all_zip_zones_names <- names(all_zip_zones)

# Tinyintifiy
all_zip_zones_tinyinted <-
  all_zip_zones %>%
  mutate(
    specific_to_priority_mail = purrr::map_dbl(specific_to_priority_mail, bool_to_tinyint),
    same_ndc = purrr::map_dbl(same_ndc, bool_to_tinyint),
    has_five_digit_exceptions = purrr::map_dbl(has_five_digit_exceptions, bool_to_tinyint)
  ) %>%
  select(all_zip_zones_names)

# Add timestamps
all_zip_zones_now <-
  all_zip_zones_tinyinted %>%
  mutate(
    created_at = lubridate::now("UTC"),
    updated_at = lubridate::now("UTC"),
    deleted_at = NA
  )


# Create the table
create_tbl_query <-
  "
CREATE TABLE zips_zones (
  id INT NOT NULL AUTO_INCREMENT,
  origin_zip INT NOT NULL,
  dest_zip INT NULL,
  zone INT NULL,
  specific_to_priority_mail TINYINT NULL,
  same_ndc TINYINT NULL,
  has_five_digit_exceptions TINYINT NULL,
  created_at TIMESTAMP NULL,
  updated_at TIMESTAMP NULL,
  deleted_at TIMESTAMP NULL,
  PRIMARY KEY (id),
  INDEX (origin_zip)
);
"
dbSendQuery(con, create_tbl_query)

# Write to the table
dbWriteTable(con,
             name = "zips_zones",
             value = all_zip_zones_now,
             append = TRUE,
             overwrite = FALSE,
             row.names = FALSE)
