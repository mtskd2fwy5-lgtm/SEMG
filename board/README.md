# 板卡接线与约束说明

目标器件为 `xc7z020clg400-2`，底板为 HZ-ZYNQ_MV01，核心板为 HZ-ZYNQ_CV01。本目录保存 ADS1299、RGB LCD、MPU、机械手与 HDMI 的引脚及相关时序约束。

## 约束文件用途

| 文件 | 用途 |
| --- | --- |
| [hz_zynq_ads1299_bd.xdc](constraints/hz_zynq_ads1299_bd.xdc) | 当前 `design_1` 系统工程的 ADS1299 引脚约束 |
| [hz_zynq_ads1299.xdc](constraints/hz_zynq_ads1299.xdc) | 独立 `hand_motion_top` 测试工程的时钟、按键与 ADS1299 约束 |
| [hz_zynq_lcd.xdc](constraints/hz_zynq_lcd.xdc)、[hz_zynq_lcd_timing.xdc](constraints/hz_zynq_lcd_timing.xdc) | RGB LCD 引脚与输出时序 |
| [hz_zynq_hand.xdc](constraints/hz_zynq_hand.xdc) | 六轴机械手 PWM 引脚与输出约束 |
| [hz_zynq_hdmi.xdc](constraints/hz_zynq_hdmi.xdc)、[hz_zynq_hdmi_timing.xdc](constraints/hz_zynq_hdmi_timing.xdc) | HDMI 引脚与输出时序 |
| [hz_zynq_clock_groups.xdc](constraints/hz_zynq_clock_groups.xdc)、[hz_zynq_imu_clock_groups.xdc](constraints/hz_zynq_imu_clock_groups.xdc) | 系统与 MPU 相关时钟域约束 |

当前系统顶层为块设计 `design_1`。独立测试顶层的端口和时钟不能直接套用到完整系统；实际启用的约束以工程脚本为准。

## ADS1299 接线

ADS1299 使用 J4 排针的 17–24 脚，占用 Bank 13，避开 Bank 34 的 LCD 总线。

| 信号 | FPGA 球位 | 底板位置 | 相对 FPGA 的方向 |
| --- | --- | --- | --- |
| `adc_drdy_n` | Y9 | J4-17 | 输入 |
| `adc_dout` | Y8 | J4-18 | 输入 |
| `adc_sclk` | W10 | J4-19 | 输出 |
| `adc_din` | W9 | J4-20 | 输出 |
| `adc_cs_n` | V11 | J4-21 | 输出 |
| `adc_start` | V10 | J4-22 | 输出 |
| `adc_reset_n` | Y13 | J4-23 | 输出 |
| `adc_pwdn_n` | Y12 | J4-24 | 输出 |

信号地可使用 J4-37/39。独立测试工程另使用 U18 的 25 MHz 时钟、K16 按键和 H15 状态灯；完整系统时钟由块设计配置。

上述约束以 Bank 13/34/35 保持默认 **3.3 V VCCO** 为前提。若按核心板文档改焊过供电选择，须重新核对电平。球位依据 Vivado 器件封装文件 `xc7z020_clg400.pkg` 核对；厂商引脚表存在行错位，不能单独据此确定球位。更换板卡时应重新检查原理图、连接器编号和电源，不能照搬其他 ADC 工程的约束。

## 机械手 PWM

J4-5–10 的轴顺序为掌部旋转、拇指、食指、中指、无名指、小指，均为 LVCMOS33。当前输出适配后级**反相光耦**：FPGA 空闲为高电平，有效脉冲为低电平，经光耦后恢复舵机所需的正脉冲。

舵机使用独立电源，信号地按光耦电路接线；不得与另一控制器的 PWM 输出并接。上电复位、标定与动作联动由固件流程管理，使用前须核对实际保存的标定值和映射。

## LCD 与 HDMI

LCD 承担显示和触摸输入，底板 J17 HDMI 镜像显示同一界面，固定视频输出为 1280×720、60 Hz。视频扫描频率不代表界面每秒重绘 60 次。HDMI 会增加与外部显示设备的电气连接，人体采集时须同时核对该链路的隔离条件。完整系统说明见[工程首页](../README.md)。
