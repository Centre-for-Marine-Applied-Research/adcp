# November 26, 2025

# Simulate data for the tidal bin height test
# 10.61: fail
# 9.61: Suspect/Of Interest
# 8.61: Pass


library(dplyr)
library(ggplot2)
library(lubridate)
library(here)
library(stringr)
library(tidyr)

# Raw data ----------------------------------------------------------------
path <- here("inst/testdata")

tracking <- adcp_read_tracking() %>%
  filter(depl_id == "YR009")

dat <- adcp_read_txt(path, "2022-09-29_western_shoal.txt") %>%
  adcp_assign_altitude(tracking) %>%
  adcp_correct_timestamp() %>%
  adcp_pivot_bin_height() %>%
  adcp_calculate_bin_depth(tracking) %>%
  filter(
    bin_height_above_sea_floor_m %in% c(8.61, 9.61, 10.61),
    timestamp_utc >= as_datetime("2022-10-01"),
    timestamp_utc <= as_datetime("2022-10-07 12:00:00")
  ) %>%
  group_by(bin_height_above_sea_floor_m) %>%
  filter(row_number() %% 5 == 0) %>%
  filter(
    bin_height_above_sea_floor_m %in%  c(8.61, 9.61) |
    (row_number() %% 2 == 0 & bin_height_above_sea_floor_m == 10.61)
  ) %>%
  ungroup() %>%
  arrange(bin_height_above_sea_floor_m, timestamp_utc)

ggplot(dat, aes(timestamp_utc, sensor_depth_below_surface_m)) +
  geom_point() +
  facet_wrap(~bin_height_above_sea_floor_m, ncol = 1)

dat_qc <- dat %>%
  adcp_test_tidal_bin_height(sensor_model = tracking$sensor_model) %>%
  adcp_pivot_flags_longer(qc_tests = "tidal_bin_height")

adcp_plot_flags(dat_qc, qc_tests = "tidal_bin_height")

# Export rds file
saveRDS(dat, file = here("inst/testdata/current_test_data_tidal_bin_height.RDS"))

