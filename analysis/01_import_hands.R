# Analysis/01_import_hands.R

library(readr)
library(stringr)
library(dplyr)
library(purrr)
library(tidyr)

raw_dir <- "data/raw/poker"

files <- list.files(raw_dir, pattern = "\\.txt$", full.names = TRUE)

read_hh <- function(path) {
  lines <- read_lines(path, progress = FALSE)
  tibble(
    file = basename(path),
    line_no = seq_along(lines),
    line = lines
  )
}

hh <- map_dfr(files, read_hh)

# Quick sanity checks
cat("Files loaded:", length(files), "\n")
print(hh %>% group_by(file) %>% summarise(lines = n(), .groups = "drop"))

# Save raw-as-table (so we never re-parse raw files unless needed)
dir.create("data/processed", showWarnings = FALSE, recursive = TRUE)
write_csv(hh, "data/processed/hh_lines.csv")

cat("Saved: data/processed/hh_lines.csv\n")

