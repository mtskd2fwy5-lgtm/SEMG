# PL to PS Data Path

## Current structure

```text
raw producer
    -> raw async FIFO
ADS1299 samples -> shared 50 Hz notch
    -> notch async FIFO (full-rate waveform export)
    -> existing bandpass/features/NN and fatigue processing
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

The four producer inputs run in `pl_clk` (25 MHz on this board); the merged AXI-Stream runs in `axis_clk` (PS FCLK0, 100 MHz). The current RTL modules are:

- `src/rtl/axis_async_fifo.v`
- `src/rtl/axis_packet_mux.v`
- `src/rtl/emg_data_path.v`
- `src/rtl/emg_pl_export.v`
- `src/rtl/emg_notch50.v`
- `src/rtl/emg_comb50.v`
- `src/rtl/emg_line_filter.v`

Raw and notch each use a 4096-entry, 64-bit asynchronous FIFO (12-bit
addresses): 128 ms at 32000 words/s per lane. Feature/result retain 64 entries.
The existing asynchronous-read FIFO infers distributed LUTRAM, not BRAM; the
isolated synthesis shows 4548 total LUTs per waveform FIFO. The round-robin
mux holds its selected source through backpressure to keep AXI data stable.

## 64-bit packet format

```text
63:60  packet type: 1 raw, 2 feature, 3 result (NN), 4 fatigue/spectrum, 5 processed waveform
59:56  channel
55:52  feature/result id (0 for either waveform)
51:48  reserved
47:32  sequence number
31:0   payload
```

Raw/processed payload uses the low 24 bits as a signed sample. The upper payload
byte is zero; the PS explicitly sign-extends bit 23. Feature/result payloads
are 32-bit. The final filter locks the original sample channel and sequence at its
input, so delayed channel 7 retains the same sequence as channels 0..6.

Result-lane packets share one FIFO and one AXI lane: type 3 carries the
INT8 MLP words (ids 0..4 logits, 5 argmax class); type 4 carries the
fatigue and spectrum words. id 8 is
`[num2[15:0] | mdf_mean[15:0]]`, id 9 is
`[level[1:0] | full | energy[22:0]]`, ids 10..14 carry five packed groups of
six 5-bit logarithmic powers (30 uniform bands spanning 20-450 Hz), and id
15 is `[peak_bin[10:0] | peak_power[20:0]]`. Each group uses payload bits
`[29:0]`, with band `j` at `5*j +: 5`; the LCD draws the 30 levels against a
fixed 0..31 logarithmic scale, so a bar reaches the top only when the source
level is actually 31. The logarithmic level is derived from the highest set bit of the
51-bit accumulated power, so the packet stays within the existing 32-bit
result payload.
The type is derived in `emg_data_path.v` from `result_id[3]` (ids 8..15 ->
type 4).

## AXI DMA connection

Connect:

```text
emg_pl_export.m_axis_tdata  -> AXI DMA S_AXIS_S2MM tdata
emg_pl_export.m_axis_tvalid -> AXI DMA S_AXIS_S2MM tvalid
emg_pl_export.m_axis_tready <- AXI DMA S_AXIS_S2MM tready
emg_pl_export.m_axis_tlast  -> AXI DMA S_AXIS_S2MM tlast
```

Use an AXI-Stream data width of 64 bits and a PS/AXI clock domain for the DMA side. The mux asserts `tlast` every `PACKET_WORDS` accepted words; the current default is 1024 words. The PS direct-register DMA therefore arms `1024 * 8 = 8192` bytes per ping-pong buffer. This stays below the configured AXI DMA 14-bit BTT limit.

## Overflow behavior

`raw_overflow` at the BD boundary combines raw FIFO overflow, notch FIFO
overflow and notch input overrun, retaining the external port interface.
`feature_overflow` and `result_overflow` remain sticky FIFO overflow flags.
Reset clears them. The PS monitor counts raw/feature sequence gaps and drops
partial feature windows after an ordering error. Record mode assembles only
one complete, same-sequence group of eight channels; it resets a partial
group on a new sequence or a source change.

The PS application is standalone in steady state: the LCD renderer consumes
the accepted class and fatigue state directly, while UART output is muted by
default. UART remains an optional bring-up/data-capture interface (`d` for
debug text, `f` for feature rows, `r` for the 2 Mbaud record mode).

## Recording source and throughput

`n` selects the final PL waveform (type 5, UART `AA 58`); `u` selects original ADC
(type 1, `AA 55`). Selection works at either baud rate. Each UART frame is
28 bytes: marker, uint16 LE sequence, eight int24 LE samples. Exactly one
waveform source goes to UART: 112000 bytes/s, 1.12 Mbit/s at 8N1, within
2 Mbaud. Recognition/LCD use 50 Hz notch + 50 Hz-spaced comb (1 Hz tooth width)
+ 20 Hz HP / 215 Hz LP. The signed final waveform goes to features without a
second bandpass; selecting raw changes only the recording source. Historical
firmware markers AA56 (notch only) and AA57 (notch + comb) are decoded separately.

Both waveform lanes still cross DMA. At default rates: 32000 raw + 32000
processed + 1600 feature + 240 NN + 16 fatigue/spectrum = 65856 words/s,
or 526848 bytes/s. The spectrum addition is only 12 words/s and does not
change the 1024-word DMA batch or the UART waveform rate.
The nominal 1024-word batch interval is 15.552 ms. Board-level CPU/LCD
load, backpressure and sustained serial reliability still require capture.
