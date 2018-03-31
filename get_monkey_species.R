library(tidyverse)
library(stringr)
library(feather)
library(here)
library(rvest)

url <- "http://www.monkeyworlds.com/types-of-monkeys/"

page <- read_html(url)

# Read species names
species_raw <- page %>%
  html_nodes(".entry-title") %>%
  html_text()

# Take out clear non-species
not_species <- which(species_raw %in% c("Monkey Species", "Types of Monkeys"))
species <- species_raw[-not_species]

# Create phrase for each species
generic_phrase <- " says hang tight!"

monkey_phrases <- map_chr(species, stringr::str_c, generic_phrase) %>%
  stringr::str_c("The ", .)



# Pull in the descriptions
descriptions_raw <- page %>%
  html_nodes("p") %>%
  html_text()

# Extract just the first mention of a species from the descriptions
# (this works out even for Mandarill, which is mentioned in context of Baboon)
species_reg <- stringr::str_c(species, collapse = "|")

description_matches <- tibble(description = descriptions_raw) %>%
  mutate(
    match = map_chr(descriptions_raw, str_extract, species_reg) %>%
      as_vector()
  ) %>%
  drop_na()


# Make sure we have the same descriptions as species names
assertthat::are_equal(nrow(description_matches), length(species))

# Combine species and description
monkey_df <- tibble(
  species = species,
  phrase = monkey_phrases
) %>%
  left_join(description_matches, by = c("species" = "match"))



# write_feather(monkey_df, here("data", "monkey_df.feather"))
# write_csv(monkey_df, here("data", "monkey_df.csv"))