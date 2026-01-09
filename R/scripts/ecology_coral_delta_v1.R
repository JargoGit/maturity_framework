library(tidyverse)
library(lubridate)
library(zoo)

# 1) read a CRW virtual station txt you downloaded
# (you may need to skip comment lines depending on file format)
path <- "data/raw/ecology/coral/crw_virtual_stations/STATION_NAME.txt"

raw <- read_lines(path)

# ---- minimal parser approach ----
# Many CRW station txt files have header/comment lines; find the first data row.
# If your file is already clean tabular, replace this with read_table()/read_delim().
start_i <- which(str_detect(raw, "^\\d{4}-\\d{2}-\\d{2}"))[1]
dat <- read_delim(
  I(paste(raw[start_i:length(raw)], collapse = "\n")),
  delim = "\\s+",
  show_col_types = FALSE
)

# You need columns that include a date and DHW.
# Inspect:
print(names(dat))

# Rename to standard (edit these once based on your file’s real column names)
dat <- dat %>%
  rename(
    date = 1,
    dhw  = matches("DHW|DegreeHeatingWeek|degree_heating", ignore.case = TRUE)
  ) %>%
  mutate(date = as.Date(date)) %>%
  arrange(date)

# 2) Annual max DHW (strain)
annual <- dat %>%
  mutate(year = year(date)) %>%
  group_by(year) %>%
  summarise(annual_max_dhw = max(dhw, na.rm = TRUE), .groups = "drop") %>%
  arrange(year)

# 3) Rolling floor + rolling median across years (v1 = 10-year)
k <- 10
annual <- annual %>%
  mutate(
    rolling_min   = rollapply(annual_max_dhw, k, min, fill = NA, align = "right"),
    rolling_median= rollapply(annual_max_dhw, k, median, fill = NA, align = "right")
  )

# 4) “Delta moment” candidate: first year where rolling_min lifts above prior baseline
# (v1: simplest detection — you can refine later)
first_valid_year <- annual$year[which(!is.na(annual$rolling_min))[1]]
baseline <- first(annual$rolling_min[!is.na(annual$rolling_min)])

annual_summary <- annual %>%
  summarise(
    first_valid_year = first_valid_year,
    first_valid_min  = first(rolling_min[!is.na(rolling_min)]),
    max_rolling_min  = max(rolling_min, na.rm = TRUE),
    baseline_min     = baseline
  )

print(annual_summary)
