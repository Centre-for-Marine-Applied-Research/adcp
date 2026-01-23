


utils::globalVariables(c(

  # adcp_read_txt
  "index",
  "variable",
  "Num",
  "V8",
  "V9",
  "Year",
  "Month",
  "Day",
  "Hour",
  "Min",
  "Sec",

  # adcp_trim_NA
  "TRIM",
  "NA_sum",
  "n_GROUP",
  ".",

  # adcp_flag_data
  "sensor_depth",

  # adcp_correct_timestamp
  # "TIMESTAMP",
  "timestamp_ns",
  "timestamp_utc",

  # wv_pivot_longer
  "timestamp_foo",
  "WaterDirection",
  "WaterSpeed",
  "sensor_depth_below_surface_m",
  "sea_water_speed_m_s",
  "sea_water_to_direction_degree",
  "bin_height_above_sea_floor_m",
  "bin_depth_below_surface_m",
  "bin_id",
  "value",
  "BIN_DEPTH_CHECK",

  # adcp_plot_depth_flags
  "depth_diff",

  # write_report_table
  "bin_size_m",
  "current_averaging_interval_s",
  "current_ensemble_interval_s",
  "current_pings_per_ensemble",
  "depl_duration",
  "deployment_date",
  "deployment_sounding_m",
  "first_bin_range_m",
  "latitude",
  "longitude",
  "retrieval_date",
  "sensor_model",

  # export_deployment_info
  "depl_date",
  "station",

  # write_report_table
  "Depth Sounding (m)",

  # format_report_table
  "col1",

  # bin_obs
  "lower",
  "upper",
  "ints_label",
  "Freq",
  "prop",

  # plot_speed_hist
  "n_percent",

  # plot_current_rose
  "SPEED",
  "n_prop",
  "sea_water_speed_cm_s_labels",
  "sea_water_to_direction_degree_labels",

  # plot_speed_at_bins
  "med_sea_water_speed_cm_s",
  "med_sea_water_speed_cm_s_labels",
  "q_25",
  "q_75",

  "sensor_height_above_sea_floor_m",

  # count_obs()
  "sea_water_speed_cm_s",

  # label_intervals
  "ints",
  "col_to_cut",

  # import current data
  # "Open_Data_Station",
  # "2022 Report (sidelobe trimmed)",
  # "Report_2022",

  # export_deployment_info
  "Depl_ID",
  "deployment_id",
  "county",
  "waterbody",

  "Waves_Averaging_Interval_s",
  "Waves_Ensemble_Interval_s",
  "Waves_PingsPerEnsemble",

  # bin height test
  "prop_obs",
  "tidal_bin_height_flag",
  "tidal_bin_height_flag_value",

  # grossrange test
  "gr_max",
  "gr_min",
  "grossrange_flag",
  "user_max",
  "user_min",
  "qc_test",

  # rolling sd test
  "n_sample",
  "n_sample_effective",
  "rolling_sd_flag",
  "rolling_sd_max",
  "sd_roll",

  # spike test
  "int_sample",
  "lag_value",
  "lead_value",
  "spike_flag",
  "spike_high",
  "spike_low",
  "spike_ref",
  "spike_value",

  # convert variable to title
  "variable_title",

  # start_end_obs_to_trim
  "trim_obs",
  "group",

  # assign max flag
  "col_name",
  "qc_col",

  # summarise flags
  "flag_value",
  "n_fl",
  "n_obs",

  # extract_deployment_info_2
  "station_deployment_id",

  # human in loop
  "hil_comment",
  "human_in_loop_flag_value",
  "human_in_loop_reference_flag_col",
  "sensor_serial_number",

  # import_data
  "abb",
  "current_thresholds"

))
