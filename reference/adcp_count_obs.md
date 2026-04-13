# Count number and proportion of observations in equal intervals

Count number and proportion of observations in equal intervals

## Usage

``` r
adcp_count_obs(
  dat,
  column = sea_water_speed_cm_s,
  n_ints = 12,
  n_digits = 4,
  label_sep = "\n",
  lowest = FALSE
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

- n_digits:

  Number of digits to show in interval labels. Note that additional
  digits may be used in the actual break values. See vignettes for more
  detail. Passed to the `dig.lab` argument of
  [`cut()`](https://rdrr.io/r/base/cut.html).

- label_sep:

  Separator for the interval labels ("lower to upper"). Default is a new
  line to save room on plot axis.

- lowest:

  Logical. If `TRUE`, the first interval will be left \*and\* right
  inclusive. Passed to the `include.lowest` argument of
  [`cut()`](https://rdrr.io/r/base/cut.html).

## Value

Returns a data frame of lower and upper interval limits (right
inclusive), and frequency and proportion of observations in each
interval.

## Details

Assigns intervals to `column` using the
[`cut()`](https://rdrr.io/r/base/cut.html) function. Argument
`right = TRUE` to match the intervals assigned in the
`openair::windRose()` function (which is called in
[`adcp_plot_current_rose()`](https://dempsey-cmar.github.io/adcp/reference/adcp_plot_current_rose.md)).
This means intervals are right-inclusive, i.e., a value of 4 is assigned
to the interval (1,4\].

NOTE: The `openair::windRose()` function has the
[`cut()`](https://rdrr.io/r/base/cut.html) argument `include.lower`
hard-coded to `FALSE`. This causes an issue with the intervals extracted
from `adcp_count_obs()` being passed to
[`adcp_plot_current_rose()`](https://dempsey-cmar.github.io/adcp/reference/adcp_plot_current_rose.md)
(which passes all arguments to `openair::windRose()`).

Assume the first interval is in the form (x1, x2\], and the minimum
value of the observations is xmin.

This means that if the round(x1, digits = n_digits) equals xmin, values
of xmin will NOT be assigned to an interval. In this case, xmin falls
outside of the first interval (because it is left exclusive). To avoid
this, n_digits should be large enough to ensure round(x1, digits =
n_digits) \< xmin. This could also be solved if `include.lower` could be
set to `TRUE` in `openair::windRose()`.

NOTE: I submitted a Pull Request to Open Air. I think it was merged. So
could update the include.lower call here, but will need to think about
this.
