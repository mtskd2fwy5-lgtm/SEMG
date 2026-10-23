# Final waveform and recording integrity, 2026-10-21

## Accepted signal contract

At the user's confirmation, the `--signal notch50` recorder option selects the
final **signed** waveform: 50 Hz/Q10 notch -> 50 Hz-spaced comb (1 Hz tooth
bandwidth, 80-sample delay) -> existing 20 Hz high-pass and approximately
215 Hz first-order low-pass, at 4000 samples/s per channel. No rectification or
envelope is applied to the waveform export. Raw remains the original ADC lane.

The shared final waveform feeds UART, SD and LCD (including the single-channel
FFT). The feature bank bypasses its former bandpass to avoid filtering twice.
The fatigue FFT retains its existing internal conditioning. The new chain does
not establish the classification accuracy of the existing deployed weights.

## Numeric correction

The prior integer bandpass could retain about -683 ADC counts on a zero-input
tail following the full-scale test. The final chain now saves the discarded
HP/LP fractions and feeds them back at the next sample. Saturation clears saved
error. Coefficients, sample rate, saturation limits and filter order are unchanged.
`FRACTION_SAVE=0` remains the default for historical standalone implementations;
only the final shared chain enables it. The Python reference mirrors both modes.

## Recording rollback correction

EMG005 contains a backwards event at row 359 (sequence 30566 -> 30055).
Its initial 359 complete raw/filtered frames repeat byte for byte beginning at
row 512. A waveform FIFO contains 4096 channel words, i.e. 512 complete frames.
SD startup reset DMA's AXI read side without resetting the PL write pointer,
allowing stale FIFO contents to be replayed.

SD startup and monitor/record switching now preserve the running DMA. A genuine
DMA or PL reset asserts reset for both FIFO ends and synchronizes release to
each local clock. All four lanes flush together. Acquisition/filter state is not
reset by a DMA flush. Samples lost during fault recovery cannot be reconstructed.
SD aborts on duplicate/backward complete frames with error 0x105. Decoders
distinguish normal wrap, forward loss, duplicate and backward events rather
than reporting a backwards step as 65024 lost frames. Half-range sequence
ambiguity remains explicit in metadata.

## Format and compatibility

- Final UART marker: AA58; raw: AA55. Legacy notch-only: AA56; combo-only: AA57.
- `--signal notch50` and `--signal processed` select current AA58. Older single
  notch firmware requires explicit `--signal legacy-notch50`.
- New SD header version 2, filter_code=3, unchanged 52-byte paired frame. The
  decoder also accepts old version 1 and version 2 filter codes 1/2.
- New decoded filenames are `*_raw.csv` and `*_processed.csv`, with signed int24
  samples, action, original sequence and source metadata.
- Filter ID: `notch50_q10_comb50_bw1_hp20_lp215_v1`. Bandpass ID explicitly
  identifies fraction saving. Historical filter IDs keep their old meanings.
- Training/export `--notch50` uses the final chain; already processed inputs do
  not pass through a second bandpass. Historical modes remain explicit.
- Backwards/duplicate metadata forces offline quality status BAD, and training
  rejects recordings with sequence discontinuities until continuous segments
  have been selected.

```powershell
python tools/record_uart.py --port COM16 --enter --signal notch50 --plot --keep-all --subject s30 --session e3
python tools/record_uart.py --port COM16 --enter --signal raw --save-both --plot --keep-all --subject s30 --session e4
python tools/decode_sd_record.py F:/EMG006.BIN --outdir report/emg006
```

`--save-both` derives a processed companion on the PC without doubling UART
traffic. It shares raw timestamps/labels but starts at zero state. The running
PL is generally warm before recording; initial transients and states following
lost samples therefore need not match the board. SD records both actual board
lanes directly. The decoder never changes existing input files.

## Verification evidence

- `run_data_path_sim.bat`: PASS, 174 backpressure checks and six unilateral
  reset/flush scenarios, including retained RAM and stopped source clock.
- `run_line_filter_sim.ps1`: PASS for notch + comb integer reference/response.
- `run_line_filter_sim.ps1 -Processed`: PASS for 802824 bit-exact channel beats,
  16 tones, DC offset, independent channels, full-scale/random/zero recovery,
  reset and sequence wrap. Independent SciPy response agreement within 0.2 dB;
  settled DC under 1 count; tested final zero tail residual 0 counts.
- Simulated gain: 40 Hz -0.634 dB, 60 Hz -0.699 dB, 75 Hz -0.580 dB,
  125 Hz -1.264 dB, 175 Hz -2.186 dB; 49/51 Hz about -9.84/-9.99 dB.
  Tested exact 50 Hz multiples through 450 Hz satisfy the >65 dB attenuation
  criterion. Values below numerical resolution in summary JSON are floor
  values, not physical measurements or a claim of infinite rejection.
- Full PL export + NN integration: PASS, 6400 raw and 6400 final words,
  200 feature words and five windows of INT8 logits/classes bit-exact.
- Python suite: PASS, 39 tests including no double bandpass, provenance,
  historical compatibility, markers, SD formats, gaps and replay quality flags.
- UART/SD C host tests: PASS, paired signed frames, wrap, preserved DMA on SD
  startup, duplicate/backwards abort and I/O error paths.
- LCD C host regression: PASS, both panel dimensions, signed waveform, controls,
  text baseline, settings and SD continuity.
- ARM firmware: build PASS; existing vendor FatFs unused-variable warning.
- Historical standalone bandpass: PASS, 9600 samples bit-exact with fraction
  saving disabled.

Logs are in this directory; numeric response is in
`sim/results_processed_filter/summary.json`. Firmware tag is
`20261021_LINE_FILTER_V1`.

## Full implementation

Full Vivado implementation and all five build gates PASS:

1. Six root coefficient parameters bind as the intended integers.
2. Synthesized coefficient register INIT values decode correctly.
3. Literal-B DSP scan: zero literal-B DSPs and no known corrupt values.
4. Routed timing meets the specified constraints: WNS +0.360 ns, WHS +0.042 ns,
   TNS/THS 0. Existing external-I/O coverage limits remain as noted below.
5. BOOT bitstream partition is a byte-exact word-reversed copy of the fresh
   generated bitstream payload.

`build/boot/BOOT.BIN` was generated at 2026-10-21 22:18:28 UTC+8 and contains
firmware tag `20261021_LINE_FILTER_V1`. Its SHA256 is
`cb354b839ee3990ead298fc185062e77089b472138c928b205ab60249b844456`.
The new image differs from the preserved previous BOOT. Artifact timestamps,
ELF/bitstream hashes and the previous hash are in `artifacts.json`.

Placed utilization: 36420 LUTs (68.46%), 32385 registers (30.44%), 29.5 BRAM tiles
(21.07%), 92 DSPs (41.82%). The routed report still reports LUT-driven async
reset alerts (2), missing external I/O delays, auto-derived-clock references
and control-set guidance. Timing PASS means the specified constraints pass;
it does not establish unprovided external-device timing margins. The FIFO
reset logic is covered by simulation; actual reset and sustained-capture
behavior still needs board verification. Reports are preserved alongside logs.

No board programming or SD overwrite has been performed.

## Limits

Comb teeth suppress real signal energy near their harmonic frequencies as well
as interference. The low-pass is gradual, not a hard cutoff. Strong overload
before the ADC cannot be repaired digitally. Filter transients after startup or
a raw-derived gap are expected (comb settling is on the order of 1-2 seconds).
All response/latency conclusions here are simulation evidence, not new board
measurements. Classification needs matching-filter retraining and evaluation;
the present changes do not certify the BIAS hardware.
