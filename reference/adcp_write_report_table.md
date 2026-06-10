# Writes deployment table for summary report

Writes deployment table for summary report

## Usage

``` r
adcp_write_report_table(metadata, keep_wave_cols = FALSE)
```

## Arguments

- metadata:

  Deployment metadata from the ADCP TRACKING sheet.

- keep_wave_cols:

  Logical argument. If `TRUE`, the wave ensemble interval, average
  interval, and pings per ensemble columns are included in the output.

## Value

Returns a data frame with columns for the report table.
