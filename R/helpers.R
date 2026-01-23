#' Index of first bin column
#'
#' @param dat_wide Data frame of ADCP data, as exported from
#'   \code{adcp_read_txt()}.
#'
#' @return Returns the index of the first column with bin data.
#'
#' @importFrom stringr str_match str_remove
#' @importFrom stats na.omit
#'
#' @export

find_index <- function(dat_wide) {

  # so can use with output directly from adcp_read_text()
  colnames_numeric <- str_match(colnames(dat_wide), "V\\d*$") %>%
    str_remove("V")

  if (length(na.omit(colnames_numeric)) > 0) {
    col_start <- which(
      colnames_numeric == min(as.numeric(colnames_numeric), na.rm = TRUE)
    )

    col_end <- which(
      colnames_numeric == max(as.numeric(colnames_numeric), na.rm = TRUE)
    )

    colnames(dat_wide)[col_start:col_end] <- colnames_numeric[col_start:col_end]
  }

  # index of the first measurement column
  suppressWarnings(
    which(colnames(dat_wide) == min(as.numeric(colnames(dat_wide)), na.rm = TRUE))
  )
}




#' Extract deployment date and station name from file path
#'
#' @param file_path Path to the file, include file name and extension (.csv or
#'   .txt). File name must include the deployment date and the station name, in
#'   the format YYYY-MM-DD_Station Name.ext (e.g., 2007-12-18_Spectacle
#'   Island.txt)
#'
#' @return Returns a tibble with three columns: \code{DEPLOYMENT},
#'   \code{Depl_Date}, and \code{Station_Name}.
#'
#' @importFrom dplyr mutate
#' @importFrom lubridate as_date
#' @importFrom stringi stri_locate
#' @importFrom stringr str_remove str_replace_all str_sub str_trim
#' @importFrom tidyr separate
#'
#' @export

adcp_extract_deployment_info <- function(file_path) {
  data.frame(file_path) %>%
    str_sub(stringi::stri_locate_last(file_path, regex = "/")[1] + 1) %>%
    str_remove(pattern = ".txt|.csv") %>%
    data.frame(deployment = .) %>%
    separate(
      col = 1, sep = 10, # separate after the date so will work for station names with more than one word
      into = c("depl_date", "station"), #, "Depl_ID"),
      remove = FALSE
    ) %>%
    mutate(
      station = str_replace_all(station, "_", " "),
      station = str_trim(station),
      depl_date = as_date(depl_date)
    )
}

#' Extract deployment date and station name from compiled rds file
#'
#' @param file_path Path to the file, include file name and extension (.rds).
#'   File name must include the deployment date, the station name, and the
#'   deployment id separated by "_", e.g., "2020-10-22_Cornwallis_SW_AN002".
#'
#' @return Returns a data frame with three columns: \code{depl_date},
#'   \code{station}, and \code{deployment_id}.
#'
#' @importFrom dplyr %>%  mutate
#' @importFrom lubridate as_date
#' @importFrom stringr str_remove str_replace_all str_trim
#' @importFrom tidyr separate
#'
#' @export

adcp_extract_deployment_info2 <- function(file_path) {
  sub(".*/", "", file_path, perl = TRUE) %>%
    data.frame() %>%
    separate(
      col = ".", into = c("depl_date", "station_deployment_id"), sep = 11
    ) %>%
    mutate(
      depl_date = str_remove(depl_date, pattern = "_"),
      station_deployment_id = str_remove(
        station_deployment_id, pattern = ".rds")
    ) %>%
    separate(
      col = "station_deployment_id",
      into = c("station", "deployment_id"), sep = -5
    ) %>%
    mutate(
      # replace first _ with space (for station names with 2 words)
      station = str_replace_all(station, pattern = "_", " "),
      # trim trailing space
      station = str_trim(station, side = "right"),
      deployment_id = str_remove(deployment_id, pattern = "_"),
    )
}




#' Check if there are files in the specified folder
#'
#' @param path Path to the folder to check.
#'
#' @param pattern Character string indicating what file type to check for.
#'
#' @returns Returns a Warning if there are files in the folder. Returns a
#'   message if not.
#'
#' @export

adcp_check_new_folder <- function(path, pattern = "csv") {

  dat_new <- list.files(path, pattern = "csv")

  if(length(dat_new) > 0) {
    warning(paste0("There are ", length(dat_new), " files in ", path,
                   ".\nMove these to the county folder to assemble"))
  } else {
    message("No files found in ", path)
  }
}



#' Add a column of current variables in title case
#'
#' @param dat Data frame of current data in long format. Flag columns will be
#'   dropped.
#'
#' @param convert_to_ordered_factor Logical variable indicating whether the new
#'   \code{variable_title} column should be converted to an ordered factor.
#'   Default is \code{TRUE}.
#'
#' @return Returns \code{dat} with an additional \code{variable_title} column
#'   for use in faceted figures.
#'
#' @importFrom dplyr case_when mutate
#' @importFrom stringr str_detect
#'
#' @export
#'

adcp_convert_vars_to_title <- function(dat, convert_to_ordered_factor = TRUE) {

  dat <- dat %>%
    mutate(
      variable_title = case_when(

        variable == "sensor_depth_below_surface_m" ~ "Sensor Depth Below Surface",
        variable == "sea_water_speed_m_s" ~ "Sea Water Speed",
        variable == "sea_water_to_direction_degree" ~
          "Direction Sea Water is Travelling To",

        TRUE ~ NA_character_
      )
    )

  if(isTRUE(convert_to_ordered_factor)) {
    dat <- dat %>%
      mutate(
        variable_title = ordered(
          variable_title,
          levels = c(
            "Sea Water Speed",
            "Direction Sea Water is Travelling To",
            "Sensor Depth Below Surface"))
      )
  }

  dat
}


#' Convert bin_height_above_sea_floor_m column to ordered factor
#'
#' Depths are assigned levels in descending order so that figures will have
#' shallowest bins at the top and deepest bins at the bottom of the figure.
#'
#' @param dat Data frame that includes the column
#'   \code{bin_height_above_sea_floor_m}.
#'
#' @returns Returns data with \code{bin_height_above_sea_floor_m} as an ordered
#'   factor.
#' @export

adcp_convert_bin_height_to_ordered_factor <- function(dat) {

  bin_heights <- sort(
    unique(dat$bin_height_above_sea_floor_m), decreasing = TRUE
  )

  dat %>%
    mutate(
      bin_height_above_sea_floor_m =
        ordered(bin_height_above_sea_floor_m, levels = bin_heights)
    )
}


#' Generate colour palette for speed values
#'
#' @param n_colours Integer indicating how many colours to generate.
#'
#' @returns Character vector of \code{n_levels} hex codes from \code{viridis}
#'   option "F".
#'
#' @export

get_speed_colour_pal <- function(n_colours) {

  viridis(n_colours, option = "F", direction = -1, end = 0.8)
}


#' Theme for adcp plots
#'
#' @returns Returns a ggtheme
#'
#' @importFrom ggplot2 element_line element_rect element_text theme
#'
#' @export


adcp_theme <- function() {

  theme_col_dark <- "gray50"
  theme_col_light <- "gray80"

  theme(
    axis.ticks.x = element_line(colour = theme_col_dark),
    axis.ticks.y = element_line(colour = theme_col_dark),

    panel.border =  element_rect(colour = theme_col_dark, fill = NA),
    panel.background = element_rect(fill = NA),
    panel.grid = element_line(color = theme_col_light, linewidth = 0.25),

    strip.text = element_text(colour = "black", size = 10),
    strip.background = element_rect(fill = "white", colour = theme_col_dark)
  )

}



