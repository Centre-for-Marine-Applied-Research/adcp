test_that("adcp_assign_max_flag() assigns correct flag value", {
  expect_equal(
    max_flag$qc_flag_sea_water_speed_m_s,
    ordered( c(1, 2, 3, 4, 4), levels = 1:4)
  )

  expect_equal(
    max_flag$qc_flag_sea_water_to_direction_degree,
    ordered( c(2, 2, 3, 4, 4), levels = 1:4)
  )
})
