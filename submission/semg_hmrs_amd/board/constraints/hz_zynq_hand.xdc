# HZ-ZYNQ MV01 J4-5..10, carrier schematic 20250910 page1.
# Device balls cross-checked with xc7z020_clg400.pkg (vendor spreadsheet is shifted).
# User confirmed manufacturer accepts direct 3.3V servo PWM, 2026-10-24.
# Six outputs feed inverting optocouplers (user confirmed 2026-10-29).
# FPGA outputs idle HIGH; optocoupler servo-side outputs idle LOW.
set_property -dict {PACKAGE_PIN V7 IOSTANDARD LVCMOS33 DRIVE 8 SLEW SLOW} [get_ports {hand_pwm[0]}] ;# J4-5  B13_L11N, rotation
set_property -dict {PACKAGE_PIN U7 IOSTANDARD LVCMOS33 DRIVE 8 SLEW SLOW} [get_ports {hand_pwm[1]}] ;# J4-6  B13_L11P, thumb
set_property -dict {PACKAGE_PIN W8 IOSTANDARD LVCMOS33 DRIVE 8 SLEW SLOW} [get_ports {hand_pwm[2]}] ;# J4-7  B13_L15N, index
set_property -dict {PACKAGE_PIN V8 IOSTANDARD LVCMOS33 DRIVE 8 SLEW SLOW} [get_ports {hand_pwm[3]}] ;# J4-8  B13_L15P, middle
set_property -dict {PACKAGE_PIN U9 IOSTANDARD LVCMOS33 DRIVE 8 SLEW SLOW} [get_ports {hand_pwm[4]}] ;# J4-9  B13_L17P, ring
set_property -dict {PACKAGE_PIN U8 IOSTANDARD LVCMOS33 DRIVE 8 SLEW SLOW} [get_ports {hand_pwm[5]}] ;# J4-10 B13_L17N, little
# PWM is a self-timed output, not sampled by an external FPGA clock.
set_false_path -to [get_ports {hand_pwm[*]}]

