# BEGIN V17 ATTITUDE CDC (append-only; retain existing FIFO clock groups)
# MPU FCLK1 (50 MHz) and FCLK0 (100 MHz) have no shared STA clock node.
# Sequence: double synchronization, then 3 stable clocks; the six-axis bus
# is held until the next 10 ms sample. Physical data transfer must be below
# 20 ns (settling window >40 ns); bus skew must be below 10 ns.
# These are bounded held-bus CDC paths, not synchronous FCLK paths.
set imu_meta [get_cells -hier -filter {NAME =~ mpu_attitude_0/inst/sequence_meta_reg*}]
set imu_bus [get_cells -hier -filter {NAME =~ mpu_attitude_0/inst/sensor_?_reg*}]
set imu_all [get_cells -hier -filter {NAME =~ mpu_attitude_0/inst/sequence_meta_reg* || NAME =~ mpu_attitude_0/inst/sensor_?_reg*}]
set imu_starts [get_cells -hier -filter {NAME =~ mpu6050_tilt_0/*/mpu_data_reg* || NAME =~ mpu6050_tilt_0/*/motion_?_reg*}]
set imu_data_starts [get_cells -hier -filter {NAME =~ mpu6050_tilt_0/*/motion_?_reg*}]
set_max_delay -datapath_only 20.0 -from $imu_starts -to $imu_all
set_bus_skew 10.0 -from $imu_data_starts -to $imu_bus
# END V17 ATTITUDE CDC
