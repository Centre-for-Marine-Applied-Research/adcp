test_that("adcp_calculate_vector_average() calcuates correct averages without groups", {

  expect_equal(
    adcp_calculate_vector_average(data.frame(
      sea_water_speed_cm_s = c(1, 1),
      sea_water_to_direction_degree = c(0, 90))
    ),
    tibble(
      #sd_sea_water_speed_cm_s = 0,
      sea_water_to_direction_degree = 45,
      sea_water_speed_cm_s = 0.71
    )
  )

  expect_equal(
    adcp_calculate_vector_average(data.frame(
      sea_water_speed_cm_s = c(1, 1),
      sea_water_to_direction_degree = c(20, 340))
    ),
    tibble(
     # sd_sea_water_speed_cm_s = 0,
      sea_water_to_direction_degree = 0,
      sea_water_speed_cm_s = 0.940
    )
  )

  expect_equal(
    adcp_calculate_vector_average(data.frame(
      sea_water_speed_cm_s = c(1, 0.5),
      sea_water_to_direction_degree = c(0, 180))
    ),
    tibble(
     # sd_sea_water_speed_cm_s = 0.35,
      sea_water_to_direction_degree = 0,
      sea_water_speed_cm_s = 0.25
    )
  )

  expect_equal(
    adcp_calculate_vector_average(data.frame(
      sea_water_speed_cm_s = c(1, 1),
      sea_water_to_direction_degree = c(90, 270))
    ),
    tibble(
     # sd_sea_water_speed_cm_s = 0,
      sea_water_to_direction_degree = 180,
      sea_water_speed_cm_s = 0
    )
  )

})



test_that("adcp_calculate_vector_average() calcuates correct group averages", {

 # expect_equal(dat_vec$sd_sea_water_speed, c(0, 0, NA, 0.35))

  expect_equal(dat_vec$sea_water_to_direction_degree,
               c(45.00, 82.75, 272, 26.57))

  expect_equal(dat_vec$sea_water_speed, c(0.71, 0.59, 1, 0.56))

})
