# Apply human in the loop flags and comments

Apply human in the loop flags and comments

## Usage

``` r
adcp_apply_human_in_loop(
  dat,
  human_in_loop_table = NULL,
  qc_tests = c("tidal_bin_height", "grossrange")
)
```

## Arguments

- dat:

  Data frame of flagged sensor string data in wide format.

- human_in_loop_table:

  One row of data table with information required to assign the human in
  the loop flags. Must include the following columns: station, depl_id,
  variable, timestamp_utc_min, timestamp_utc_max, qc_test_column (qc
  flag column that is being upgraded), qc_flag_value (existing flag
  value for qc_test_column), human_in_loop_flag_value, and
  human_in_loop_comment (will be included in the dataset).

- qc_tests:

  Character vector of quality control tests that have been applied to
  `dat`. Passed to
  [`adcp_pivot_flags_longer()`](https://dempsey-cmar.github.io/adcp/reference/adcp_pivot_flags_longer.md).
  Default is: `qc_tests = c("bin_height", "grossrange")`.

## Value

Returns `dat` with a `human_in_loop_flag` column for each variable and a
`human_in_loop_comment` column.
