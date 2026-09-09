# PL to PS Checklist

- [ ] Use `emg_pl_export` as the PL export shell.
- [ ] Keep `pl_clk` and `axis_clk` as separate clock domains.
- [ ] Connect one 64-bit AXI-Stream to AXI DMA S2MM.
- [ ] Configure DMA for 64-bit stream data.
- [ ] Use an interrupt or polling loop to consume DDR buffers.
- [ ] Decode packet type from bits 63:60.
- [ ] Check sequence numbers for dropped packets.
- [ ] Check all three overflow flags.
- [ ] Start with a small test stream before enabling EMG processing.
