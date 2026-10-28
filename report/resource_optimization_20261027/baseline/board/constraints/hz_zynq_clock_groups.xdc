# Cross-clock declaration for design_1. Implementation-only file.
#
# The PS FCLK (100 MHz; created as clk_fpga_0 by the PS7 IP constraints)
# and the PL board oscillator pl_clk (25 MHz) are asynchronous. All
# crossings go through the dual-clock FIFOs inside emg_data_path
# (gray-coded pointers with ASYNC_REG double synchronizers).
#
# This lives in its own file marked USED_IN_SYNTHESIS=false because the
# user XDCs are parsed before the PS7 IP constraints during synthesis,
# when clk_fpga_0 does not exist yet; in implementation the clock is
# present in the synthesized checkpoint and the groups apply cleanly.
set_clock_groups -asynchronous -group [get_clocks pl_clk] -group [get_clocks clk_fpga_0]
