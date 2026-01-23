#' Apply human in the loop flags and comments
#'
#' Only deployments that require additional human-in-loop QC will have non-NA
#' values in the human-in-loop columns. Observations in these deployments that
#' do not need additional QC will be assigned a \code{human_in_loop_flag_value}
#' of 1.
#'
#' There is only one column for comments, \code{hil_comment}. This is to reduce
#' the total number of columns in the wide data set. The trade off is that the
#' comment will appear to apply to all variables. To avoid confusion in this
#' situation, comments should be pre-pended with the variable they refer to,
#' e.g., "sea water speed outlier not flagged by grossrange test".
#'
#' @param dat Data frame of flagged adcp current data in wide format.
#'
#' @param human_in_loop_table Data table with information required to assign the
#'   human in the loop flags. Must include the following columns: station,
#'   depl_id, variable, timestamp_utc_min,	timestamp_utc_max, qc_test_column (qc
#'   flag column that is being upgraded), qc_flag_value (existing flag value for
#'   qc_test_column), human_in_loop_flag_value, and human_in_loop_comment (will
#'   be included in the dataset).
#'
#' @param qc_tests Character vector of quality control tests that have been
#'   applied to \code{dat}. Passed to \code{qc_pivot_longer()}. Default is:
#'   \code{qc_tests = c("bin_height", "grossrange")}.
#'
#' @return Returns \code{dat} with a \code{human_in_loop_flag} column for each
#'   variable and a corresponding \code{hil_comment} column.

#' @export

adcp_test_human_in_loop <- function(
    dat,
    human_in_loop_table = NULL,
    qc_tests = c("tidal_bin_height", "grossrange")
) {

  # check dat is in wide format

  if(nrow(human_in_loop_table) == 0) {
    message(
      paste(
        "no human in the loop flags to apply for <<",
        unique(dat$station),
        unique(dat$depl_date), ">>"
      ))
  } else {

    message("applying human in the loop flags")

    for(i in seq_along(1:nrow(human_in_loop_table))) {

      human_in_loop_table_i <- human_in_loop_table[i, ]

      if(i > 1 && !("human_in_loop" %in% qc_tests)) {
        qc_tests = c(qc_tests, "human_in_loop")
      }

      dat_i <- adcp_apply_human_in_loop(
        dat,
        human_in_loop_table = human_in_loop_table_i,
        qc_tests = qc_tests
      )

      dat <- dat_i
    }
  }

  dat
}

#' Apply human in the loop flags and comments
#'
#' @param dat Data frame of flagged sensor string data in wide format.
#'
#' @param human_in_loop_table One row of data table with information required to
#'   assign the human in the loop flags. Must include the following columns:
#'   station, depl_id, variable, timestamp_utc_min,	timestamp_utc_max,
#'   qc_test_column (qc flag column that is being upgraded), qc_flag_value
#'   (existing flag value for qc_test_column), human_in_loop_flag_value, and
#'   human_in_loop_comment (will be included in the dataset).
#'
#' @param qc_tests Character vector of quality control tests that have been
#'   applied to \code{dat}. Passed to \code{adcp_pivot_flags_longer()}. Default
#'   is: \code{qc_tests = c("bin_height", "grossrange")}.
#'
#' @return Returns \code{dat} with a \code{human_in_loop_flag} column for each
#'   variable and a \code{human_in_loop_comment} column.
#'
#' @importFrom dplyr contains distinct if_any if_else filter last_col left_join
#'   pull relocate rename select
#' @importFrom data.table between
#' @importFrom rlang :=
#' @importFrom tidyr pivot_wider


adcp_apply_human_in_loop <- function(
    dat,
    human_in_loop_table = NULL,
    qc_tests = c("tidal_bin_height", "grossrange")
) {

  # checks ------------------------------------------------------------------
  if(length(unique(dat$station)) > 1 ||
     length(unique(dat$deployment_id)) > 1) {
    stop("more than one deployment found in dat")
  }

  # extract info from human_in_loop_table -----------------------------------
  hil_station <- human_in_loop_table$station
  hil_depl <- human_in_loop_table$depl_id
  hil_var <- human_in_loop_table$variable
  hil_bin_height <- human_in_loop_table$bin_height
  hil_timestamp_min <- human_in_loop_table$timestamp_utc_min
  hil_timestamp_max <- human_in_loop_table$timestamp_utc_max
  hil_qc_test_ref_column <- human_in_loop_table$qc_test_column
  hil_ref_flag_value <- human_in_loop_table$qc_flag_value
  hil_flag_value <- human_in_loop_table$human_in_loop_flag_value
  hil_flag_comment <-	human_in_loop_table$human_in_loop_comment


  # pivot flags -------------------------------------------------------------

  # this needs to be above where human_in_loop_reference_flag_col is added,
  # or that col will also be pivoted (with an error)
  dat <- dat %>%
    adcp_pivot_flags_longer(qc_tests = qc_tests)

  #browser()

  # account for different input scenarios -----------------------------------
  if(is.na(hil_var)) {
    hil_var <- dat %>%
      distinct(variable) %>%
      # dplyr::select(-contains("flag")) %>%
      # adcp_pivot_vars_longer() %>%
      pull(variable)
  }

  if(is.na(hil_timestamp_min)) hil_timestamp_min <- min(dat$timestamp_utc)
  if(is.na(hil_timestamp_max)) hil_timestamp_max <- max(dat$timestamp_utc)

  # so that hil_qc_test_ref_column can be NA
  if(is.na(hil_qc_test_ref_column) & is.na(hil_ref_flag_value)) {
    dat <- dat %>% mutate(human_in_loop_reference_flag_col = 1)
  } else{
    dat <- dat %>%
      rename(human_in_loop_reference_flag_col = all_of(hil_qc_test_ref_column))
  }

  if(is.na(hil_ref_flag_value)) hil_ref_flag_value <- c(1, 2, 3, 4)

  # apply human in the loop flags -------------------------------------------

  # for instances where qc_test_human_in_loop() needs to be applied more than once
  # don't change to NA or there will be issues with qc_assign_max_flag()
  if(!("human_in_loop_flag_value" %in% colnames(dat))) {
    dat <- mutate(dat, human_in_loop_flag_value = 1)
  }

  if(!("hil_comment" %in% colnames(dat))) {
    dat <- mutate(dat, hil_comment = NA_character_)
  }

  dat_hil <- dat %>%
    mutate(
      human_in_loop_flag_value = as.numeric(human_in_loop_flag_value),
      human_in_loop_flag_value = if_else(
        (variable %in% hil_var &
           bin_height_above_sea_floor_m == hil_bin_height &
           between(timestamp_utc, hil_timestamp_min, hil_timestamp_max) &
           human_in_loop_reference_flag_col %in% hil_ref_flag_value),
        hil_flag_value,
        human_in_loop_flag_value
      ),
      human_in_loop_flag_value = ordered(human_in_loop_flag_value, levels = 1:4)
    )

  if(is.na(hil_qc_test_ref_column)) {
    dat_hil <- dat_hil %>% select(-human_in_loop_reference_flag_col)
  } else{
    dat_hil <- dat_hil %>%
      rename(
        "{hil_qc_test_ref_column}" := human_in_loop_reference_flag_col
      )
  }

  qc_tests <- c(qc_tests[which(!is.na(qc_tests))], "human_in_loop")

  dat_hil <- dat_hil %>%
    adcp_pivot_flags_wider(qc_tests = qc_tests)

  # add comments (these will be applied to ALL variables measured by a sensor)
  join_cols <- colnames(dat_hil)[which(colnames(dat_hil) != "hil_comment")]

  dat_comment <- dat_hil %>%
    filter(
      if_any(contains("human_in_loop"), function (x) x == hil_flag_value)
    ) %>%
    mutate(
      hil_comment = if_else(is.na(hil_comment), hil_flag_comment, hil_comment)
    )

  dat_hil %>%
    select(-hil_comment) %>%
    left_join(dat_comment, by = join_cols) %>%
    relocate(hil_comment, .after = last_col())

}
