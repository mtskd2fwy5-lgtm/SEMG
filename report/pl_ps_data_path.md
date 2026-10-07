# PL to PS Data Path

## Current structure

```text
raw producer
    -> raw async FIFO
feature producer
    -> feature async FIFO
result producer
    -> result async FIFO
    -> round-robin AXI-Stream mux
    -> AXI DMA S2MM
    -> DDR
    -> Zynq PS
    -> local RGB LCD/VDMA virtual hand
```

The three producer inputs run in `pl_clk`; the merged AXI-Stream runs in `axis_clk`. The current RTL modules are:

- `src/rtl/axis_async_fifo.v`
- `src/rtl/axis_packet_mux.v`
- `src/rtl/emg_data_path.v`
- `src/rtl/emg_pl_export.v`

## 64-bit packet format

```text
63:60  packet type: 1 raw, 2 feature, 3 result (NN), 4 fatigue
59:56  reserved
55:52  channel or feature/result id
51:48  reserved
47:32  sequence number
31:0   payload
```

Raw payload uses the low 24 bits as a signed ADS1299 sample. Feature and result payloads use a 32-bit fixed-point value. All producers must keep sequence numbers so the PS can detect dropped or reordered packets.

Result-lane packets share one FIFO and one AXI lane: type 3 carries the
INT8 MLP words (ids 0..4 logits, 5 argmax class); type 4 carries the
fatigue monitor words (id 8: `[num2[15:0] | mdf_mean[15:0]]`, id 9:
`[level[1:0] | full | energy[22:0]]`). The type is derived in
`emg_data_path.v` from `result_id[3]` (ids 8/9 -> type 4).

## AXI DMA connection

Connect:

```text
emg_pl_export.m_axis_tdata  -> AXI DMA S_AXIS_S2MM tdata
emg_pl_export.m_axis_tvalid -> AXI DMA S_AXIS_S2MM tvalid
emg_pl_export.m_axis_tready <- AXI DMA S_AXIS_S2MM tready
emg_pl_export.m_axis_tlast  -> AXI DMA S_AXIS_S2MM tlast
```

Use an AXI-Stream data width of 64 bits and a PS/AXI clock domain for the DMA side. The mux asserts `tlast` every `PACKET_WORDS` accepted words; the current default is 256 words. The PS direct-register DMA therefore arms `256 * 8 = 2048` bytes per ping-pong buffer. The batch length and `tlast` position must remain identical.

## Overflow behavior

`raw_overflow`, `feature_overflow` and `result_overflow` latch when a producer presents valid data while its source FIFO is full. The current PS monitor also counts raw and feature sequence gaps and discards partial feature windows after an ordering error. Clear the overflow status bits only through a future AXI control register or a reset.

The PS application is standalone in steady state: the LCD renderer consumes
the accepted class and fatigue state directly, while UART output is muted by
default. UART remains an optional bring-up/data-capture interface (`d` for
debug text, `f` for feature rows, `r` for the 2 Mbaud record mode).
