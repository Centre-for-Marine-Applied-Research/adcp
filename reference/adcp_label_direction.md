# Cut wind direction into 8 bins

Adapted from `cutVecWinddir()` from `OpenAir`.

## Usage

``` r
adcp_label_direction(dat, n_petals = 16)
```

## Arguments

- dat:

  Data frame with column sea_water_to_direction_degree.

- n_petals:

  Number of bins to divide direction data into. Must be either 8 or 16.

## Value

Returns `dat` with an additional column
`sea_water_to_direction_degree_labels`, the direction labels as an
ordered factor.

## Details

Likely more efficient in the original vectorized form. Modified to match
[`adcp_label_speed()`](https://dempsey-cmar.github.io/adcp/reference/adcp_label_speed.md).
Could re-visit both.

If `n_petals` is 8: Assigns direction data in bins of 45 degrees. -22.5
to 22.5 degree is North, 22.5 to 67.5 is NE, etc.

If `n_petals` is 16 (the default): Assigns direction data in bins of
22.5 degrees. -11.25 to 11.25 degree is North, 11.25 to 33.75 is NNE,
etc.
