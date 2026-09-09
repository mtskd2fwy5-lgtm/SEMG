# ADS1299 Command Verification

## Simulation

Run:

```text
build/scripts/run_ads1299_sim.bat
```

The testbench samples `adc_din` on every rising edge of `adc_sclk`, groups the bits into bytes while `CS` is low, and checks each transaction:

```text
transfer 0: 11
transfer 1: 41 0B 94 D0 EC 00 60 60 60 60 60 60 60 60
transfer 2: 10
transfer 3: 08
```

Meaning:

- `11`: `SDATAC`;
- `41 0B`: `WREG`, starting at `CONFIG1`, writing 12 registers;
- `94 D0 EC 00`: `CONFIG1`, `CONFIG2`, `CONFIG3`, `LOFF`;
- eight `60` bytes: `CH1SET` through `CH8SET`;
- `10`: `RDATAC`;
- `08`: `START`.

The same testbench then checks one 216-bit data frame and expects eight samples with channel indexes 0 through 7.

## ILA capture

Probe these signals in the first board test:

```text
adc_cs_n
adc_sclk
adc_din
adc_dout
adc_drdy_n
adc_reset_n
adc_start
adc_pwdn_n
frame_valid
sample_valid
sample_channel
sample_data
error
```

Trigger first on `adc_reset_n` rising, then on `adc_cs_n == 0`. Decode `adc_din` MSB first on the ADS1299 SPI sampling edge. Verify the four transactions above before enabling electrode input tests.

## Acceptance criteria

- Four initialization transactions are present in the expected order.
- The WREG transaction contains 14 bytes and remains under one CS assertion.
- `DRDY` produces one falling-edge event per conversion frame.
- `frame_valid` occurs after 24 status bits plus 8 x 24 channel bits.
- `sample_channel` cycles from 0 to 7 and then returns to the wait state.
