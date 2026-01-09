ussr <- ussr %>%
  arrange(Year) %>%
  mutate(
    SI   = (V * S) / T + E,
    dSI  = SI - lag(SI),
    d2SI = dSI - lag(dSI)
  )
