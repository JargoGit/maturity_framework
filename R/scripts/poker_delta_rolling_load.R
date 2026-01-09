library(dplyr)
library(zoo)

add_rolling_load <- function(hands_all, window = 20) {
  stopifnot(all(c("session", "hand_id", "line_count") %in% names(hands_all)))
  
  hands_all %>%
    group_by(session) %>%
    arrange(hand_id, .by_group = TRUE) %>%
    mutate(
      rolling_min    = zoo::rollapply(line_count, window, min,    fill = NA, align = "right"),
      rolling_median = zoo::rollapply(line_count, window, median, fill = NA, align = "right")
    ) %>%
    ungroup()
}

delta_summary <- function(hands_all) {
  stopifnot(all(c("session", "rolling_min", "rolling_median") %in% names(hands_all)))
  
  hands_all %>%
    group_by(session) %>%
    summarise(
      first_valid_min    = rolling_min[which(!is.na(rolling_min))[1]],
      max_rolling_min    = max(rolling_min, na.rm = TRUE),
      first_valid_median = rolling_median[which(!is.na(rolling_median))[1]],
      .groups = "drop"
    )
}

compute_delta <- function(summary_tbl, baseline = "intact", target = "cliff") {
  b <- summary_tbl %>% filter(session == baseline) %>% pull(first_valid_min)
  t <- summary_tbl %>% filter(session == target)  %>% pull(first_valid_min)
  
  tibble::tibble(
    baseline = baseline,
    target   = target,
    delta_first_valid_min = t - b
  )
}