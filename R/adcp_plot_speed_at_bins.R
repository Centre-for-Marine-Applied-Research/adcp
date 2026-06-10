#' Plot sea water speed through the water column
#'
#' @param dat Data frame with columns \code{bin_height_above_sea_floor} (a
#'   factor), \code{summary_col}, \code{min_col}, \code{max_col}, and optionally
#'   \code{shape_col}.
#'
#' @param summary_col Column with the summary value (UNQUOTED). Default is
#'   \code{med_sea_water_speed_cm_s}.
#'
#' @param min_col Column with the minimum values for the error bar (UNQUOTED).
#'   Default is \code{q_25}.
#'
#' @param max_col Column with the maximum values for the error bar (UNQUOTED).
#'   Default is \code{q_75}.
#'
#' @param shape_col Column to map onto shape (UNQUOTED). Optional.
#'
#' @param pal_col Column to map to colour (UNQUOTED). Must be a factor.
#'
#' @param pal Option colour palette.
#'
#' @param pal_label Character string. Title for the colour legend.
#'
#' @param x_label Character string. Title for the x-axis.
#'
#' @return Returns a ggplot object.
#'
#' @importFrom dplyr reframe
#' @importFrom ggplot2 aes element_blank element_rect geom_point geom_errorbar
#'   ggplot scale_colour_manual scale_shape_manual scale_x_continuous
#'   scale_y_discrete theme
#'
#' @export

adcp_plot_speed_at_bins <- function(
    dat,
    summary_col = med_sea_water_speed_cm_s,
    min_col = q_25,
    max_col = q_75,
    shape_col = NULL,
    pal_col = med_sea_water_speed_cm_s_labels,
    pal = NULL,
    pal_label = "Current Speed (cm/s)",
    x_label = "Current Speed (cm/s)"

) {

  if (is.null(pal)) {
    n_levels <-  nrow(reframe(dat, levels({{ pal_col }})))
    pal <- get_speed_colour_pal(n_levels)
  }

  ggplot(
    dat,
    aes({{ summary_col }},
        bin_height_above_sea_floor_m,
        col = {{ pal_col }},
        shape = {{ shape_col }})
  ) +
    geom_point(size = 3, show.legend = TRUE) +
    geom_errorbar(
      aes(xmin = {{ min_col }}, xmax = {{ max_col }}),
      width = 0, show.legend = TRUE) +
    scale_colour_manual(pal_label, values = pal, drop = FALSE) +
    scale_x_continuous(x_label) +
    scale_y_discrete(name = "Bin Height Above Sea Floor (m)", limits = rev) +
    scale_shape_manual(values = c(19, 21), guide = "none") +
    adcp_theme() +
    theme(
      # legend.position = "right",
      # panel.border =  element_rect(colour = "gray70", fill = NA),
      # panel.background = element_rect(fill = NA),
      panel.grid = element_blank()
    )
}
