# R-ready functions (drop into R/utils_maturity.R)

clean_currency <- function(x) {
  # Handles values like "-$27.08", "$27.08", " - $27.08 "
  x <- trimws(x)
  x <- gsub("\\$", "", x)     # remove dollar sign
  x <- gsub(",", "", x)         # remove commas if any
  as.numeric(x)                 # keeps leading '-' if present
}

compute_poker_index <- function(df,
                                won_col = "my_c_won",
                                hands_col = "hands") {
  stopifnot(all(c(won_col, hands_col) %in% names(df)))
  won_num <- clean_currency(df[[won_col]])
  hands   <- as.numeric(df[[hands_col]])

  df$c_won_numeric <- won_num
  df$c_per_hand    <- won_num / hands
  df
}

rolling_stats <- function(x, k = 200) {
  # Simple base-R rolling mean/sd to avoid deps
  n <- length(x)
  mu <- rep(NA_real_, n)
  sd <- rep(NA_real_, n)
  for (i in seq_len(n)) {
    lo <- max(1, i - k + 1)
    window <- x[lo:i]
    mu[i] <- mean(window, na.rm = TRUE)
    sd[i] <- stats::sd(window, na.rm = TRUE)
  }
  list(mean = mu, sd = sd)
}

detect_regime_shift <- function(mu_roll, threshold = 0) {
  # Returns indices where rolling drift crosses below threshold
  which(!is.na(mu_roll) & mu_roll < threshold)
}

collapse_hazard <- function(C_over_K, sigma, S, I,
                            a0 = 0, a1 = 2, a2 = 2, a3 = 2, a4 = 2) {
  z <- a0 + a1*C_over_K + a2*sigma - a3*S - a4*I
  1 / (1 + exp(-z))
}
