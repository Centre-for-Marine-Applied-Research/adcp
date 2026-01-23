#' Count number and proportion of observations in equal intervals
#'
#' @details Assigns intervals to \code{column} using the \code{cut()} function.
#'   Argument \code{right = TRUE} to match the intervals assigned in the
#'   \code{openair::windRose()} function (which is called in
#'   \code{adcp_plot_current_rose()}). This means intervals are right-inclusive,
#'   i.e., a value of 4 is assigned to the interval (1,4].
#'
#'   NOTE: The \code{openair::windRose()} function has the \code{cut()}
#'   argument \code{include.lower} hard-coded to \code{FALSE}. This causes an
#'   issue with the intervals extracted from \code{adcp_count_obs()} being
#'   passed to \code{adcp_plot_current_rose()} (which passes all arguments to
#'   \code{openair::windRose()}).
#'
#'   Assume the first interval is in the form (x1, x2], and the minimum value of
#'   the observations is xmin.
#'
#'   This means that if the round(x1, digits = n_digits) equals xmin, values of
#'   xmin will NOT be assigned to an interval. In this case, xmin falls outside
#'   of the first interval (because it is left exclusive). To avoid this,
#'   n_digits should be large enough to ensure round(x1, digits = n_digits) <
#'   xmin. This could also be solved if \code{include.lower} could be set to
#'   \code{TRUE} in \code{openair::windRose()}.
#'
#'   NOTE: I submitted a Pull Request to Open Air. I think it was merged. So
#'   could update the include.lower call here, but will need to think about
#'   this.
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
#' @param n_digits Number of digits to show in interval labels. Note that
#'   additional digits may be used in the actual break values. See vignettes for
#'   more detail. Passed to the \code{dig.lab} argument of \code{cut()}.
#'
#' @param lowest Logical. If \code{TRUE}, the first interval will be left *and*
#'   right inclusive. Passed to the \code{include.lowest} argument of
#'   \code{cut()}.
#'
#' @param label_sep Separator for the interval labels ("lower to upper").
#'   Default is a new line to save room on plot axis.
#'
#' @return Returns a data frame of lower and upper interval limits (right
#'   inclusive), and frequency and proportion of observations in each interval.
#'
#' @importFrom dplyr arrange mutate pull select tibble
#'
#' @export

adcp_count_obs <- function(dat,
                           column = sea_water_speed_cm_s,
                           n_ints = 12,
                           n_digits = 4,
                           label_sep = "\n",
                           lowest = FALSE) {


  # frequency table with n_ints even bins
  ints <- dat %>%
    pull({{ column }}) %>%
    cut(
      breaks = n_ints,
      dig.lab = n_digits,
      right = TRUE, # for consistency with the openair::windRose
      include.lowest = lowest
    ) %>%
    table() %>%
    data.frame() %>%
    # extract lower and upper bin limits
    separate(col = 1, into = c("lower", "upper"), sep = ",") %>%
    mutate(
      lower = as.numeric(str_remove(lower, pattern = "\\(|\\[|\\)|\\]")),
      upper = as.numeric(str_remove(upper, pattern = "\\(|\\[|\\)|\\]"))
    )

  # to avoid negative intervals and very small start intervals
  if (min(ints$lower) < 1e-4) {
    ints[which(ints$lower == min(ints$lower)), "lower"] <- 0

    message("Lower bound of first interval set to 0")
  }

  # create bin label and calculate proportion
  ints <- ints %>%
    mutate(
      ints_label = paste(lower, "to", upper, sep = label_sep),
      prop = Freq / sum(Freq) * 100
    ) %>%
    select(lower, upper, ints_label, freq = Freq, prop) %>%
    arrange(lower)

  # int labels in order from lowest to highest speeds
  ints_levels <- ints$ints_label

  # convert int_labels to factor so they are in the correct order for the barplot
  ints %>%
    mutate(
      ints_label = factor(ints_label, levels = ints_levels)
    )
}
