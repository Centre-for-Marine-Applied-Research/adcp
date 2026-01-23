#' Pivot flagged current data longer by variable
#'
#' @param dat Data frame of flagged current data in wide format.
#'
#' @param vars Vector of character strings indicating which columns to pivot.
#'   Default is all variables. Only required if variables in \code{dat} are in a
#'   wide format.
#'
#' @param qc_tests Quality control tests included in \code{dat_wide}. Default is
#'   \code{qc_tests = c("tidal_bin_height", "grossrange", "qc")}. Will also work for
#'   "rolling_sd" and "spike". If \code{dat_wide} only includes the max flag,
#'   use \code{qc_tests = "qc"}.
#'
#' @return Returns \code{dat_wide}, with variables and flags pivoted to a long
#'   format.
#'
#' @importFrom dplyr %>% any_of arrange filter relocate select
#' @importFrom tidyr pivot_longer
#'
#' @export

adcp_pivot_flags_longer <- function(dat, qc_tests = NULL, vars = NULL) {

  if (is.null(qc_tests)) {
    qc_tests <- c("tidal_bin_height", "grossrange", "qc")
  }
  if (is.null(vars)) {
    vars <- c("sensor_depth_below_surface_m", "sea_water_speed_m_s",
              "sea_water_to_direction_degree")
  }

  qc_tests <- tolower(qc_tests)

  if(!("variable" %in% colnames(dat))) {
    dat <- adcp_pivot_vars_longer(dat, vars = vars)
  }

  #tidal bin height test does not depend on the variable, so do not need to pivot
  if ("tidal_bin_height" %in% qc_tests) {
    dat <- dat %>%
      relocate(
        tidal_bin_height_flag_value = tidal_bin_height_flag, .after = last_col()
      )
  }

  # pivot the flags indicated
  if ("grossrange" %in% qc_tests) {
    dat <- adcp_pivot_single_test_longer(dat, qc_test = "grossrange")
  }

  if ("human_in_loop" %in% qc_tests) {
    dat <- adcp_pivot_single_test_longer(dat, qc_test = "human_in_loop")
  }


  if ("rolling_sd" %in% qc_tests) {
    dat <- adcp_pivot_single_test_longer(dat, qc_test = "rolling_sd")
  }

  if ("spike" %in% qc_tests) {
    dat <- adcp_pivot_single_test_longer(dat, qc_test = "spike")
  }

  if ("qc" %in% qc_tests) {
    dat <- adcp_pivot_single_test_longer(dat, qc_test = "qc")
  }

  # don't arrange by deployment_range (because it will be alphabetical not chronological)
  dat #%>%
   # arrange(county, station, deployment_id, variable, timestamp_utc)
}


#' Complete pivot_longer of flagged current data
#'
#' @param dat_wide Data frame of flagged current data with the variables
#'   in a long format and flags in wide format.
#'
#' @param qc_test Flag columns to pivot.
#'
#' @return Returns \code{dat_wide} with the qc_test flag columns pivoted to a
#'   long format.
#'
#' @importFrom dplyr %>% contains filter select
#' @importFrom rlang sym
#' @importFrom tidyr pivot_longer
#'
#' @export


adcp_pivot_single_test_longer <- function(dat_wide, qc_test) {

  col_name <- paste0(qc_test, "_flag_variable")

   dat_wide %>%
    pivot_longer(
      cols = contains(qc_test),
      names_to = paste0(qc_test, "_flag_variable"),
      names_prefix = paste0(qc_test, "_flag_"),
      values_to = paste0(qc_test, "_flag_value"),
      values_drop_na = TRUE
    ) %>%
    filter(`variable` == !!sym(col_name)) %>%
    select(-!!sym(col_name))
}
