#' Pivot flagged current data wider by variable
#'
#' @param dat Data frame of flagged current data in long format.
#'
#' @param qc_tests Quality control tests included in \code{dat_wide}. Default is
#'   \code{qc_tests = c("tidal_bin_height", "grossrange", "qc")}. Will also work
#'   for "rolling_sd" and "spike". If \code{dat} only includes the max flag, use
#'   \code{qc_tests = "qc"}.
#'
#' @return Returns \code{dat}, with variables and flags pivoted to a wide
#'   format, i.e., one qc column for each variable and test EXCEPT
#'   tidal_bin_height_flag, which applies to all variables.
#'
#' @importFrom dplyr %>% any_of arrange filter relocate select
#' @importFrom tidyr pivot_wider
#'
#' @export

adcp_pivot_flags_wider <- function(dat, qc_tests = NULL) {

  if (is.null(qc_tests)) {
    qc_tests <- c("grossrange", "human_in_loop", "qc")
  }
  qc_tests <- tolower(qc_tests)

  # this test should not be pivoted
  if("tidal_bin_height" %in% qc_tests) {
    qc_tests <- qc_tests[-which(qc_tests == "tidal_bin_height")]
  }
  qc_tests <- paste0(qc_tests, "_flag_value")

  # if("tidal_bin_height_flag_value" %in% colnames(dat)) {
  #   dat_og <- dat
  #
  #   dat <- dat %>% select(-tidal_bin_height_flag_value)
  # }

  dat <- dat %>%
    pivot_wider(
      names_from = variable,
      values_from = c(value, all_of(qc_tests))
    )
  colnames(dat) <- str_remove_all(colnames(dat), pattern = "value_")

  if("tidal_bin_height_flag_value" %in% colnames(dat)) {
    dat <- dat %>%
      relocate(tidal_bin_height_flag = tidal_bin_height_flag_value, .after = last_col())
  }


  dat
}




