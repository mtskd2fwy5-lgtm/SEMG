# Board Integration

Target device: `XC7Z020-2CLG400-2`.

This directory contains the verified ADS1299 carrier-board connection information. Add the following only after checking the actual schematic or board manual:

- `constraints/<board_revision>.xdc`: clock, reset, SPI, DRDY, START, RESET, PWDN and UART pins;
- `board_revision.md`: board revision, power rails and connector mapping;
- `bringup_log.md`: measured voltages, SPI waveforms and sample-rate results.

Do not copy pin assignments from an unrelated AD9434, ADS8698 or Zynq project. The existing projects in the workspace use different ADCs and cannot establish the ADS1299 pin map.

The current ADS1299 XDC uses the verified `XC7Z020-2CLG400I` package mapping (moved to carrier header **J4 / bank 13** on 2026-09-21 so the bank-34 RGB LCD bus stays free for the onboard virtual-hand display):

```text
clk         U18  PL_CLK / B34_L12P / 25 MHz
adc_drdy_n  Y9   B13_L14P   J4-17 (input)
adc_dout    Y8   B13_L14N   J4-18 (input)
adc_sclk    W10  B13_L16P   J4-19
adc_din     W9   B13_L16N   J4-20
adc_cs_n    V11  B13_L21P   J4-21
adc_start   V10  B13_L21N   J4-22
adc_reset_n Y13  B13_L20N   J4-23
adc_pwdn_n  Y12  B13_L20P   J4-24
rst_n       K16  PL_KEY1 / B35_L24P
status_led  H15  PL_LED0 / B35_L19P
```

The mapping assumes the ADS1299 board is wired to carrier header J4 pins 17..24 (plus the nearest J4 GND, pins 37/39) and that banks B13/B34/B35 keep their default 3.3 V VCCO (the core-board doc "B13 B34 B35 changed to 1.8V operation guide" only applies after re-soldering L20/L21/L23). Ball numbers were verified against the Vivado package file `xc7z020_clg400.pkg`; the vendor pin-description xlsx has shifted rows and must not be used for ball mapping. The physical top level is `hand_motion_top`, and the XDC is `constraints/hz_zynq_ads1299.xdc`.


## 2026-10-24 机械手 PWM

新增 J4-5..10 六路 LVCMOS33 PWM，轴顺序为旋转、拇、食、中、无名、小指。
完整接线、电源、标定和验证边界见[接入记录](../report/hand_integration_20261024/README.md)。
默认无输出，不可与原 Arduino PWM 输出并接；马达电源独立、信号地共地。
