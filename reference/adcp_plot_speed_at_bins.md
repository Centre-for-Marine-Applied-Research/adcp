# Plot sea water speed through the water column

Plot sea water speed through the water column

## Usage

``` r
adcp_plot_speed_at_bins(
  dat,
  summary_col = med_sea_water_speed_cm_s,
  min_col = q_25,
  max_col = q_75,
  shape_col = NULL,
  pal_col = med_sea_water_speed_cm_s_labels,
  pal = NULL,
  pal_label = "Current Speed (cm/s)",
  x_label = "Current Speed (cm/s)"
)
```

## Arguments

- dat:

  Data frame with columns `bin_height_above_sea_floor` (a factor),
  `summary_col`, `min_col`, `max_col`, and optionally `shape_col`.

- summary_col:

  Column with the summary value (UNQUOTED). Default is
  `med_sea_water_speed_cm_s`.

- min_col:

  Column with the minimum values for the error bar (UNQUOTED). Default
  is `q_25`.

- max_col:

  Column with the maximum values for the error bar (UNQUOTED). Default
  is `q_75`.

- shape_col:

  Column to map onto shape (UNQUOTED). Optional.

- pal_col:

  Column to map to colour (UNQUOTED). Must be a factor.

- pal:

  Option colour palette.

- pal_label:

  Character string. Title for the colour legend.

- x_label:

  Character string. Title for the x-axis.

## Value

Returns a ggplot object.
