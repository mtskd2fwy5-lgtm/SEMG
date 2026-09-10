# Pre-debug: halt the core BEFORE any IDE launch / bitstream programming.
# Prevents the "app polling PL DMA gets hung when PL is cleared during
# bitstream download" bus hang that forces a power cycle.
connect
targets -set -filter {name =~ "*Cortex-A9*#0"}
catch { stop }
after 300
puts "A9-0 NOW: [state]"
disconnect
exit
