# Generate summary table of flags

Calculate the vector average for current speed and direction.

## Usage

``` r
adcp_calculate_vector_average(
  dat,
  ...,
  speed_col = sea_water_speed_cm_s,
  direction_degree_col = sea_water_to_direction_degree,
  return_components = FALSE
)
```

## Arguments

- dat:

  Data frame with columns for speed and direction and optional grouping
  arguments.

- ...:

  Optional argument. Column names (not quoted) from `dat` to use as
  grouping variables.

- speed_col:

  The column in `dat` that holds the speed data (NOT QUOTED).

- direction_degree_col:

  The column in `dat` that holds the direction data (NOT QUOTED). Must
  be in units of degrees from vertical.

- return_components:

  Logical argument. If `TRUE` the x and y vector components.

## Value

Returns data frame with the vector average speed and direction and
optionally the vector components. Returns scalar standard deviation of
speed.

## Details

Step 1: calculate components of each direction vector weighted by speed.

\$\$vx = speed \* sin(direction\_{degree} \* pi / 180)\$\$

\$\$vy = speed \* cos(direction\_{degree} \* pi / 180)\$\$

Step 2: Calculate average of each component.

\$\$vx\_{mean} = mean(vx)\$\$

\$\$vy\_{mean} = mean(vy)\$\$

Step 3: Calculate new vector based on the mean components.

\$\$direction\_{mean} = atan2(vx\_{mean}, vy\_{mean}) \* 180/pi\$\$

\$\$direction\_{mean} = (360 + direction\_{mean}) \\\\ 360\$\$

\$\$speed\_{mean} = sqrt(vy\_{mean}^2 + vx\_{mean}^2)\$\$
