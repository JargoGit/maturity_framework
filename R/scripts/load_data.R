library(tidyverse)

ussr <- read_csv(
  "data/raw/USSR/ussr_mvd_1965_1991.csv",
  show_col_types = FALSE
) %>%
  filter(Year != "~time") %>%   # 🔥 remove fake header row
  mutate(
    Year = as.integer(Year),
    V    = as.numeric(V),
    S    = as.numeric(S),
    T    = as.numeric(T),
    E    = as.numeric(E)
  )

summary(ussr)
