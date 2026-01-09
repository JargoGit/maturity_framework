library(dplyr)
library(tidyr)

compute_spm <- function(hands_all, baseline_session = "intact") {
  
  stopifnot(
    "session" %in% names(hands_all),
    "line_count" %in% names(hands_all),
    "collected_amount" %in% names(hands_all)
  )
  
  hands_all <- hands_all %>%
    mutate(
      load_bucket = cut(
        line_count,
        breaks = quantile(line_count, probs = seq(0, 1, 0.25), na.rm = TRUE),
        include.lowest = TRUE
      ),
      win = collected_amount > 0,
      log_win = log1p(collected_amount)
    )
  
  # ---- 1) Load–outcome coupling slope ----
  betas <- hands_all %>%
    group_by(session) %>%
    summarise(
      beta_load = {
        fit <- lm(log_win ~ line_count, data = cur_data())
        unname(coef(fit)[["line_count"]])
      },
      .groups = "drop"
    )
  
  # ---- 2) Concentration ratio ----
  bucket_stats <- hands_all %>%
    group_by(session, load_bucket) %>%
    summarise(
      n = n(),
      win_rate = mean(win),
      mean_win = mean(collected_amount[win], na.rm = TRUE),
      .groups = "drop"
    )
  
  bucket_levels <- levels(hands_all$load_bucket)
  mid_bucket <- bucket_levels[3]
  top_bucket <- bucket_levels[4]
  
  conc <- bucket_stats %>%
    filter(load_bucket %in% c(mid_bucket, top_bucket)) %>%
    select(session, load_bucket, mean_win) %>%
    pivot_wider(names_from = load_bucket, values_from = mean_win) %>%
    mutate(
      concentration_ratio = .data[[top_bucket]] / .data[[mid_bucket]]
    ) %>%
    select(session, concentration_ratio)
  
  # ---- 3) Slack loss ----
  mins <- hands_all %>%
    group_by(session) %>%
    summarise(min_load = min(line_count), .groups = "drop")
  
  baseline_min <- mins %>%
    filter(session == baseline_session) %>%
    pull(min_load)
  
  slack <- mins %>%
    mutate(slack_loss = min_load - baseline_min) %>%
    select(session, slack_loss)
  
  # ---- Combine into Signal Preservation Metric ----
  metrics <- betas %>%
    left_join(conc, by = "session") %>%
    left_join(slack, by = "session") %>%
    mutate(
      beta_rank  = rank(beta_load),
      conc_rank  = rank(concentration_ratio),
      slack_rank = rank(slack_loss),
      spm = 100 -
        25 * (beta_rank - 1) -
        25 * (conc_rank - 1) -
        25 * (slack_rank - 1)
    ) %>%
    select(session, beta_load, concentration_ratio, slack_loss, spm) %>%
    arrange(desc(spm))
  
  list(
    hands_all    = hands_all,
    bucket_stats = bucket_stats,
    metrics      = metrics
  )
}
