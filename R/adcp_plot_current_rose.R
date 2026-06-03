#' Generate current rose
#'
#' The direction of the petal indicates the direction the current is flowing to.
#' The colour indicates the current speed. The length of the petal shows the
#' number of observations for each current speed and direction bin.
#'
#' @param dat Data frame with at least 2 columns: an ordered factor of direction
#'   groups, and a factor of speed groups. By default, the proportion of
#'   observations in each group (speed and direction) is counted in the
#'   function. If more groups are required, set \code{calculate_prop = FALSE},
#'   and include the proportions in a column called \code{n_prop}. The
#'   proportion is automatically converted to percent for the figure.
#'
#' @param direction_col The column in \code{dat} that holds the direction groups
#'   (NOT QUOTED).
#'
#' @param speed_col The column in \code{dat} that holds the speed groups (NOT
#'   QUOTED).
#'
#' @param pal Vector of colours. Must be the same length as the number of speed
#'   factor levels.
#'
#' @param speed_label Title of the current speed legend. Default is "Current
#'   Speed (cm/s)".
#'
#' @param ncol_legend Number of columns for the figure legend. Default is 2.
#'
#' @param calculate_prop Logical argument. The default, \code{TRUE}, will
#'   calculate the proporation of observations in each speed and direction
#'   group. Set to \code{FALSE} to include proporation in \code{dat}.
#'
#' @return Returns a ggplot object, a rose plot of current speed and direction.
#'
#' @importFrom dplyr reframe
#' @importFrom ggplot2 aes coord_radial element_blank element_line element_rect
#'   geom_col ggplot position_stack scale_fill_manual scale_x_discrete theme
#' @importFrom scales percent
#' @importFrom viridis viridis
#'
#'
#' @export


adcp_plot_current_rose <- function(
    dat,
    pal = NULL,
    speed_col = sea_water_speed_cm_s_labels,
    direction_col = sea_water_to_direction_degree_labels,
    speed_label = "Current Speed (cm/s)",
    ncol_legend = 2,
    calculate_prop = TRUE
) {

  if (is.null(pal)) {
    n_levels <-  nrow(reframe(dat, levels({{ speed_col }})))
    pal <- get_speed_colour_pal(n_levels)
  }

  n_dir_levels <- length(levels(dat[[deparse(substitute(direction_col))]]))

  if(n_dir_levels == 8) theta <- -22.5
  if(n_dir_levels == 16) theta <- -11.25


  if(isTRUE(calculate_prop)) {
    dat <- dat %>%
    #  group_by({{ speed_col }}, {{ direction_col}}, drop = FALSE) %>%
      summarise(n = n(), .by = c({{ speed_col }}, {{ direction_col}}),
                drop = FALSE) %>%
      ungroup() %>%
      mutate(n_prop = n / sum(n))
  }

  ggplot(
    dat,
    aes({{ direction_col }}, n_prop, fill = {{ speed_col }})
  ) +
    geom_col(show.legend = TRUE, position = position_stack(reverse = TRUE)) +
    scale_fill_manual(speed_label, values = pal, drop = FALSE) +
    scale_x_discrete(
      expand = expansion(add = c(0.5, 0.5)),
      drop = FALSE
    ) +
    scale_y_continuous(labels = scales::percent) +
    coord_radial(start = theta * pi / 180, r.axis.inside = TRUE) +
    guides(fill = guide_legend(ncol =  ncol_legend)) +
    theme(
      axis.title.x = element_blank(),
      axis.title.y = element_blank(),

      axis.ticks.x = element_blank(),
      axis.ticks.y = element_blank(),

      axis.text.x = element_text(color = 1),

      panel.border =  element_rect(colour = "gray50", fill = NA, linewidth = 0.25),
      panel.background = element_rect(fill = NA, color = NA),

      panel.grid = element_line(color = "gray70", linewidth = 0.25),
      panel.grid.minor.y = element_blank()
    )
}



# adcp_plot_current_rose_old <- function(
    #     dat,
#     breaks,
#     speed_column, direction_column,
#     speed_colors = NULL,
#     speed_label = "Current Speed (cm/s)"
#    # add_dir_labs = TRUE
# ) {
#   if (is.null(speed_colors)) {
#     speed_colors <- viridis(breaks, option = "F", direction = -1)
#   }
#
#   dat <- dat %>%
#     select(SPEED = {{ speed_column }}, DIRECTION = {{ direction_column }})
#
#   p <- openair::windRose(
#     dat,
#     ws = "SPEED", wd = "DIRECTION",
#     breaks = breaks,
#     cols = speed_colors,
#     paddle = FALSE,
#     auto.text = FALSE,
#     annotate = FALSE,
#     key.header = speed_label,
#     key.footer = "",
#     key.position = "right",
#     plot = FALSE
#   )
#
#   # if(isTRUE(add_dir_labs)) {
#   #
#   #   p <- p$plot +
#   #     latticeExtra::layer(
#   #       lattice::ltext(0, 5, "N", cex = 0.75, col = "darkgrey")
#   #     ) +
#   #     latticeExtra::layer(
#   #       lattice::ltext(5, 0, "E", cex = 0.75, col = "darkgrey")
#   #     ) +
#   #     latticeExtra::layer(
#   #       lattice::ltext(-5, 0, "W", cex = 0.75, col = "darkgrey")
#   #     ) +
#   #     latticeExtra::layer(
#   #       lattice::ltext(0, -5, "S", cex = 0.75, col = "darkgrey")
#   #     )
#   # }
#
#   p
#
# }







