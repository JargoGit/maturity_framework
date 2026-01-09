library(tidyverse)

productivity <- read_csv("data/raw/finance/macro/productivity.csv") %>%
  mutate(
    industrial_production_z = as.numeric(scale(industrial_production_growth))
  )

write_csv(
  productivity,
  "data/processed/finance/productivity_processed.csv"
)
