# 2026-10-15 PL 50 Hz 陷波实现与验证

用户要求识别、LCD 和录制波形都抑制 50 Hz。已在 ADS1299 后增加共享陷波，保留原始 ADC 支路。完整工程已生成位流、XSA 及配套 BOOT.BIN，现有五项构建门禁全部 PASS；尚未连接硬件串口或烧录。

## 数据链与数值定义

```text
ADS1299, 8ch × 4000 samples/s
  ├─ type 1 原始 ADC ─────────────────────→ DMA → 可选 raw 录制
  └─ emg_notch50 (每通道独立状态)
       ├─ type 5 陷波波形 ────────────────→ DMA → 默认 notch50 录制
       └─ 原抽取门控 → 原带通/特征/NN、疲劳 → DMA → PS 判决与 LCD
```

陷波为 50 Hz、Q＝10、fs＝4000 Hz 的二阶 IIR，版本 `notch50_q10_q24_v1`。系数为 Q24，内部反馈状态为 Q12 并增加 4 位整数保护，输出饱和到 int24。共享乘法器按样本运行 12 个时钟周期，输入时锁存通道和序号；忙时输入触发过速状态。此版本没有运行时旁路，选择 raw 仅切换录制源，不改变识别/LCD 链路。

两个波形 FIFO 各 4096×64，约容纳每路 128 ms；现有异步读结构推断为 LUTRAM。合流仲裁在 AXI 背压期间保持来源，避免新到达数据改变已呈现的数据。BD 外部接口保持一致，原 raw_overflow 输出合并两波形 FIFO 溢出和陷波过速。

## 已执行的验证

| 验证 | 结果与范围 |
| --- | --- |
| `run_notch50_sim.ps1` | XSim PASS，225792 个输出与整数参考逐值一致；覆盖通道独立、复位中断、过速、序号回绕及满量程恢复 |
| `run_pl_export_sim.bat` | 800 帧，6400 raw 保持不变、6400 notch、200 feature、5 窗 NN 结果与参考逐值一致；无溢出 |
| `run_data_path_sim.bat` | 四路 FIFO、字段、序号、TLAST、174 次背压稳定检查、溢出及复位 PASS |
| `run_uart_record_test.ps1` | 测试直接编译真实 main.c；两源帧头、负数、回绕、跨 DMA 半帧、混序号、切源、非法头、raw 诊断 PASS |
| `run_lcd_firmware_test.ps1` | 现有 LCD/IMU/腕屈伸回归 PASS；矩阵最大分量误差 0.002686 |
| Python unittest | 16 项串口/绘图、9 项训练预处理回归 PASS；不打开真实串口 |
| ARM build.bat | BUILD OK，`BUILD_TAG=20261015_NOTCH50_V1` |
| `check_notch50_synth.tcl` | 独立综合完整 emg_pl_export，0 errors、0 critical warnings；不包含 PS/LCD 顶层布局布线 |
| `add_notch50.tcl` | 新源已加入现有工程，BD 强制校验成功；保存前后 BD 文件内容一致 |

稳态单频数字仿真（不是实测抗干扰指标）：

| 频率 | 幅度增益 |
| --- | ---: |
| 49 Hz | −8.5286 dB |
| 50 Hz | −86.1947 dB |
| 51 Hz | −8.6763 dB |
| 40 Hz | −0.2094 dB |
| 60 Hz | −0.3114 dB |
| 100 Hz | −0.0192 dB |
| 215 Hz | −0.0026 dB |
| 450 Hz | −0.0005 dB |

仿真满量程冲击后恢复尾部最大 1 count。50 Hz 的深度依赖频率与定点误差，不能将约 86 dB 宣称为 49–51 Hz 整段抑制度，也不能据此推断实际肌电 SNR 或动作识别准确率。

## 隔离综合证据

目标 xc7z020clg400-2，采集时钟 25 MHz、AXI 时钟 100 MHz，按现有板级约束设为异步。综合估算 WNS＝+4.598 ns、WHS＝+0.157 ns；独立模块边界没有完整 I/O 延迟和顶层时钟树，不能代替布线后时序。

| 范围 | LUT（含 LUTRAM） | FF | RAMB36 | DSP |
| --- | ---: | ---: | ---: | ---: |
| emg_pl_export 全部 | 25579 | 19387 | 21 | 89 |
| 其中新增 notch 核 | 653 | 1236 | 0 | 4 |
| 每个波形 FIFO | 4548 | 344 | 0 | 0 |

原始日志与报告在 `sim/results_notch50*`；这些目录为可重新生成的产物。完整 BD 构建仍以 `build/build_all.ps1` 的门禁为准，旧 2026-10-01 的 85 DSP 和 WNS＝1.561 ns 属于历史版本。

## 完整工程构建与告警边界

`build/build_all.ps1` 本次完整执行并打印 `PIPELINE RESULT: ALL GATES PASS`：

- G1：6 个带通参数在 OOC 包装层按源码整数值绑定。
- G2：网表中八通道带通系数寄存器全部正确。
- G3：89 个 EMG DSP 无常量 B 端口、无已知错误系数字面量。
- G4：布线后 WNS＝+0.570 ns、WHS＝+0.031 ns，建立/保持总负裕量均为零。
- G5：BOOT.BIN 中位流分区与本次 design_1.bit 的翻字节序载荷逐字节相同。

完整版图资源为 LUT 32108（60.35%）、FF 30021（28.22%）、BRAM 27.5 tile（19.64%）、DSP 96（43.64%）；包含当前 LCD/MPU，不能与仅 EMG 的 89 DSP 混用。Slice 占用为 90.71%，不能仅根据 LUT 占用判断剩余布线余量。向量无关估算功耗 1.968 W、低置信度，不是板级实测。bus skew 四项最差裕量分别为 +8.881、+9.290、+9.139、+9.163 ns。

实现 DRC 为 0 errors，最终实现日志为 0 critical warnings，但整个流程仍有告警：顶层综合在 LCD 自动派生时钟尚不可见时，对 `hz_zynq_lcd.xdc:82` 报 4 条时钟组严重警告。最终布线报告确认 c31_raw/c50_raw 均存在，且已有两种像素时钟下的输出约束得到检查。布线 methodology 仍有 36 项 warning：LUTAR-1 复位网络 1 项、TIMING-18 LCD 输出相对父时钟缺失延迟 28 项、TIMING-28 按名称引用派生时钟 6 项、ULMTCS-1 控制集 1 项。本轮未改动这些原有 LCD 约束/复位问题，未增加 waiver；五项门禁通过不代表告警全部清零或 LCD 实机行为已经验证。

交付文件均在本地生成，未写入板卡或 SD 卡：

| 文件 | 字节数 | SHA-256 |
| --- | ---: | --- |
| `build/boot/BOOT.BIN` | 4254536 | `310e7a9e0296083e9c023de6f5f8e0e419f8f0f836eebbb1b3acbf4a60bfb928` |
| `build/vivado/hand_motion_reconstruction.runs/impl_1/design_1.bit` | 4045684 | `f145dfa7df40460097290d9adb8b9bc092614bcf7248bc26515968e806ff67a2` |
| `sw/ps_uart_print/ps_uart_print.elf` | 92748 | `acbc01b97ad8cb1b3c9dcd406cd201607d233e472be762af522cb8fdad107753` |

BOOT.BIN 内已检查包含 `20261015_NOTCH50_V1` 固件标识；构建结束时间为本机 2026-10-15 18:20:43。构建门禁摘录及机读校验见同目录的 `notch50_build_gates_20261015.log`、`notch50_artifacts_20261015.json`。

## 录制、查看与训练

配套新 PL/PS 部署后，监控波特率 115200，发 n/u 选择陷波/原始，发 r 切换 2 Mbaud 录制。帧头分别为 AA56/AA55，之后为 seq u16 LE 和八路 int24 LE，共 28 字节。每次只输出选中的一路，带宽 112000 B/s（8N1 约 1.12 Mbit/s）。DMA 仍承载两路波形及特征/结果；加入 30 段频谱和峰值摘要后预算为 65856 words/s，1024-word 批次约 15.552 ms。

```powershell
python tools/record_uart.py --port COM16 --enter --signal notch50 --plot --keep-all --subject s30 --session e3
python tools/plot_csv.py --latest
python tools/plot_csv.py --latest --raw --start 5 --duration 0.2
```

端口号需与实际一致。q 保存后仍在录制模式，下一次去掉 --enter；m 丢弃本次并回到监控。原始对照改用 --signal raw。`plot_csv.py --raw` 表示逐点显示，不改变文件来源。

CSV 保留所选支路的采样值，JSON 写入 signal、filter id、帧头及解析版本。匹配来源的帧在 3 秒内未出现时不写文件；边界/序号检查保留，协议仍无 CRC。

训练与导出共用预处理：raw 先保持上采样至 4 kHz、整数陷波、抽取、可选已有带通；同版已滤波 CSV 跳过重复陷波，错误来源/版本/采样率或已知裁剪数据拒绝。`--input-mode waveform` 直接读取连续板端录制，none 标签仍通过滤波，再在窗口阶段排除。notch 实验默认写独立模型/指标，保留生产权重。

当前没有干净、有标签、多受试者的新采集，不重训生产权重；已有准确率仅适用于原先评估设置。滤波预处理测试不是新模型准确率测试。保持上采样不能恢复 NinaPro 200 Hz 输入不存在的带宽；训练加载器尚未处理采样时间缺口，不能对含缺口数据声称与连续 PL 状态一致。

## 电源实测与 BIAS 状态

用户提供 +5V＝5.00 V、AVDD＝2.49 V、AVSS＝−2.50 V、DVDD＝3.32 V，模拟跨度 4.99 V。直流数值基本正常，纹波和整机隔离仍未知。R4＝1 MΩ/C25＝1.5 nF 是反馈网络；R7＝0 Ω，BIA 直接接人体且没有其他串联保护的问题未解决。保持此前取下人体电极的安排；数字滤波不补足输出保护或电源/通信隔离。本轮未改变 ADS1299 寄存器或启用新的 BIAS 通道反馈。

## 复现与部署

```powershell
powershell -ExecutionPolicy Bypass -File build/scripts/run_notch50_sim.ps1
build/scripts/run_data_path_sim.bat
build/scripts/run_pl_export_sim.bat
powershell -ExecutionPolicy Bypass -File build/scripts/run_uart_record_test.ps1
python -m unittest sim.test_uart_waveform sim.test_notch_preprocessing -v
sw/ps_uart_print/build.bat
powershell -ExecutionPolicy Bypass -File build/build_all.ps1
```

完整构建须通过项目现有参数绑定、网表系数、DSP 字面量、布线时序及启动分区一致性门禁；不得将失败构建或旧 BOOT.BIN 当作本次版本。硬件烧录及人体测量不在本次软件验证结果之中。
