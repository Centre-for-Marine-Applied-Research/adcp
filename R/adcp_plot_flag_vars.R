#' Plot current data coloured by flag value
#'
#' @param dat Data frame of flagged current data in long or wide format. Must
#'   include at least one column name with the string "_flag_variable".
#'
#' @param vars Character vector of variables to plot. Default is \code{vars =
#'   "all"}, which will make a plot for each recognized variable in \code{dat}.
#'
#' @param qc_tests Character string of QC tests to plot. Default is
#'   \code{qc_tests = c("tidal_bin_height", "grossrange", "qc")}. Will also work
#'   for "rolling_sd" and "spike".
#'
#' @param labels Logical argument indicating whether to convert numeric flag
#'   values to text labels for the legend.
#'
#' @param n_col Number of columns for faceted plots.
#'
#' @param flag_title Logical argument indicating whether to include a ggtitle of
#'   the qc test and variable plotted.
#'
#' @param plotly_friendly Logical argument. If \code{TRUE}, the legend will be
#'   plotted when \code{plotly::ggplotly} is called on \code{p}. Default is
#'   \code{FALSE}, which makes the legend look better in a static figure.
#'
#' @param legend_position Legend position. Default is "right".
#'
#' @return Returns a list of ggplot objects; one figure for each test in
#'   \code{qc_tests} and variable in \code{vars}. Points are coloured by the
#'   flag value and panels are faceted by depth and sensor. faceted by depth and
#'   sensor.
#'
#' @importFrom lubridate as_datetime
#'
#' @export
#'

adcp_plot_flags <- function(
    dat,
    qc_tests = c("tidal_bin_height", "grossrange", "qc"),
    vars = "all",
    labels = TRUE,
    n_col = NULL,
    flag_title = TRUE,
    plotly_friendly = FALSE,
    legend_position = "right"
) {

  p_out <- list()

  if (!("variable" %in% colnames(dat))) {
    dat <- adcp_pivot_flags_longer(dat, qc_tests = qc_tests)
  }

  if (vars == "all") vars <- unique(dat$variable)

  if (isTRUE(labels)) dat <- dat %>% qaqcmar::qc_assign_flag_labels()

  if (is.null(n_col)) n_col <- length(unique(dat$variable))

  # levels_height <- sort(
  #   unique(dat$bin_height_above_sea_floor_m), decreasing = TRUE
  # )
  # dat <- dat %>%
  #   mutate(
  #     bin_height_above_sea_floor_m =
  #       ordered(bin_height_above_sea_floor_m, levels = levels_height)
  #   )

  # plot for each test
  for (j in seq_along(qc_tests)) {
    qc_test_j <- qc_tests[j]

    p_out[[qc_test_j]] <- adcp_ggplot_flags(
      dat,
      qc_test = qc_test_j,
      n_col = n_col,
      plotly_friendly = plotly_friendly,
      flag_title = flag_title,
      legend_position = legend_position
    )
  }

  p_out
}


#' Create ggplot for one current qc_test and variable
#'
#' @param dat Data frame of flagged current data in long format. Must
#'   include a column named with the string "_flag_value".
#'
#' @param qc_test qc test to plot.
#'
#' @inheritParams adcp_plot_flags
#'
#' @return Returns a ggplot object; a figure for \code{qc_test}.
#'   Points are coloured by the flag value and panels are faceted by depth and
#'   sensor.
#'
#' @importFrom ggplot2 aes element_rect element_text facet_wrap geom_point
#'   ggplot ggtitle guides guide_legend  scale_colour_manual scale_x_datetime
#'   scale_y_continuous theme_light theme
#'
#' @importFrom gtools mixedsort

adcp_ggplot_flags <- function(
    dat,
    qc_test,
    n_col = NULL,
    flag_title = TRUE,
    plotly_friendly = FALSE,
    legend_position = "right"
) {
  # https://www.visualisingdata.com/2019/08/five-ways-to-design-for-red-green-colour-blindness/
  flag_colours <- c("chartreuse4", "grey24", "#EDA247", "#DB4325")

  flag_column <- paste0(qc_test, "_flag_value")

  p <- dat %>%
    adcp_convert_vars_to_title() %>%
    ggplot(aes(timestamp_utc, value, col = !!sym(flag_column))) +
    geom_point(show.legend = TRUE, size = 0.5) +
    scale_x_datetime("Date", date_labels = "%Y-%m-%d") +
    scale_colour_manual("Flag Value", values = flag_colours, drop = FALSE) +
    theme_light() +
    theme(
      strip.placement = "outside",
      strip.background = element_rect(colour = "grey80", fill = NA),
      strip.text = element_text(colour = "grey30", size = 10),
      legend.position = legend_position
    )

  if(length(unique(dat$variable)) == 1) {
    p <- p +
      facet_wrap(
        ~bin_height_above_sea_floor_m,
        ncol = n_col,
        scales = "fixed"
      )
  } else {
    p <- p +
      facet_wrap(
        ~bin_height_above_sea_floor_m + variable_title,
        ncol = n_col,
        scales = "free_y"
      )
  }

  if(isFALSE(plotly_friendly)) {
    p <- p + guides(color = guide_legend(override.aes = list(size = 4)))
  }

  if(isTRUE(flag_title)) p <- p + ggtitle(paste0(qc_test, " test"))

  p
}

