library(fredr)
library(dplyr)
library(readr)

# ---- Credit Spread Series ----
# BAA - AAA Corporate Bond Yield Spread
# This is a standard stress/load proxy

credit_spreads <- fredr(
  series_id = "BAA10Y",
  observation_start = as.Date("1960-01-01")
) %>%
  select(date, value) %>%
  rename(
    spread_baa = value
  )

# Save to raw data (this was previously a placeholder)
write_csv(
  credit_spreads,
  "data/raw/finance/markets/credit_spreads.csv"
)

credit_spreads
