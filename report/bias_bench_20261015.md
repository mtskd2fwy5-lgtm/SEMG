# ADS1299 BIAS 配置与真实读回验证

本次从 2026-10-15 持续到 10-16，固件标识为 `20261015_BIAS_RREG_V1`。
交付目标是无人体条件下验证 BIAS 数字配置与原有采集链路。没有执行板卡烧录或人体测试。

## 配置与故障行为

原固件只写到 CH8SET，CONFIG3=EC 已开启 BIAS 放大器和内部中点参考，
但 BIAS_SENSP/N 仍为复位值 00。本次增加固定地址 0D/0E 的参数化写入，
默认 `BIAS_SENSP=01`、`BIAS_SENSN=01`，仅选 CH1 的 P/N 对称参与共模反馈。
选更多输入会改变外部 1 MΩ/1.5 nF 网络的环路增益，不能直接假定 FF/FF 更好。

启动顺序：硬复位 → SDATAC → WREG 01–0E → RREG 01–0E → 校验 → RDATAC → START。
14 个寄存器均核对；CONFIG3 的只读 BIAS_STAT 位不参与比较，实际字节仍完整导出。
4/6 通道型号的不存在通道槽写零，BIAS 地址保持 0D/0E，掩码只保留存在的通道。

任何配置读回不符均记录第一个错误地址，保持 CS 高、START 低，停止进入采集。
这表示不开始未验证的采集，不表示已经关闭模拟 BIAS 放大器。
按板载 PL_KEY0 可重放完整复位、写入、读回流程。没有无限自动重试。

采样率仍为 4 kSPS、CHnSET 仍为 40、内部测试信号仍关闭。
按 TI 增益编码，40 的 GAIN=100 是 **8 倍**；旧注释写成 4 倍已纠正，实际增益未改。
VREF=4.5 V 时理想差分满量程为 ±0.5625 V，同时还必须满足 PGA 共模范围。

## LCD 与串口

LCD 两个页面的顶部显示：`BIAS CFG WAIT`、`BIAS CFG OK` 或 `ADC CONFIG ERROR`。
OK 仅代表寄存器配置读回一致，不代表输出稳定、抑制效果或人体连接条件已验证。
上次单通道真实波形、RAW/NOTCH50、时间窗、量程、暂停、MPU/触摸功能保留。

监测模式使用 **115200、8N1**，发送小写 `b`，无需先开启 `d`：

```text
[ADC] fw=20261015_BIAS_RREG_V1 BIAS CFG OK
[ADC] done=1 ok=1 error=0 bad_addr=0x0
[ADC] actual CONFIG3=0xec BIAS_P=0x1 BIAS_N=0x1 word=0xc0ec0101
[ADC] expected CONFIG3&FE=EC P=01 N=01; CHn=40 gain=8 fs=4000
```

CONFIG3 也可能读出 ED；只读位变化不会误报配置错误。
`b` 在二进制录制模式下不输出文本，不污染数据流。
该命令显示启动或 PL_KEY0 重配时取得的快照，不是在不停转换时重新读取寄存器。

复用 `axi_gpio_1` 空闲第二通道，地址 `0x41210008`，原触摸通道地址保持 `0x41210000`。
读回字经过带应答的数据保持邮箱跨到 AXI 时钟域，软件再次做双读一致性检查。

| 位 | 含义 |
|---|---|
| 31 | 本次读回完成 |
| 30 | 校验通过 |
| 29 | 校验错误 |
| 28:24 | 首个不符的寄存器地址，成功时为 0 |
| 23:16 | 实际 CONFIG3 |
| 15:8 | 实际 BIAS_SENSP |
| 7:0 | 实际 BIAS_SENSN |

## 实现与验证记录

Vivado 2025.2 的旧 emg_pl_export module_ref 在 update_module_reference 返回空错误、
重建同名引用后仍暴露旧端口。增加薄适配层 `emg_pl_export_status`，内部完整复用原信号链，
重新绑定时恢复全部 14 个已有普通连接和 AXI-Stream 接口，滤波参数继续通过原五道构建检查。
没有可调用的 Vivado MCP，使用本地 Vivado/XSim 批处理；未更换器件或模拟器。

GPIO 配置已从安装目录 `axi_gpio_v2_0/component.xml` 核对第二通道使能、宽度、输入方向和偏移。
`bias_gpio_config_final_20261015.log` 记录参数读回、32 位输入/输出连接及触摸原连接检查通过。
之前两份配置日志和 module probe 保留失败诊断，不能当成功依据。

验证项目：

- `build/scripts/run_ads1299_sim.bat`：XSim 行为仿真；20 ms 看门狗，实际 11.51256 ms。
  8 次配置、3 帧正负及满量程数据；BIAS P/N、通道读回错误、DOUT 固定 0/1、按键恢复；
  同时检查 ADS1299-4/-6 固定地址与掩码。包含真实板级 SPI 频率、字节间解码和 CS 保持检查。
- `build/scripts/run_pl_export_sim.bat`：板上薄适配层到 AXI 流，1 s 看门狗，实际 183.54161 ms。
  800 帧，6400 个 RAW、6400 个 NOTCH50、200 个特征、30 个推理字逐字比对参考模型；
  邮箱 WAIT → ERROR（含实际坏字节）→ WAIT → OK 的重配恢复通过。
- `build/scripts/run_lcd_firmware_test.ps1`：真实固件的模拟 MMIO 渲染/输入回归，
  新状态解码与更新、双分辨率波形、帧缓冲所有权、触摸、MPU 与手腕方向通过。
- `build/scripts/run_uart_record_test.ps1`：两种录制源、24 位有符号数据、序号回绕、跨 DMA 和异常帧通过。
- `sw/ps_uart_print/build.bat`：ARM 裸机 ELF 构建通过。

完整综合与布局布线已完成，最终已约束路径的建立余量 WNS=+0.419 ns、
保持余量 WHS=+0.036 ns，TNS/THS=0，报告显示已满足用户指定时序约束。
顶层综合仍有原 LCD XDC 在综合阶段找不到子模块时钟的 4 条 critical warning；
布线后 methodology 仍有 36 条 warning：LUTAR-1×1、TIMING-18×28、TIMING-28×6、ULMTCS-1×1。
涉及已有 LCD 复位、I/O 延迟和时钟约束等，不将构建门通过解释为这些问题已消除。
完整构建于 2026-10-16 00:26 完成，五道构建门全部 PASS：参数类型/值、
网表系数解码、DSP 字面量、布线时序、BOOT 位流分区一致性。
BOOT 位流分区与本次 `.bit` 去掉 120 字节头后逐 32 位反转的完整内容一致；
两个含文件数据的 ELF PT_LOAD 段也均在 BOOT 中逐字匹配。
构建前后核对的四个产品源文件 SHA256 保持一致。

| 文件 | 字节数 | SHA256 |
|---|---:|---|
| `build/boot/BOOT.BIN` | 4263708 | `d88f93e3720e5b50475b79c54579976a74d21896d583bb25d13bd3994055250f` |
| `sw/ps_uart_print/ps_uart_print.elf` | 110604 | `58637270663679ff9653a9afc6e9d954670691ebfc7f476f75099b69621dfd98` |
| `build/vivado/hand_motion_reconstruction.runs/impl_1/design_1.bit` | 4045684 | `1eea61c40f30655b4c8ce1f2db5d5b5e4d64eb63f6f185a7a501e09feeef0f19` |

最终文件、源文件和验证日志清单见 [bias_artifacts_20261015.json](bias_artifacts_20261015.json)，
构建门日志见 [bias_build_gates_20261015.log](bias_build_gates_20261015.log)，
LCD 波形页状态预览见 [bias_lcd_preview_20261015.png](bias_lcd_preview_20261015.png)。
旧 `emg_pl_export_tb_gate.v` 是针对历史网表的诊断用例，不作为本次已通过的网表仿真。
本次未执行形式验证、SDF 时序仿真、板上验证或模拟闭环稳定性测量。

## 下一步离体检查

1. 断电更换配套启动镜像；当前先保持全部人体电极取下。
2. 上电观察 `BIAS CFG OK`，监测串口发 `b` 保存实际 CONFIG3/P/N 和错误地址。
   若报错，先排查 SPI/供电/复位，再用 PL_KEY0 重配；不要以软件预期值代替读回。
3. 沿用已跑通的限幅小信号注入和等效负载，LCD 进入 WAVE，切换 CH1–8、RAW/NOTCH50。
   检查 BIA 直流偏置、是否靠近电源轨、是否有振荡；共模抑制需在同条件负载下对照测量。
4. R3 已拆、R7=100 kΩ 为用户确认的当前状态。ATK-POHUB23 确为 USB 隔离产品，
   但现有资料未核实整套设备经 GPD-3303D 供电时的漏电/隔离与人体连接要求。
   后续电池独立 LCD 运行与 PC 采集需分别核查相应外接路径。

## 来源

- [TI ADS1299 数据手册 SBAS499C](https://www.ti.com/lit/ds/symlink/ads1299.pdf)：
  p33 共模反馈、p43 RREG/WREG、p48 CONFIG3、p50 增益、p51–52 BIAS 掩码、p63 应用电路。
- [正点原子 HUB23 官方资料页](http://www.openedv.com/docs/industry/6-other/HUB23.html)：
  产品确为 USB2.0 高速隔离器；“医疗设备”等应用介绍不能单独作为整机人体连接符合性的证明。
