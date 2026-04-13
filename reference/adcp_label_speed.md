# Assign intervals to speed data

Assigns intervals to `column` using the
[`cut()`](https://rdrr.io/r/base/cut.html) function. `column` will
typically be a `sea_water_speed` column. To label direction data, use
[`adcp_label_direction()`](https://dempsey-cmar.github.io/adcp/reference/adcp_label_direction.md).

## Usage

``` r
adcp_label_speed(
  dat,
  column = sea_water_speed_cm_s,
  n_ints = 12,
  upper_value = NULL,
  label_sep = " "
)
```

## Arguments

- dat:

  Data frame including the column with observations that will be
  assigned to intervals. The interval size is determined by the range of
  these observations and `n_ints`.

- column:

  Column in `dat` that will be assigned to intervals for frequency table
  (NOT QUOTED).

- n_ints:

  Number of intervals to divide observations into. The interval size is
  determined by the range of these observations and `n_ints`.
  Alternatively, a vector of two or more unique break points. Passed to
  the `breaks` argument of [`cut()`](https://rdrr.io/r/base/cut.html).

- upper_value:

  Value used to generate the upper limit of the final interval. Default
  is the maximum values of ` column `.

- label_sep:

  Separator for the interval labels ("lower to upper"). Default is a new
  line to save room on plot axis.

## Value

Returns `dat` with an additional column `column_labels`, the interval
labels as an ordered factor.

## Details

Intervals start and 0 and end at the smallest value that includes all
observations and results in `n_ints` equal intervals. Some small and/or
large intervals may have zero observations.
