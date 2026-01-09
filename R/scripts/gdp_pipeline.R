library(tidyverse)

gdp <- read_csv(
  "data/raw/finance/macro/gdp_real.csv",
  col_types = cols(
    date = col_date(),
    real_gdp_growth = col_double()
  )
)

gdp <- gdp %>%
  mutate(
    real_gdp_growth_z = as.numeric(scale(real_gdp_growth))
  )

write_csv(
  gdp,
  "data/processed/finance/gdp_real_processed.csv"
)
