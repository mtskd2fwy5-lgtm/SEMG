# LCD source-synchronous timing. Implementation only, processed LATE:
# the MMCM and ODDR live behind OOC module boundaries during synthesis.
# Reference the actual DCLK pad so STA includes BUFG/BUFGMUX/ODDR delay.
# D1=0/D2=1 inverts the launching pixel clock. The panel samples on DCLK
# rising edges, half a pixel period after data launch.
# Vivado 2025.2 requires BOTH -add and -master_clock on each definition
# to distinguish the two master clocks propagated through the same pin.
create_generated_clock -name lcd_dclk50 -source [get_pins lcd_clk_fwd_0/inst/oddr_lcd_dclk/C] -master_clock c50_raw -divide_by 1 -invert -add [get_ports lcd_clk]
create_generated_clock -name lcd_dclk31 -source [get_pins lcd_clk_fwd_0/inst/oddr_lcd_dclk/C] -master_clock c31_raw -divide_by 1 -invert -add [get_ports lcd_clk]

# Panel selection is latched before releasing the video domain from reset.
set_clock_groups -name lcd_pixel_modes -logically_exclusive \
    -group [get_clocks {c31_raw lcd_dclk31}] \
    -group [get_clocks {c50_raw lcd_dclk50}]

# Preserve the existing engineering budget: 5 ns setup / 5 ns hold.
# Assumed budgets pending precise ATK panel/board timing specifications.
# DCLK is already inverted: reference its rising edge here.
set_output_delay -clock lcd_dclk50 -max 5.0 [get_ports {lcd_data[*] lcd_de lcd_hsync lcd_vsync}]
set_output_delay -clock lcd_dclk50 -min -5.0 [get_ports {lcd_data[*] lcd_de lcd_hsync lcd_vsync}]
set_output_delay -clock lcd_dclk31 -add_delay -max 5.0 [get_ports {lcd_data[*] lcd_de lcd_hsync lcd_vsync}]
set_output_delay -clock lcd_dclk31 -add_delay -min -5.0 [get_ports {lcd_data[*] lcd_de lcd_hsync lcd_vsync}]
