library(tidyverse)

summary_index <- poker_raw %>%
  mutate(
    my_c_won_clean = stringr::str_replace(my_c_won, "\\$|,", ""),
    c_won_numeric  = as.numeric(my_c_won_clean),
    c_per_hand     = c_won_numeric / hands
  )

write_csv(
  summary_index,
  "data/processed/poker_summary_index.csv"
)

summary_index
