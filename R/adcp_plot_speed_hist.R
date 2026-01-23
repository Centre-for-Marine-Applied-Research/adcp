#' Plot histogram of speed observations
#'
#' @inheritParams adcp_plot_current_rose
#'
#' @param dat Data frame with at least 1 columns: a factor of speed groups. The
#'   proportion and percent of observations in each group is counted in the
#'   function.
#'
#' @param speed_label Title of the current speed legend. Default is "Current
#'   Speed (cm/s)".
#'
#' @param text_size Size of the text annotating the number of observations in
#'   each bin.
#'
#' @return Returns a ggplot object.
#'
#' @importFrom dplyr reframe
#' @importFrom ggplot2 expansion geom_col geom_hline geom_text scale_fill_manual
#'   scale_x_discrete scale_y_continuous
#'
#' @export

adcp_plot_speed_hist <- function(
    dat,
    pal = NULL,
    speed_col = sea_water_speed_cm_s_labels,
    text_size = 3,
    speed_label = "Current Speed (cm/s)"
) {

  if (is.null(pal)) {
    n_levels <-  nrow(reframe(dat, levels({{ speed_col }})))
    pal <- get_speed_colour_pal(n_levels)
  }

  theme_col <- "gray70"

  dat %>%
    group_by({{ speed_col }}, drop = FALSE) %>%
    summarise(n = n()) %>%
    ungroup() %>%
    mutate(
      n_prop = n / sum(n),
      n_percent = n_prop * 100
    ) %>%
    ggplot(aes( {{ speed_col }}, n_percent, fill = {{ speed_col }})) +
    geom_col(col = 1) +
    geom_text(
      aes(label = format(n, big.mark = ",")),
      vjust = -0.5, size = text_size
    ) +
    geom_hline(yintercept = 0) +
    scale_fill_manual(values = pal, guide = "none") +
    scale_x_discrete(speed_label, drop = FALSE) +
    scale_y_continuous(
      "Percent of Observations (%)",
      minor_breaks = NULL,
      expand = expansion(mult = c(0, 0.1))
    ) +
    adcp_theme()

}
