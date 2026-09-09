# Board Integration

Target device: `XC7Z020-2CLG400-2`.

This directory contains the verified ADS1299 carrier-board connection information. Add the following only after checking the actual schematic or board manual:

- `constraints/<board_revision>.xdc`: clock, reset, SPI, DRDY, START, RESET, PWDN and UART pins;
- `board_revision.md`: board revision, power rails and connector mapping;
- `bringup_log.md`: measured voltages, SPI waveforms and sample-rate results.

Do not copy pin assignments from an unrelated AD9434, ADS8698 or Zynq project. The existing projects in the workspace use different ADCs and cannot establish the ADS1299 pin map.

The current ADS1299 XDC uses the verified `XC7Z020-2CLG400I` package mapping:

```text
clk         U18  PL_CLK / B34_L12P / 25 MHz
adc_sclk    P18  B34_L23N
adc_din     N17  B34_L23P
adc_cs_n    V20  B34_L16P
adc_reset_n W20  B34_L16N
adc_start   R16  B34_L19P
adc_pwdn_n  R17  B34_L19N
adc_dout    W18  B34_L22P
adc_drdy_n  W19  B34_L22N
rst_n       K16  PL_KEY1 / B35_L24P
status_led  H15  PL_LED0 / B35_L19P
```

The mapping assumes the ADS1299 board is wired to the corresponding ZYNQ-DIP expansion signals and the B34/B35 bank-voltage selection is 3.3 V. The physical top level is `hand_motion_top`, and the XDC is `constraints/hz_zynq_ads1299.xdc`.
