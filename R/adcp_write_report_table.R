#' Writes deployment table for summary report
#'
#' @param metadata Deployment metadata from the ADCP TRACKING sheet.
#'
#' @param keep_wave_cols Logical argument. If \code{TRUE}, the wave ensemble
#'   interval, average interval, and pings per ensemble columns are included in
#'   the output.
#'
#' @return Returns a data frame with columns for the report table.
#'
#' @importFrom dplyr if_else mutate select
#'
#' @export

adcp_write_report_table <- function(metadata, keep_wave_cols = FALSE) {

  dat <- metadata %>%
    mutate(
      depl_duration = as.numeric(
        difftime(retrieval_date, deployment_date, units = "days")
      )
    ) %>%
    select(
      Station = station,
      `Instrument Model` = sensor_model,
      Latitude = latitude, Longitude = longitude,
      `Deployment Date` = deployment_date, `Recovery Date` = retrieval_date,
      `Duration (d)` = depl_duration,
      `Depth Sounding (m)` = deployment_sounding_m,

      `Sensor Height above Sea Floor (m)` = sensor_height_above_sea_floor_m,
      `First Bin Range (m)` = first_bin_range_m,
      `Bin Size (m)` = bin_size_m,

      `Ensemble Interval (s)` = current_ensemble_interval_s,
      `Averaging Interval (s)` = current_averaging_interval_s,
      `Pings per Ensemble` = current_pings_per_ensemble,

      `Wave Ensemble Interval (s)` = wave_ensemble_interval_s,
      `Wave Averaging Interval (s)` = wave_averaging_interval_s,
      `Wave Pings per Ensemble` = wave_pings_per_ensemble
    ) %>%
    mutate(
      `Depth Sounding (m)` = as.character(`Depth Sounding (m)`),
      `Depth Sounding (m)` = if_else(
        is.na(`Depth Sounding (m)`), "Not recorded", `Depth Sounding (m)`
      )
    )

  if(isTRUE(keep_wave_cols)) {
    dat <- dat %>%
      rename(
        `Current Ensemble Interval (s)` = `Ensemble Interval (s)`,
        `Current Averaging Interval (s)` = `Averaging Interval (s)`,
        `Current Pings per Ensemble` = `Pings per Ensemble`
      )
  } else{
    dat <- dat %>% select(-contains("Wave"))
  }

  dat
}
