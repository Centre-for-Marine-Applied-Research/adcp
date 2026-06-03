# Exploring Base R's cut() function

``` r

library(adcp)
library(dplyr)
library(gbRd)
```

This vignette explores the behavior of base R’s
[`cut()`](https://rdrr.io/r/base/cut.html) function, which is used to
calculate the intervals in
[`adcp_count_obs()`](https://dempsey-cmar.github.io/adcp/reference/adcp_count_obs.md).
These intervals are used in
[`adcp_plot_speed_hist()`](https://dempsey-cmar.github.io/adcp/reference/adcp_plot_speed_hist.md)
and can be passed to
[`adcp_plot_current_rose()`](https://dempsey-cmar.github.io/adcp/reference/adcp_plot_current_rose.md)
using the `breaks` argument.

## `cut()` function

First, let’s look at the help file for `cut`:

|     |                 |
|-----|----------------:|
| cut | R Documentation |

## Convert Numeric to Factor

### Description

`cut` divides the range of `x` into intervals and codes the values in
`x` according to which interval they fall. The leftmost interval
corresponds to level one, the next leftmost to level two and so on.

### Usage

``` R
cut(x, ...)

## Default S3 method:
cut(x, breaks, labels = NULL,
    include.lowest = FALSE, right = TRUE, dig.lab = 3,
    ordered_result = FALSE, ...)
```

### Arguments

|  |  |
|----|----|
| `x` | a numeric vector which is to be converted to a factor by cutting. |
| `breaks` | either a numeric vector of two or more unique cut points or a single number (greater than or equal to 2) giving the number of intervals into which `x` is to be cut. |
| `labels` | labels for the levels of the resulting category. By default, labels are constructed using `“(a,b]”` interval notation. If `labels = FALSE`, simple integer codes are returned instead of a factor. |
| `include.lowest` | logical, indicating if an ‘x\[i\]’ equal to the lowest (or highest, for `right = FALSE`) ‘breaks’ value should be included. |
| `right` | logical, indicating if the intervals should be closed on the right (and open on the left) or vice versa. |
| `dig.lab` | integer which is used when labels are not given. It determines the number of digits used in formatting the break numbers. |
| `ordered_result` | logical: should the result be an ordered factor? |
| `…` | further arguments passed to or from other methods. |

### Details

When `breaks` is specified as a single number, the range of the data is
divided into `breaks` pieces of equal length, and then the outer limits
are moved away by 0.1% of the range to ensure that the extreme values
both fall within the break intervals. (If `x` is a constant vector,
equal-length intervals are created, one of which includes the single
value.)

If a `labels` parameter is specified, its values are used to name the
factor levels. If none is specified, the factor level labels are
constructed as `“(b1, b2]”`, `“(b2, b3]”` etc. for `right = TRUE` and as
`“[b1, b2)”`, … if `right = FALSE`. In this case, `dig.lab` indicates
the minimum number of digits should be used in formatting the numbers
`b1`, `b2`, …. A larger value (up to 12) will be used if needed to
distinguish between any pair of endpoints: if this fails labels such as
`“Range3”` will be used. Formatting is done by `formatC`.

The default method will sort a numeric vector of `breaks`, but other
methods are not required to and `labels` will correspond to the
intervals after sorting.

As from **R** 3.2.0, `getOption(“OutDec”)` is consulted when labels are
constructed for `labels = NULL`.

### Value

A `factor` is returned, unless `labels = FALSE` which results in an
integer vector of level codes.

Values which fall outside the range of `breaks` are coded as `NA`, as
are `NaN` and `NA` values.

### Note

Instead of `table(cut(x, br))`, `hist(x, br, plot = FALSE)` is more
efficient and less memory hungry. Instead of `cut(*, labels = FALSE)`,
[`findInterval()`](https://rdrr.io/r/base/findInterval.html) is more
efficient.

### References

Becker RA, Chambers JM, Wilks AR (1988). *The New S Language*. Chapman
and Hall/CRC, London. ISBN 053409192X.

### See Also

`split` for splitting a variable according to a group factor; `factor`,
`tabulate`, `table`, `findInterval`.

`quantile` for ways of choosing breaks of roughly equal content (rather
than length).

`.bincode` for a bare-bones version.

### Examples

``` R
Z <- stats::rnorm(10000)
table(cut(Z, breaks = -6:6))
sum(table(cut(Z, breaks = -6:6, labels = FALSE)))
sum(graphics::hist(Z, breaks = -6:6, plot = FALSE)$counts)

cut(rep(1,5), 4) #-- dummy
tx0 <- c(9, 4, 6, 5, 3, 10, 5, 3, 5)
x <- rep(0:8, tx0)
stopifnot(table(x) == tx0)

table( cut(x, breaks = 8))
table( cut(x, breaks = 3*(-2:5)))
table( cut(x, breaks = 3*(-2:5), right = FALSE))

##--- some values OUTSIDE the breaks :
table(cx  <- cut(x, breaks = 2*(0:4)))
table(cxl <- cut(x, breaks = 2*(0:4), right = FALSE))
which(is.na(cx));  x[is.na(cx)]  #-- the first 9  values  0
which(is.na(cxl)); x[is.na(cxl)] #-- the last  5  values  8


## Label construction:
y <- stats::rnorm(100)
table(cut(y, breaks = pi/3*(-3:3)))
table(cut(y, breaks = pi/3*(-3:3), dig.lab = 4))

table(cut(y, breaks =  1*(-3:3), dig.lab = 4))
# extra digits don't "harm" here
table(cut(y, breaks =  1*(-3:3), right = FALSE))
#- the same, since no exact INT!

## sometimes the default dig.lab is not enough to be avoid confusion:
aaa <- c(1,2,3,4,5,2,3,4,5,6,7)
cut(aaa, 3)
cut(aaa, 3, dig.lab = 4, ordered_result = TRUE)

## one way to extract the breakpoints
labs <- levels(cut(aaa, 3))
cbind(lower = as.numeric( sub("\\((.+),.*", "\\1", labs) ),
      upper = as.numeric( sub("[^,]*,([^]]*)\\]", "\\1", labs) ))
```
