library(tidyverse)
library(httr)
library(glue)
library(rnoaa)
library(here)
library(owmr)

gefs("Total_precipitation_surface_6_Hour_Accumulation_ens", lat = 46.28125, lon = -116.2188)

source(here("keys.R"))
# owmr_settings(api_key = openweathermap_key)

here_now <- 
  GET(glue("api.openweathermap.org/data/2.5/forecast?zip=11238&APPID={openweathermap_key}")) %>% 
  content()


bk_forecast <- get_forecast("Brooklyn", units = "metric")





