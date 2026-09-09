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
```

The three producer inputs run in `pl_clk`; the merged AXI-Stream runs in `axis_clk`. The current RTL modules are:

- `src/rtl/axis_async_fifo.v`
- `src/rtl/axis_packet_mux.v`
- `src/rtl/emg_data_path.v`
- `src/rtl/emg_pl_export.v`

## 64-bit packet format

```text
63:60  packet type: 1 raw, 2 feature, 3 result
59:56  reserved
55:52  channel or feature/result id
51:48  reserved
47:32  sequence number
31:0   payload
```

Raw payload uses the low 24 bits as a signed ADS1299 sample. Feature and result payloads use a 32-bit fixed-point value. All producers must keep sequence numbers so the PS can detect dropped or reordered packets.

## AXI DMA connection

Connect:

```text
emg_pl_export.m_axis_tdata  -> AXI DMA S_AXIS_S2MM tdata
emg_pl_export.m_axis_tvalid -> AXI DMA S_AXIS_S2MM tvalid
emg_pl_export.m_axis_tready <- AXI DMA S_AXIS_S2MM tready
emg_pl_export.m_axis_tlast  -> AXI DMA S_AXIS_S2MM tlast
```

Use an AXI-Stream data width of 64 bits and a PS/AXI clock domain for the DMA side. The mux asserts `tlast` every `PACKET_WORDS` accepted words; the default is 256 words. This avoids completing a DMA transfer after every 64-bit sample while keeping a bounded packet size.

## Overflow behavior

`raw_overflow`, `feature_overflow` and `result_overflow` latch when a producer presents valid data while its source FIFO is full. Clear these status bits only through a future AXI control register or a reset.
