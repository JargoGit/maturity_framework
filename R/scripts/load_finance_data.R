library(tidyverse)

real_wage_growth <- read_csv(
  "data/raw/finance/macro/real_wage_growth.csv",
  show_col_types = FALSE
)

summary(real_wage_growth)
