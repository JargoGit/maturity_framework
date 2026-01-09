library(tidyverse)
library(lubridate)
library(janitor)

raw_file <- "data/raw/pokertracker/BCP_Cash1 Report.csv"

poker_raw <- read_csv(raw_file) %>%
  clean_names()

glimpse(poker_raw)

