#' Assign intervals to numeric data
#'
#' Assigns intervals to \code{column} using the \code{cut()} function.
#' \code{column} will typically be a \code{sea_water_speed} column. To label
#' direction data, use \code{adcp_label_direction()}.
#'
#' Intervals start and 0 and end at the smallest value that includes all
#' observations and results in \code{n_ints} equal intervals. Some small and/or
#' large intervals may have zero observations.
#'
#' @param dat Data frame including the column with observations that will be
#'   assigned to intervals. The interval size is determined by the range of
#'   these observations and \code{n_ints}.
#'
#' @param column Column in \code{dat} that will be assigned to intervals for
#'   frequency table (NOT QUOTED).
#'
#' @param n_ints Number of intervals to divide observations into. The interval
#'   size is determined by the range of these observations and \code{n_ints}.
#'   Alternatively, a vector of two or more unique break points. Passed to the
#'   \code{breaks} argument of \code{cut()}.
#'
#' @param upper_value Value used to generate the upper limit of the final
#'   interval. Default is the maximum values of \code{ column }.
#'
#' @param label_sep Separator for the interval labels ("lower to upper").
#'   Default is a new line to save room on plot axis.
#'
#' @return Returns \code{dat} with an additional column \code{column_labels},
#'   the interval labels as an ordered factor.
#'
#' @importFrom dplyr arrange mutate pull select tibble
#' @importFrom DescTools RoundTo
#' @importFrom rlang :=
#'
#' @export

adcp_label_speed <- function(
    dat,
    column = sea_water_speed_cm_s,
    n_ints = 12,
    upper_value = NULL,
    label_sep = " "
) {

  dat <- dat %>%
    mutate(col_to_cut = {{ column }})

  vals <- dat %>% pull(col_to_cut)
  if (is.null(upper_value)) {
    max_value <- RoundTo(max(vals, na.rm = TRUE), n_ints, FUN = ceiling)
  } else{
    max_value <- RoundTo(upper_value, n_ints, FUN = ceiling)
  }
  cut_width <- max_value / n_ints # interval width for n_ints intervals from 0 to max_value

  dat$ints <- cut(
    dat$col_to_cut,
    breaks =  seq(0, max_value, cut_width),
    include.lowest = TRUE # smallest interval will be left AND right inclusive
  )

  dat <- dat %>%
    separate(
      col = "ints", into = c("lower", "upper"), sep = ",", remove = FALSE
    ) %>%
    mutate(
      lower = as.numeric(str_remove(lower, pattern = "\\(|\\[|\\)|\\]")),
      upper = as.numeric(str_remove(upper, pattern = "\\(|\\[|\\)|\\]")),
      ints_label = paste(lower, "to", upper, sep = label_sep),
    )

  # int labels in order from lowest to highest speeds
  ints_levels <- data.frame(int_levels = levels(dat$ints)) %>%
    separate(
      col = "int_levels", into = c("lower", "upper"), sep = ",", remove = FALSE
    ) %>%
    mutate(
      lower = as.numeric(str_remove(lower, pattern = "\\(|\\[|\\)|\\]")),
      upper = as.numeric(str_remove(upper, pattern = "\\(|\\[|\\)|\\]")),
      ints_levels = paste(lower, "to", upper, sep = label_sep),
    ) %>%
    pull(ints_levels)

  # convert int_labels to factor so they are in the correct order for the barplot
  dat  %>%
    mutate("{{column}}_labels" := factor(ints_label, levels = ints_levels)) %>%
    select(-c(col_to_cut, ints, lower, upper, ints_label))

}
