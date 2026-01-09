# ecology_delta_ssta_rolling_min.R
# Canonical Delta test for ecological systems (coral reefs)
# Invariant: permanent rise in rolling minimum stress (loss of slack)

library(dplyr)
library(zoo)

run_ecology_delta <- function(df, window = 365) {
  
  df %>%
    arrange(date) %>%
    mutate(
      rolling_min = rollapply(
        SSTA,
        window,
        min,
        fill = NA,
        align = "right"
      ),
      rolling_median = rollapply(
        SSTA,
        window,
        median,
        fill = NA,
        align = "right"
      )
    ) %>%
    summarise(
      first_valid_min = first(rolling_min[!is.na(rolling_min)]),
      max_rolling_min = max(rolling_min, na.rm = TRUE),
      first_valid_median = first(rolling_median[!is.na(rolling_median)])
    )
}
