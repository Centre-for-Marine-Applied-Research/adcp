# Generate current rose

The direction of the petal indicates the direction the current is
flowing to. The colour indicates the current speed. The length of the
petal shows the number of observations for each current speed and
direction bin.

## Usage

``` r
adcp_plot_current_rose(
  dat,
  pal = NULL,
  speed_col = sea_water_speed_cm_s_labels,
  direction_col = sea_water_to_direction_degree_labels,
  speed_label = "Current Speed (cm/s)",
  ncol_legend = 2,
  calculate_prop = TRUE
)
```

## Arguments

- dat:

  Data frame with at least 2 columns: an ordered factor of direction
  groups, and a factor of speed groups. By default, the proportion of
  observations in each group (speed and direction) is counted in the
  function. If more groups are required, set `calculate_prop = FALSE`,
  and include the proportions in a column called `n_prop`. The
  proportion is automatically converted to percent for the figure.

- pal:

  Vector of colours. Must be the same length as the number of speed
  factor levels.

- speed_col:

  The column in `dat` that holds the speed groups (NOT QUOTED).

- direction_col:

  The column in `dat` that holds the direction groups (NOT QUOTED).

- speed_label:

  Title of the current speed legend. Default is "Current Speed (cm/s)".

- ncol_legend:

  Number of columns for the figure legend. Default is 2.

- calculate_prop:

  Logical argument. The default, `TRUE`, will calculate the proporation
  of observations in each speed and direction group. Set to `FALSE` to
  include proporation in `dat`.

## Value

Returns a ggplot object, a rose plot of current speed and direction.
