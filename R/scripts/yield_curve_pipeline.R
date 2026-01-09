library(tidyverse)

yield_curve <- read_csv("data/raw/finance/markets/yield_curve.csv") %>%
  mutate(
    curve_slope = yield_10y - yield_2y,
    curve_slope_z = as.numeric(scale(curve_slope))
  )

write_csv(
  yield_curve,
  "data/processed/finance/yield_curve_processed.csv"
)
