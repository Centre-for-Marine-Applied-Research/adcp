test_that("adcp_pivot_flags_longer() returns correct columns", {
  expect_equal(
    colnames(dat_piv_long),
    c("timestamp_utc",
    "bin_depth_below_surface_m",
    "bin_height_above_sea_floor_m",
    "variable",
    "value",
    "tidal_bin_height_flag_value",
    "grossrange_flag_value"
  ))
})

test_that("adcp_pivot_flags_wider() does not pivot tidal_bin_height_test", {
  expect_true("tidal_bin_height_flag" %in% colnames(dat_piv_wide))
})


test_that("adcp_pivot_flags_wider() returns correct dimensions", {
  expect_equal(ncol(dat_piv), ncol(dat_piv_wide))
  expect_equal(nrow(dat_piv), nrow(dat_piv_wide))
})
