#' Cut wind direction into 8 or 16 bins
#'
#' Adapted from \code{cutVecWinddir()} from \code{OpenAir}.
#'
#' Likely more efficient in the original vectorized form. Modified to match
#' \code{adcp_label_speed()}. Could re-visit both.
#'
#' If \code{n_petals} is 8: Assigns direction data in bins of 45 degrees. -22.5
#' to 22.5 degree is North, 22.5 to 67.5 is NE, etc.
#'
#' If \code{n_petals} is 16 (the default): Assigns direction data in bins of
#' 22.5 degrees. -11.25 to 11.25 degree is North, 11.25 to 33.75 is NNE, etc.
#'
#' @param dat Data frame with column sea_water_to_direction_degree.
#'
#' @param n_petals Number of bins to divide direction data into. Must be either
#'   8 or 16.
#'
#' @param column Column in \code{dat} that will be assigned direction intervals
#'   (NOT QUOTED).
#'
#' @returns Returns \code{dat} with an additional column
#'   \code{sea_water_to_direction_degree_labels}, the direction labels as an
#'   ordered factor.
#'
#' @export


adcp_label_direction <- function(
    dat,
    n_petals = 16,
    column = sea_water_to_direction_degree
) {

  if(n_petals != 8 & n_petals != 16) {

    warning("n_petals must be 8 or 16, not << ", n_petals, ">>. n_petal will be changed to 16.")

    n_petals <- 16
  }

  dat <- dat %>%
    mutate(col_to_cut = {{ column }})

  if(n_petals == 8) {
    min_break <- 22.5

    dat <- dat %>%
      mutate(
        dir_label = cut(
          col_to_cut,
          breaks = seq(22.5, 382.5, 45),
          labels = c("NE", "E", "SE", "S", "SW", "W", "NW", "N")
        )
      )
    # $sea_water_to_direction_degree_labels <- cut(
    #   dat$sea_water_to_direction_degree,
    #   breaks = seq(22.5, 382.5, 45),
    #   labels = c("NE", "E", "SE", "S", "SW", "W", "NW", "N")
    # )

    levels <- c("N", "NE", "E", "SE", "S", "SW", "W", "NW")
  }

  if(n_petals == 16) {
    min_break <- 11.25

    dat <- dat %>%
      mutate(
        dir_label = cut(
          col_to_cut,
          breaks = seq(11.25, 371.25, 22.5),
          labels = c(
            "NNE", "NE", "ENE", "E", "ESE", "SE", "SSE", "S",
            "SSW", "SW", "WSW", "W", "WNW", "NW", "NNW", "N")
        )
      )

    # dat$sea_water_to_direction_degree_labels <- cut(
    #   dat$sea_water_to_direction_degree,
    #   breaks = seq(11.25, 371.25, 22.5),
    #   labels = c(
    #     "NNE", "NE", "ENE", "E", "ESE", "SE", "SSE", "S",
    #     "SSW", "SW", "WSW", "W", "WNW", "NW", "NNW", "N")
    # )

    levels <- c("N", "NNE", "NE", "ENE", "E", "ESE", "SE", "SSE", "S",
                "SSW", "SW", "WSW", "W", "WNW", "NW", "NNW")
  }

  dat %>%
    mutate(
      # for direction <= 22.5
      dir_label = if_else(
        is.na(dir_label) & col_to_cut >= 0 & col_to_cut <= min_break, "N",
        dir_label
      ),
      "{{column}}_labels" := ordered(dir_label, levels = levels)
    )  %>%
    select(-c(col_to_cut, dir_label))
  # rename("{{column}}" := col_to_cut)

}
