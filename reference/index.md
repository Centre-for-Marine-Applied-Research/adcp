# Package index

## All functions

- [`adcp_add_opendata_cols()`](https://dempsey-cmar.github.io/adcp/reference/adcp_add_opendata_cols.md)
  : Add deployment_id, waterbody, and station columns
- [`adcp_add_sensor_frequency()`](https://dempsey-cmar.github.io/adcp/reference/adcp_add_sensor_frequency.md)
  : Add column of ADCP frequency
- [`adcp_apply_human_in_loop()`](https://dempsey-cmar.github.io/adcp/reference/adcp_apply_human_in_loop.md)
  : Apply human in the loop flags and comments
- [`adcp_assign_altitude()`](https://dempsey-cmar.github.io/adcp/reference/adcp_assign_altitude.md)
  : Assign altitude (height above sea floor) to each bin
- [`adcp_assign_max_flag()`](https://dempsey-cmar.github.io/adcp/reference/adcp_assign_max_flag.md)
  : Assign each observation the maximum flag from applied QC tests.
- [`adcp_calculate_bin_depth()`](https://dempsey-cmar.github.io/adcp/reference/adcp_calculate_bin_depth.md)
  : Calculate the bin depth below the surface
- [`adcp_check_duplicate_timestamp()`](https://dempsey-cmar.github.io/adcp/reference/adcp_check_duplicate_timestamp.md)
  : Check for duplicate timestamp values
- [`adcp_check_new_folder()`](https://dempsey-cmar.github.io/adcp/reference/adcp_check_new_folder.md)
  : Check if there are files in the specified folder
- [`adcp_compile_deployment_info()`](https://dempsey-cmar.github.io/adcp/reference/adcp_compile_deployment_info.md)
  : Export ADCP Data Deployment Information Dataset
- [`adcp_convert_bin_height_to_ordered_factor()`](https://dempsey-cmar.github.io/adcp/reference/adcp_convert_bin_height_to_ordered_factor.md)
  : Convert bin_height_above_sea_floor_m column to ordered factor
- [`adcp_convert_vars_to_title()`](https://dempsey-cmar.github.io/adcp/reference/adcp_convert_vars_to_title.md)
  : Add a column of current variables in title case
- [`adcp_correct_timestamp()`](https://dempsey-cmar.github.io/adcp/reference/adcp_correct_timestamp.md)
  : Convert timestamp to UTC from AST or DST
- [`adcp_count_obs()`](https://dempsey-cmar.github.io/adcp/reference/adcp_count_obs.md)
  : Count number and proportion of observations in equal intervals
- [`adcp_extract_deployment_info()`](https://dempsey-cmar.github.io/adcp/reference/adcp_extract_deployment_info.md)
  : Extract deployment date and station name from file path
- [`adcp_extract_deployment_info2()`](https://dempsey-cmar.github.io/adcp/reference/adcp_extract_deployment_info2.md)
  : Extract deployment date and station name from compiled rds file
- [`adcp_format_report_table()`](https://dempsey-cmar.github.io/adcp/reference/adcp_format_report_table.md)
  : Formats tables for typst summary report
- [`adcp_ggplot_flags()`](https://dempsey-cmar.github.io/adcp/reference/adcp_ggplot_flags.md)
  : Create ggplot for one current qc_test and variable
- [`adcp_import_data()`](https://dempsey-cmar.github.io/adcp/reference/adcp_import_data.md)
  : Import current data from rds files.
- [`adcp_label_direction()`](https://dempsey-cmar.github.io/adcp/reference/adcp_label_direction.md)
  : Cut wind direction into 8 or 16 bins
- [`adcp_label_speed()`](https://dempsey-cmar.github.io/adcp/reference/adcp_label_speed.md)
  : Assign intervals to speed data
- [`adcp_pivot_bin_height()`](https://dempsey-cmar.github.io/adcp/reference/adcp_pivot_bin_height.md)
  : Pivot ADCP data from bin height as column names to bin height as
  observations
- [`adcp_pivot_flags_longer()`](https://dempsey-cmar.github.io/adcp/reference/adcp_pivot_flags_longer.md)
  : Pivot flagged current data longer by variable
- [`adcp_pivot_flags_wider()`](https://dempsey-cmar.github.io/adcp/reference/adcp_pivot_flags_wider.md)
  : Pivot flagged current data wider by variable
- [`adcp_pivot_single_test_longer()`](https://dempsey-cmar.github.io/adcp/reference/adcp_pivot_single_test_longer.md)
  : Complete pivot_longer of flagged current data
- [`adcp_pivot_vars_longer()`](https://dempsey-cmar.github.io/adcp/reference/adcp_pivot_vars_longer.md)
  : Pivot current data
- [`adcp_plot_current_rose()`](https://dempsey-cmar.github.io/adcp/reference/adcp_plot_current_rose.md)
  : Generate current rose
- [`adcp_plot_depth_flags()`](https://dempsey-cmar.github.io/adcp/reference/adcp_plot_depth_flags.md)
  : Plot sensor_depth_below_surface_m coloured by depth_flag
- [`adcp_plot_flags()`](https://dempsey-cmar.github.io/adcp/reference/adcp_plot_flags.md)
  : Plot current data coloured by flag value
- [`adcp_plot_speed_at_bins()`](https://dempsey-cmar.github.io/adcp/reference/adcp_plot_speed_at_bins.md)
  : Plot sea water speed through the water column
- [`adcp_plot_speed_hist()`](https://dempsey-cmar.github.io/adcp/reference/adcp_plot_speed_hist.md)
  : Plot histogram of speed observations
- [`adcp_plot_var_time()`](https://dempsey-cmar.github.io/adcp/reference/adcp_plot_var_time.md)
  : Plot histogram of speed observations
- [`adcp_read_tracking()`](https://dempsey-cmar.github.io/adcp/reference/adcp_read_tracking.md)
  : Read deployment details from CMAR tracking sheet
- [`adcp_read_txt()`](https://dempsey-cmar.github.io/adcp/reference/adcp_read_txt.md)
  : Read ADCP txt file
- [`adcp_start_end_obs_to_trim()`](https://dempsey-cmar.github.io/adcp/reference/adcp_start_end_obs_to_trim.md)
  : Flag observations that should be trimmed from beginning and end of
  deployment
- [`adcp_summarise_flags()`](https://dempsey-cmar.github.io/adcp/reference/adcp_summarise_flags.md)
  : Generate summary table of flags
- [`adcp_test_all()`](https://dempsey-cmar.github.io/adcp/reference/adcp_test_all.md)
  : Apply multiple quality control tests to current data
- [`adcp_test_grossrange()`](https://dempsey-cmar.github.io/adcp/reference/adcp_test_grossrange.md)
  : Apply grossrange test to current variables
- [`adcp_test_human_in_loop()`](https://dempsey-cmar.github.io/adcp/reference/adcp_test_human_in_loop.md)
  : Apply human in the loop flags and comments
- [`adcp_test_rolling_sd()`](https://dempsey-cmar.github.io/adcp/reference/adcp_test_rolling_sd.md)
  : Apply the rolling standard deviation test to current variables
- [`adcp_test_spike()`](https://dempsey-cmar.github.io/adcp/reference/adcp_test_spike.md)
  : Apply the spike test to current parameters
- [`adcp_test_tidal_bin_height()`](https://dempsey-cmar.github.io/adcp/reference/adcp_test_tidal_bin_height.md)
  : Apply tidal bin height test to adcp data
- [`adcp_theme()`](https://dempsey-cmar.github.io/adcp/reference/adcp_theme.md)
  : Theme for adcp plots
- [`adcp_write_report_table()`](https://dempsey-cmar.github.io/adcp/reference/adcp_write_report_table.md)
  : Writes deployment table for summary report
- [`current_thresholds`](https://dempsey-cmar.github.io/adcp/reference/current_thresholds.md)
  : Threshold tables
- [`find_index()`](https://dempsey-cmar.github.io/adcp/reference/find_index.md)
  : Index of first bin column
- [`get_speed_colour_pal()`](https://dempsey-cmar.github.io/adcp/reference/get_speed_colour_pal.md)
  : Generate colour palette for speed values
