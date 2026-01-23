# Pivot flagged current data wider by variable

Pivot flagged current data wider by variable

## Usage

``` r
adcp_pivot_flags_wider(dat, qc_tests = NULL)
```

## Arguments

- dat:

  Data frame of flagged current data in long format.

- qc_tests:

  Quality control tests included in `dat_wide`. Default is
  `qc_tests = c("tidal_bin_height", "grossrange", "qc")`. Will also work
  for "rolling_sd" and "spike". If `dat` only includes the max flag, use
  `qc_tests = "qc"`.

## Value

Returns `dat`, with variables and flags pivoted to a wide format, i.e.,
one qc column for each variable and test EXCEPT tidal_bin_height_flag,
which applies to all variables.
