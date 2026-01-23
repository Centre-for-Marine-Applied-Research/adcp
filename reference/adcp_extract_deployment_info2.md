# Extract deployment date and station name from compiled rds file

Extract deployment date and station name from compiled rds file

## Usage

``` r
adcp_extract_deployment_info2(file_path)
```

## Arguments

- file_path:

  Path to the file, include file name and extension (.rds). File name
  must include the deployment date, the station name, and the deployment
  id separated by "\_", e.g., "2020-10-22_Cornwallis_SW_AN002".

## Value

Returns a data frame with three columns: `depl_date`, `station`, and
`deployment_id`.
