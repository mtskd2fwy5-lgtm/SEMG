# ADS1299 command verification

Current configuration: `20261015_BIAS_RREG_V1`.

```text
RESET pulse and recovery wait
11                                      SDATAC
41 0D 92 C0 EC 00 40 40 40 40 40 40 40 40 01 01
21 0D [14 dummy DIN bytes; 14 actual register bytes on DOUT]
10                                      RDATAC (only if readback matches)
08                                      START
```

WREG and RREG each keep CS low for all 16 bytes. The 14 registers are addresses
01–0E: CONFIG1/2/3, LOFF, CH1–8SET, BIAS_SENSP/N. CONFIG3 comparison masks
only its read-only bit 0; all other bytes are checked in full. Masks are fixed
at addresses 0D/0E even on ADS1299-4/-6. CHnSET=40 means gain 8, normal input.

The controller sets DIN on rising SCLK, and the pin model captures DIN on
falling SCLK, matching the device. The model drives DOUT after rising SCLK
(including the 17th rising edge for RREG's first data MSB); the controller
samples DOUT on falling SCLK. Command/register bytes retain decode gaps and
CS hold time. Data frames remain 24 status bits followed by 8 × 24 sample bits.

Run `build/scripts/run_ads1299_sim.bat`. The shared pin-level ADC model stores
only bytes captured on DIN, and returns those stored registers through SPI.
The test independently checks normal-input configuration and channel masks;
it never feeds back DUT parameter values as a substitute for a register model.

Required terminal marker: `TEST_PASS ADS1299`. Compile/exit alone is insufficient.
The test has a 20 ms watchdog and uses board SPI timing with shortened reset waits.
It covers signed data, positive/negative full scale, replay, BIAS P/N and channel
corruption, stuck-low/high DOUT, failure hold/recovery, read-only status changes,
and fixed BIAS addressing/mask truncation for 4/6 channels.

Failure holds CS high and START low without entering RDATAC. The first bad
address and actual CONFIG3/P/N are exported. PL_KEY0 requests a complete replay.
The failure state does not imply that the analog BIAS amplifier is powered down.

`build/scripts/run_pl_export_sim.bat` checks the board adapter, coherent status
mailbox, all raw/notch/feature words and five inference results against independent
reference code. Status WAIT/error/recovery is also checked in the AXI clock domain.

For future board validation, capture CS/SCLK/DIN/DOUT/DRDY/RESET/START, verify
the five transactions, and compare monitor UART `b` with the captured RREG bytes.
No hardware capture was performed in this change.

See [the BIAS bench report](bias_bench_20261015.md) for artifacts and limitations.
