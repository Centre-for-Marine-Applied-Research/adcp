#' Assign each observation the maximum flag from applied QC tests.
#'
#' @param dat Data frame in long or wide format with flag columns from multiple
#'   quality control tests.
#'
#' @param qc_tests Quality control tests included in \code{dat}. Default is
#'   \code{qc_tests = c("tidal_bin_height" ,"grossrange")}. Will also work for
#'   "rolling_sd" and "spike".
#'
#' @param return_all Logical value indicating whether to return all quality
#'   control flag columns or only the summary columns. If \code{TRUE}, all flag
#'   columns will be returned. If \code{FALSE}, only the summary columns will be
#'   returned. Default is \code{TRUE}.
#'
#' @return Returns \code{dat} in a wide format, with a single flag column for
#'   each variable column.
#'
#' @importFrom dplyr %>% all_of any_of contains everything left_join mutate pull
#'   rename select
#' @importFrom purrr pmap
#' @importFrom stringr str_remove_all
#' @importFrom tidyr pivot_wider
#'
#' @export

adcp_assign_max_flag <- function(dat, qc_tests = NULL, return_all = TRUE) {

  if(is.null(qc_tests)) {
    qc_tests = c("tidal_bin_height", "grossrange", "human_in_loop")
  }

  # save the original data frame to join the qc_flag columns
  if ("variable" %in% colnames(dat)) {
    dat_og <- dat %>%
      adcp_pivot_flags_wider(qc_tests = qc_tests)
  } else  dat_og <- dat

  # pivot dat
  if (!("variable" %in% colnames(dat))) {
    dat <- adcp_pivot_flags_longer(dat, qc_tests = qc_tests)
  }

  # use to join and sort the columns of the output
 # var_cols <- sort(unique(dat$variable))

  # use to join and sort the columns of the output
 # qc_max_cols <- paste("qc_flag", var_cols, sep = "_")

  # find the maximum flag for each variable
  dat <- dat %>%
    mutate(
      qc_col = pmap(select(dat, contains("flag")), max, na.rm = TRUE),
      qc_col = unlist(qc_col),
      qc_col = ordered(qc_col, levels = 1:4)
    ) %>%
    select(-contains("flag_value")) %>%
    rename(qc_flag_value = qc_col) %>%
    adcp_pivot_flags_wider(qc_tests = "qc")

  if(isTRUE(return_all)) {

    join_cols <- colnames(dat_og)[which(colnames(dat_og) %in% colnames(dat))]

    dat <- dat_og %>%
      left_join(dat, by = join_cols)
  }

  dat
}
