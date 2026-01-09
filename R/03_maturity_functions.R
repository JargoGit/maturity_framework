# ---- Core Signal ----
compute_signal <- function(structure, intuition, harmony, conflict) {
  (structure + intuition) * harmony - conflict
}

# ---- Maturity ----
compute_maturity <- function(signal, fragility, restraint, extraction, epsilon = 1e-6) {
  ((signal - fragility) * restraint) / (extraction + epsilon)
}

# ---- Signal Derivative ----
signal_derivative <- function(signal, time) {
  diff(signal) / diff(time)
}

# ---- Collapse Detection ----
detect_collapse <- function(signal, time) {
  dS <- signal_derivative(signal, time)
  any(dS < 0)
}

# ---- Poker Signal ----
poker_signal <- function(ev, showdown, volatility, alpha = 1, beta = 1, gamma = 1) {
  alpha * ev + beta * showdown - gamma * volatility
}

# ---- Sustainability Index ----
sustainability_index <- function(maturity_vector, weights = NULL) {
  if (is.null(weights)) {
    weights <- rep(1 / length(maturity_vector), length(maturity_vector))
  }
  sum(weights * maturity_vector)
}
