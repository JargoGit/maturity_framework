library(tidyverse)

# Load processed datasets
gdp <- read_csv("data/processed/finance/gdp_real_processed.csv")
prod <- read_csv("data/processed/finance/productivity_processed.csv")

# Build combined capacity vector
V <- gdp %>%
  select(date, real_gdp_growth_z) %>%
  left_join(
    prod %>% select(date, industrial_production_z),
    by = "date"
  )

# Save combined dataset
write_csv(
  V,
  "data/processed/finance/V_real_capacity.csv"
)
