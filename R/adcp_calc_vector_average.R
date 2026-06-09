#' Generate summary table of flags
#'
#' Calculate the vector average for current speed and direction.
#'
#' Step 1: calculate components of each direction vector weighted by speed.
#'
#' \deqn{vx = speed * sin(direction_{degree} * pi / 180)}
#'
#' \deqn{vy = speed * cos(direction_{degree} * pi / 180)}
#'
#' Step 2: Calculate average of each component.
#'
#' \deqn{vx_{mean} = mean(vx)}
#'
#' \deqn{vy_{mean} = mean(vy)}
#'
#' Step 3: Calculate new vector based on the mean components.
#'
#' \deqn{direction_{mean} = atan2(vx_{mean}, vy_{mean}) * 180/pi}
#'
#' \deqn{direction_{mean} = (360 + direction_{mean}) \%\% 360}
#'
#' \deqn{speed_{mean} = sqrt(vy_{mean}^2 + vx_{mean}^2)}
#'
#' @param dat Data frame with columns for speed and direction and optional
#'   grouping arguments.
#'
#' @param direction_degree_col The column in \code{dat} that holds the direction
#'   data (NOT QUOTED). Must be in units of degrees from vertical.
#'
#' @param speed_col The column in \code{dat} that holds the speed data (NOT
#'   QUOTED).
#'
#' @param return_components Logical argument. If \code{TRUE} the x and y vector
#'   components.
#'
#' @param ... Optional argument. Column names (not quoted) from \code{dat} to
#'   use as grouping variables.
#'
#' @return Returns \code{dat} with additional columns.
#'
#' @importFrom dplyr mutate n rename select  summarise
#'
#' @export

adcp_calculate_vector_average <- function(
    dat,
    ...,
    speed_col = sea_water_speed_cm_s,
    direction_degree_col = sea_water_to_direction_degree,
    return_components = FALSE
) {

  dat_comp <- dat %>%
    rename(
      speed = {{ speed_col}},
      direction_degree = {{ direction_degree_col }}
    ) %>%
    mutate(
      v_x = speed * sin(direction_degree * pi / 180),
      v_y = speed * cos(direction_degree * pi / 180)
    ) %>%
    dplyr::group_by(...) %>%
    summarise(
      v_x_mean = mean(v_x),
      v_y_mean = mean(v_y),
      .groups = "drop"
    ) %>%
    mutate(
      mean_direction_degree = atan2(v_x_mean, v_y_mean) * 180/pi,
      # maps from (-180 to 180) to (0, 359)
      mean_direction_degree = round(
        (360 + mean_direction_degree) %% 360, digits = 2),
      mean_speed = round(sqrt(v_y_mean^2 + v_x_mean^2), digits = 2)
    )

  if(isFALSE(return_components)) {
    dat_comp <- dat_comp %>%
      select(-c(v_x_mean, v_y_mean))
  }

  dat_comp %>%
    rename(
      "{{ speed_col }}" := mean_speed,
      "{{ direction_degree_col }}" := mean_direction_degree
    )


}
