# sEMG 手部运动重建与康复训练系统

2026-10-23 首轮康复训练反馈：各动作需明显用力才能识别，尚待区分静息门控、
模型置信度与训练力度覆盖的影响；本次未调整识别参数。见 [首轮实测记录](report/rehab_20261023/first_round_feedback.md)。

2026-10-23 增加协同平滑显示和可选握拳相对强度训练：协同页保留原始 C，
活动条与趋势使用平滑值；康复页采舒适抓握参考后，可要求握拳时 C2 保持在
参考的 80%–120%。这是相对肌电活动反馈，不是力量百分比。操作、验证和
独立候选 BOOT 见 [握拳反馈记录](report/grip_feedback_20261023/README.md)。

## 1. 项目目标

2026-10-23 增加 PL 独立决策链：静息校准/门控、置信度、防跳变和已验证通道映射
在 PL 中运行，LCD 与康复训练读取最终决策；PS 保留适配引导和候选独立验证。
DMA 暂停不再阻塞 PL 决策，导出丢失仍通过 overflow 报告。六路机械手 PWM 原语
仅完成独立仿真，未接入引脚或机械手。范围、协议、测试与候选 BOOT 记录见
[PL 控制迁移记录](report/pl_control_20261023/README.md)。

2026-10-23 增加 LCD 康复训练任务：从 **菜单 → 康复训练**，或 **设置 → 康复训练**
进入。支持张开、握拳、腕屈、腕伸的单动作训练，以及四动作依次循环的组合训练；
可设置每动作 3/5/10 次、保持 1/2/3/5 秒、休息 2/3/5 秒。
训练先执行静息校准，再按“放松 → 目标动作 → 连续保持 → 放松休息”运行。
页面提供暂停/继续、结束、结果回顾，完成后默认将摘要和逐次结果保存为 SD 卡
`RH000.CSV`、`RH001.CSV` 等新文件，也可关闭自动保存后手动保存。
结果是按肌电识别判定的任务完成情况；“识别响应”是提示到首次有效稳定识别的时间。
训练与波形文件记录分开运行，训练提示不自动写成波形的真实动作标签。
说明、验证与预览见 [康复训练实现记录](report/rehab_20261023/implementation.md)。

面向 AMD FPGA 初级赛道，完成一个“由表面肌电驱动的手部运动重建与康复训练系统”。

本项目不把目标限定为简单的动作分类，而是将肌电信号用于手势识别、手部姿态重建、肌肉疲劳反馈和康复训练评估，形成“采集 - 处理 - 推理 - 重建 - 反馈”的完整闭环，突出 FPGA 在低延迟生物信号处理、边缘智能推理和实时反馈中的技术含量。

### 1.1 选题背景（为什么选这个题）

- **实际问题**：手部运动功能障碍（卒中后康复、肌腱损伤）的日常训练依赖康复医师一对一指导，设备昂贵、居家场景空缺。sEMG 是人体运动意图最直接的电生理信号，用它驱动低成本的手部运动重建，可为居家康复训练和人机交互提供基础部件。
- **前人工作与差异**：学术界以 NinaPro 等公开数据集上的离线动作分类为主（深度模型、PC 端）；消费级方案（如 Myo 臂环）封闭且只做手势分类。本项目的差异点是把整条信号链——采集、滤波、特征提取——落进 Zynq PL 的确定性逻辑（逐位可验证），推理轻量化后部署到片上，形成一块芯片上的完整闭环，而非 PC 上限的演示。
- **FPGA 的必要性**：生物信号链路要求采样-处理时延确定可测（PL 流水线时延固定），且 8 通道 × 4 kSPS 的逐样本流水在 PL 中几乎不占资源，为后续多通道扩展留出余量。

## 2. 当前约束

- 目标板卡：`XC7Z020-2CLG400`
- 主采集器件：`ADS1299` 八通道生物电 ADC
- `ADS8698` 作为可选辅助模拟量采集器件
- 现阶段没有现成 EMG 模块
- 训练与算法验证采用公开数据集 NinaPro DB5 回放（`data/`，见 `tools/`），不依赖真实肌电硬件即可推进算法与工程链路
- INT8 MLP 推理已下沉至 PL（`emg_nn_infer.v`，与 Python 金模型逐位一致）；PC 端实时分类（`tools/realtime_inference.py`）保留为对照路线
- 板卡实测已打通 UART0 @ MIO14/15（CH340C）数据通路；ADC 八根 SPI 信号已迁移到底板 J4-17..24（bank13，3.3V），为板载 RGB LCD 显示让出 bank34 总线（接线表见 `board/README.md`，待改线验证）

## 3. 作品定位

- 康复训练辅助
- 肌电人机交互
- 虚拟手姿态重建
- 生物信号处理教学演示

面向竞赛展示场景，按「康复辅助/人机交互/教学演示」定位，不涉及医疗诊断或治疗用途。

## 4. 总体方案

### 4.1 数据流（已实现）

`sEMG/电极 -> ADS1299 -> PL 滤波/特征 -> 已选映射/INT8 推理 -> PL 置信度/门控/稳定决策 -> AXI-Stream/DMA 遥测 -> PS LCD/康复反馈`

FFT 疲劳支路继续并行处理同一最终滤波波形。PS 完成标注适配与验证后，以带确认的
AXI GPIO 邮箱下发映射；PL 决策不依赖遥测 ready。此结构对应 PL-control 配套固件，
旧兼容固件仍保留 PS 判决路径。

当前源码（2026-10-21）：PL 原始 ADC 分支保留，处理支路为八通道独立状态的 **50 Hz/Q10 陷波 → 50 Hz 间隔梳状滤波（齿宽 1 Hz）→ 20 Hz 高通 / 约 215 Hz 低通**。最终有符号波形同时供 LCD、串口、SD、识别和疲劳链使用，特征支路不再重复带通。四路异步 FIFO 合流为 64-bit AXI-Stream（type：1=raw / 2=feature / 3=NN 结果 / 4=fatigue 与频谱 / 5=processed），经 DMA 进入 PS。每批为 1024 个 64-bit word、8192 B。需配套部署本版 PL 位流与 PS 固件；验证记录见 `report/line_filter_20261021/validation.md`。旧模型在新滤波下的识别准确率仍需重训评估。

以下为 2026-10-21 历史处理版本：完整构建已通过五项项目门禁，布线 WNS＝+0.360 ns、WHS＝+0.042 ns。
`build/boot/BOOT.BIN` 于 2026-10-21 22:18（UTC+8）生成，固件标识
`20261021_LINE_FILTER_V1`；镜像、ELF 与位流 SHA256 见
`report/line_filter_20261021/artifacts.json`，本轮未烧录。
原有 LCD 约束/复位告警见陷波验证记录；当前镜像与软件验证见
`report/lcd_waveform_20261015.md`。

### 4.2 功能模块

- 采集模块：SPI 驱动 ADS1299，读取 24 位多通道生物电帧
- 预处理模块：4 kSPS 下进行 50 Hz/Q10 陷波、50 Hz 梳状滤波及 20–215 Hz 带通；带通保存量化余量，抑制整数反馈造成的直流偏置；输出保留正负波形
- 特征模块：MAV、WL、Energy、ZC、SSC 窗口特征（与 PC 参考模型逐位一致）
- 推理模块：INT8 MLP（`emg_nn_infer.v`，16-MAC 时分复用阵列，56µs/窗 @100MHz），权重 1377 字 BRAM，与 PC 金模型逐位一致；当前生产基线 LoSo pooled accuracy 为 84.04%，PL 对齐连续流实验为 83.46%；后续可升级 1D-CNN / TCN
- 疲劳模块：8 通道分时复用 2048 点 radix-2 FFT（`emg_fatigue.v`，自写 RTL 避开 Xilinx FFT IP），512ms 窗计算 MDF 均值，16 点历史线性回归斜率输出 RTL 定义的疲劳等级；PS 已按有符号斜率分子和 0..3 等级解析并输出
- 判决与校准模块（PL-control：`emg_control_policy.v`，PS 兼容实现保留）：上电丢弃 80 窗并平均 16 窗的各通道 MAV，阈值为 max(3×基线,1000)；输出整数 softmax 置信度、静息门控及经 3/6/8 窗规则稳定的最终类别。UART `c` 或 LCD 触发静息重校准；超时/协议异常阻止采用失效决策。PS 仍校验遥测完整性，并执行适配候选评分与独立验证。
- 数据采集模式：`r` 在 115200 文本监控与 2 Mbaud 二进制采集间切换，`n` 选最终处理波形（默认，帧头 `AA 58`），`u` 选原始 ADC（`AA 55`）；之后均为 `seq u16 LE | 8×int24 LE`，共 28 B。`--signal notch50` 兼容原命令并选择最终 processed 信号；`--signal legacy-notch50` 才选择历史单陷波固件（`AA 56`）。每帧验证来源并保存滤波版本。
- 重建模块：把模型输出映射为离散手部姿态（rest/张开/握拳/腕屈/伸腕）+ 平滑插值的低维参数
- 显示模块：最终运行路径由 PS 裸机固件直接驱动 RGB LCD/VDMA，使用共享 22 自由度姿态表、定点三角函数查表和 5x7 内置字模绘制板端 2D/2.5D 虚拟手，显示动作、疲劳等级和 rest 门控状态，不依赖 PC 或操作系统。PC 端 `tools/virtual_hand.py` 保留为高保真 3D 调试视图，解析 `P v=1` 的 15 参数旧帧并自动补全，也支持 `schema=2` 连续 22 参数；保留 `R/T` 旧协议回退，支持鼠标旋转、平移和缩放（`--demo` 可离板演示）。本轮优化修正了掌指比例、腕部转角、拇指根部遮挡和握拳时指尖穿模问题，并生成了 `report/pose_preview_*.png` 预览图。LCD 页头新增 **DATA** 页面，直接显示 8 通道 MAV 活动条、原始样本、每通道门控阈值、动作置信度、疲劳 MDF/等级、raw/feature 缺口、异常计数和 BIAS 配置状态；数据由现有 PS 解析结果实时刷新，不改变采集协议。

### 4.3 LCD 单通道实时波形

配套固件 `20261015_LCD_WAVE_V1` 增加本地逐点波形页。点击页头 **WAVE**
进入，**HAND** 返回虚拟手；底部 **CH1–CH8** 选择一个通道。
不需要连接 PC，不需要进入串口记录模式，波形也不依赖静息校准或门控结果。

- **全处理 / RAW**：最终带通后的有符号采样 / 原始 ADC 有符号采样，
  默认全处理；与串口录制源独立，切换时清空旧通道/旧源的显示历史。
- **50 / 100 / 200 MS**：循环切换时窗，默认 100 ms，保留每通道 4 kSPS 的
  每个样本，用折线连接相邻点。显示器刷新与采样独立，没有整流或包络计算。
- **Y AUTO / Y 数值**：自动纵轴或固定半量程，单位 **ADC count**。
  固定范围依次为 100、500、2000、10000、50000、200000、1000000、10000000；
  超出绘图范围显示 **VIEW CLIP**，ADC 接近实际满量程时显示 **ADC CLIP**。
- **DC AUTO / DC ZERO**：按当前窗口均值居中 / 以原始零值为中心。
  DC 显示被减去的中心值，纵轴显示相对该中心的偏差；这个设置只影响绘图。
- **PAUSE / RUN**：冻结/恢复波形；暂停时采集、识别和串口录制继续，
  仍可修改冻结波形的时窗、中心和纵轴。换通道/换源自动恢复运行。

**GAP** 为当前所选通道/源自切换后检测到的缺失样本数，曲线在缺口断开，
横坐标保留采样间隔；**RESTART** 统计逆序/重启。没有匹配源时显示 **WAIT DATA**，
停止收到数据约 250 ms 后显示 **NO DATA**。4 kSPS 是采样率；50 FPS 是软件
默认调度上限，不是实测帧率，可在 SET 页调整刷新间隔。LCD 仅显示最近时窗，完整保存使用 SD 或 PC 录制器。

触摸异常时，115200 监测串口可发 `w` 切换波形页，`1`–`8` 选择通道。
波形功能最初仅改 PS；后续 BIAS 版本同时更新 PL/PS，需使用同版 ELF / BOOT.BIN。
波形回归和预览见 [LCD 波形验证记录](report/lcd_waveform_20261015.md)。

### 4.4 LCD 数据分析页

点击页头 **DATA** 进入实时分析页，点击 **HAND** 返回虚拟手；SET 页可直接进入
逐点波形页。页面中的每个通道条以当前 MAV 窗口值绘制，校准完成后同时显示该通道
的门控阈值，超过阈值的通道使用警告色。底部显示当前动作与置信度、疲劳 MDF/等级、
raw/feature 缺口、异常样本计数、当前特征链路和 BIAS/ADC 配置状态。点击通道卡片可
高亮该通道并查看其最近 raw 值。页面不依赖 PC 或串口记录模式；只有完成 PL/PS 同版
部署后，实时特征、疲劳和配置状态才会与板上数据一致。
触摸暂时不可用时，可在监控串口发送小写 `a` 打开/返回 DATA 页；`w` 仍切换
HAND/WAVE，`1`–`8` 仍选择波形通道。

### 4.5 LCD 频谱与专业分析摘要

#### SD 双路记录与 LCD 标注

LCD 菜单中的“SD记录”会在 FAT32 卡上创建不覆盖旧文件的 `EMGnnn.BIN`。每帧保存同一序号的 8 路 raw 与 processed（int24，小端），并带有 REST、OPEN HAND、FIST、WRIST FLEX、WRIST EXT 动作码。新文件头为版本 2、filter_code=3；解码器仍支持历史版本 1。开始记录前选择动作标签，停止后再断电；满队列会停止记录并显示错误。启动记录不再重启 DMA，运输通路复位统一清空 FIFO 两端，避免起录时重放旧帧；重复/逆序完整帧会停止记录并报 `0x105`。

PC 端可用 `python tools/decode_sd_record.py EMG000.BIN --outdir export` 导出两份带 `timestamp_us`、8 通道、`action` 的 CSV 和 JSON。解码器校验头、帧长、int24 符号扩展、16 位序号回绕，并报告缺帧数量。

频谱页使用选定 processed 通道的 2048 点 FFT，保留约 20–450 Hz 的 220 个 bin，并按屏幕宽度压缩每个 bin 的像素宽度；峰值归一化保留顶部余量，全零输入显示 `NO SIGNAL`，避免所有谱线冲顶。约 215 Hz 以上已受低通衰减，不能据此还原原始高频功率。

当前 FFT 疲劳模块已经把频域摘要送到 PS/LCD，而不是把 MDF 当成完整频谱。
每个 512 ms 窗口输出八通道合计的 30 段窄频相对功率（20–450 Hz，约 14.3 Hz/段），
以及 20–450 Hz 峰值频点；原有 MDF、疲劳斜率、总能量和等级继续
保留。LCD 顶部点击 **DATA** 可在 DATA 和 **SPEC** 页面之间切换，监控串口发送
小写 `s` 可直接切换 SPEC。当前 SPEC 页绘制选定通道的 220 个 FFT bin，显示该通道峰值、
八通道合计的 MDF 和相对峰值 60 dB 范围；PL 的 30 段摘要继续用于已有诊断。
谱线按当前窗口归一，不代表跨受试者的绝对幅值。

指标选择参考 Delsys EMGworks/Trigno、Noraxon myoRESEARCH/MR3 和
ADInstruments LabChart 等公开 EMG 软件的常见工作流：原始波形质量、滤波/整流、
RMS 或活动量、频谱/平均频率/中位频率、跨通道比较、事件标记和会话导出。当前
工程已落地的是波形、MAV/门控、RMS 相关离线分析、MDF/频带摘要和数据质量提示；
不会把有限的屏上摘要宣称为临床诊断结果。完整映射和后续 PL 路线见
[EMG 分析功能与 PL 扩展路线](report/emg_analysis_roadmap_20261016.md)。

频谱结果包扩展了 type 4 的 id 10–15，数据格式和带宽影响见
[PL 到 PS 数据通路](report/pl_ps_data_path.md)。这次 RTL 变更已经完成行为级
FFT 回归、完整 PL 导出仿真、LCD 主机渲染回归，并通过
`check_notch50_synth.tcl` 的 XC7Z020 OOC 综合（0 error、0 critical warning）。
该检查不包含完整 BD 布线和位流生成；部署前仍必须重跑完整实现、DMA 长时间丢包和
函数源频点验证。

#### LCD 统一界面与设置（2026-10-18）

点击页头 **SET** 或菜单中的 **DISPLAY SETTINGS**，进入设置页。第一行可直达
**HAND / WAVE / DATA / SPEC / SD**，其余按钮支持刷新最小间隔 **20 / 50 / 100 MS**、
波形和频谱网格、波形 **RAW / 全处理**、**50 / 100 / 200 MS** 时窗、
**DC AUTO / ZERO** 和 **Y AUTO**。设置立即生效，保存在 RAM，重启恢复默认值；
**RESET DISPLAY** 恢复显示默认值并保留通道选择。切换页面不会停止正在进行的 SD 录制。

800×480、1024×600 使用统一按钮和文字测宽；长文本按区域截断，中英文垂直居中，
纵轴使用 K/M 简写并保留顶部精确范围。顶栏 **DATA / SPEC** 往返切换，**HAND** 返回手部视图。
验证范围及预览见 [LCD 界面验证记录](report/lcd_ui_20261018.md)。

### 4.6 查看板卡完整波形与原始对照

普通监控串口的 `R/P/F/T` 文本行不能还原完整波形。采集模式通过 2 Mbaud 串口
输出所选支路的八通道有符号 24 位采样，每通道 4 kSPS。默认选择 PL 最终处理支路；
原始 ADC 用 `--signal raw`。本次增加陷波必须先部署配套 PL/PS；部署完成后的
源选择和模式切换均可在运行时进行。旧板端仅支持原始采集时必须显式选 raw。

先关闭占用板卡串口的串口助手或其他上位机。在项目目录的 PowerShell 中运行
（`COM16` 为本次检测到的 CH340 串口，重新连接后请核对端口号）：

```powershell
python tools/record_uart.py --port COM16 --enter --signal notch50 --plot --keep-all --subject s30 --session e3
```

- `--enter` 从 115200 监控模式切换到采集模式；若已处于采集模式，请去掉此参数。
- 窗口显示 CH1–CH8 最近约 3 秒波形；仅为显示去除慢变基线并分别自动缩放，CSV 保留所选支路的完整采样值。`--signal notch50` 新录制的 JSON 标为 `processed`，含完整滤波版本；raw CSV 保留原始 ADC。
- **`--keep-all` 必须保留**，这样未标注、放松和动作切换阶段都能保存；默认训练录制模式会丢弃未标注段并裁剪动作边界。
- 在波形窗口按 **`q`** 或关闭窗口保存。**`m` 会丢弃本次录制并切回监控模式**。
- 输出路径会打印在终端，一般为 `data/raw/board/s30/S30_E2_A1_waveform.csv` 及同名 JSON。重名时自动添加后缀，保留旧文件。
- 按 `q` 保存后板卡仍在采集模式，下一次录制应去掉 `--enter`。

在同一次上电中改录原始对照（仍处于采集模式，不带 `--enter`）：

```powershell
python tools/record_uart.py --port COM16 --signal raw --plot --keep-all --subject s30 --session e4
```

每次仅录一路，不保证两次动作相同；选 raw 不会关闭识别/LCD 的陷波。JSON 记录
`signal`、滤波版本及帧头。3 秒内收不到已验证的匹配帧则报错且不写 CSV，避免
旧固件的原始数据被误标为陷波数据。

如果需要同一次动作同时得到 raw 和 notch50，使用一次 raw 录制并让 PC 自动生成配对文件：

```powershell
python tools/record_uart.py --port COM16 --enter --signal raw --plot --keep-all --save-both --subject s30 --session e4
```

退出保存后会写入 raw CSV，并在同目录生成带 `_processed` 后缀的 CSV 和 JSON。两份文件
逐行共用时间戳和动作标签，processed 使用与 PL 相同的 `notch50_q10_comb50_bw1_hp20_lp215_v1` 定点算法。
现有 UART 协议不在 2 Mbaud 下同时发送两路完整波形；`--save-both` 因而不会增加串口负载。
若 raw 录制有丢帧，生成文件会在时间戳缺口处重置滤波器，并在 JSON 的
`filter_state_resets_at_timestamp_gaps` 中记录次数。离线派生从零状态启动，而板端滤波器通常在起录前已运行；起始瞬态及缺口后瞬态不保证与板端逐点相同。新 SD 文件直接同时记录板端 raw 和最终处理波形。

已有 raw 文件也可以单独配对：

```powershell
python tools/derive_notch50.py --input data/raw/board/s30/S30_E4_A1_waveform.csv
```

工具默认生成 processed，并拒绝对已滤波文件重复滤波；历史算法可显式指定 `--signal notch50` 或 `--signal notchcomb`。

保存后查看最近一次录制的全时段概览：

```powershell
python tools/plot_csv.py --latest
```

概览按时间分箱显示最小值和最大值。查看第 5 秒开始的 0.2 秒内每个采样点：

```powershell
python tools/plot_csv.py --latest --raw --start 5 --duration 0.2
```

此处 `plot_csv.py --raw` 仅表示逐点画图，不切换采集源。图标题显示 JSON 中的
来源；旧文件没有来源标记时按未知显示。可用图窗工具栏放大、平移；
`--channels 0,1` 只看物理 CH1/CH2，`--dc none`
保留电极直流偏置。默认仅为显示减去每通道中位数，纵轴单位为 ADC counts，
尚未换算为 µV。也可用具体 CSV 路径替代 `--latest`，避免选到其他会话。

若需要把一次录制整理成可复核的数据分析页面，运行：

```powershell
python tools/analyze_capture.py --latest
```

工具会在 CSV 旁生成同名 `_analysis.html` 和 `_analysis.json`。HTML 页面包含八通道
波形包络、可选通道的频谱、直流偏置与 RMS、ADC 饱和计数、时间戳缺口、最大缺口、
通道相关性、第一主成分占比、标签分布及质量状态（`PASS/CHECK/BAD`）。频谱只使用
连续数据段；最多对四个缺失样本做线性插值并在报告中计数，较大的缺口会被排除。
因此质量指标不会把丢帧压缩成“更高频率”。报告对 `notch50` 数据也会明确提示：
49–51 Hz 数值是陷波后的输出，不能当作陷波前的实测抑制度。

先录制 10–30 秒检查各通道。当前录制器先缓存在内存，退出时才写盘，
不适合无限时长录制。完整保存指保存本次有效接收的全部帧；终端/窗口的
`drop` 及 JSON 的 `frames_dropped_uart` 反映接收帧序号缺口，丢失样本无法恢复。
新录制的 CSV 会保留这些缺口对应的时间，离线图会在缺口处断开。

录制器会对每一帧检查下一帧头是否出现在准确的 28 字节边界，避免丢一个
字节后把下一帧头误当作 CH8 数据。窗口的 `bad` 和 JSON 的 `boundary_rejects`
表示边界不符的候选数，不等同于丢失帧数。末尾没有下一帧头确认的数据不保存，
通常约一帧（0.25 ms）；缓冲尾部字节数记录在 `unconfirmed_tail_bytes`。
这些检查不能替代 CRC；当前串口协议没有校验和，无法检出所有数据损坏。

2026-10-15 实采中的条形尖峰及 50 Hz 干扰诊断见
[诊断报告](report/waveform_diagnosis_20261015/report.md)。原始记录保持不变，
报告图片中排除坏帧的视图仅用于诊断，不是恢复后的原始数据。

PC 工具回归测试（模拟串口数据，不打开硬件端口）：

```powershell
python -m unittest sim.test_uart_waveform sim.test_notch_preprocessing -v
```

连续标注录制可直接用于新预处理实验；训练与 INT8 导出均支持：

```powershell
python tools/train_baseline.py --data-dir data/raw/board --input-mode waveform --fs 4000 --notch50 --pl-filter --win-samples 400 --hop-samples 100
```

需至少两名有效标注受试者才能做现有 LoSo 评估。`--notch50` 现在选择最终 processed 链，
已标记同版最终处理的 CSV 不会重复带通。历史单陷波使用 `--legacy-notch50`，
仅陷波加梳状使用 `--notch-comb`。裁剪、丢帧、逆序或重复的数据拒绝直接训练，须先整理连续段。
新实验默认带 processed 后缀，保留生产权重；旧准确率不能直接作为新链路的准确率。

### 4.7 BIAS 配置与实际寄存器读回

`20261015_BIAS_RREG_V1` 默认选 CH1 的 P/N 对称参与 BIAS 反馈，
`CONFIG3=EC`、`BIAS_SENSP=01`、`BIAS_SENSN=01`。启动时读回并核对 01–0E
寄存器，通过后开始采集；读回不符时停止进入采集，PL_KEY0 可复位重试。
LCD 顶部显示 `BIAS CFG WAIT / BIAS CFG OK / ADC CONFIG ERROR`。

监测串口 115200、8N1 发送小写 **`b`**，直接输出固件版本、实际 CONFIG3/P/N
和首个不符的寄存器地址，无需先发 `d`。正常为 `done=1 ok=1 error=0`、P/N 均为 01；
CONFIG3 的只读位可能使 EC 显示为 ED。`b` 显示上次启动/重配取得的读回快照。
CHnSET=40 按数据手册为 **8 倍增益**，采样率保持 4 kSPS。

本版用于先完成无人体等效负载与小信号验证。配置读回通过仅证明数字配置一致，
模拟反馈稳定性、共模抑制效果和整机人体连接条件还需分别核实。
详细配置、验证结果和检查步骤见 [BIAS 验证记录](report/bias_bench_20261015.md)。

## 5. 最小可交付版本

第一版不要追求“全手所有关节的精确连续重建”，先做一个可稳定演示的闭环：

- 8 通道输入（已实现，超出原定 4 通道）
- 5 类基础动作：rest/张开/握拳/腕屈/腕伸（已实现）
- 100ms 滑动窗口（已实现）
- 25ms 步长（已实现）
- 输出动作类别 + 置信度 + 手部姿态参数（已实现：`R` 旧行兼容 + `P v=1 schema=2` 22 参数 PoseFrame；PC 对旧 15 参数帧自动适配；后续模型只需替换 PS PoseAdapter）

建议优先实现这些动作：

- 张手
- 握拳
- 屈腕
- 伸腕
- 放松

## 6. 阶段计划

### Phase 0：工程骨架

- 建立目录结构
- 统一文件命名
- 写清楚输入、输出、依赖、验证方式
- 准备 README、测试说明和结果记录模板

### Phase 1：ADS1299 采集链路

- 完成 ADS1299 上电、复位和寄存器配置
- 跑通 ADS1299 `DRDY` 同步和 SPI 帧读取
- 完成基础读数和波形导出
- 用固定电压或函数源验证采样稳定性

当前 `src/rtl/ads1299_spi.v` 已实现上述链路的 RTL 状态机：复位后发送 `SDATAC`，通过一次 `WREG` 连续写入 `CONFIG1` 至 `CH8SET`，再发送 `RDATAC` 和 `START`，最后按 `DRDY` 读取 24 位状态字与 8 路 24 位通道数据。功能仿真入口为 `sim/ads1299_functional_tb.v`，可运行：

```text
build/scripts/run_ads1299_sim.bat
```
- 保存 CSV 数据用于后续训练和回放

状态：RTL 完成并板测通过（UART0 @ MIO14/15 数据流实测）。

### Phase 2：信号处理

- 完成滤波、整流、包络、窗口切分
- 验证特征提取正确性
- 对比 MATLAB / Python / RTL 结果

状态：4 kSPS 重设计完成，特征与 PC 参考模型逐位一致（`tools/emg_reference.py` compare-export 回归全绿）。训练和量化工具已增加连续流输入、RTL 定点带通、400/100 窗口配置和独立实验输出，避免训练参数与 PL 链路隐式漂移。

### Phase 3：模型训练与部署

- 先在 PC 端训练 baseline
- 再做 INT8 量化或轻量化模型
- 明确哪些逻辑放在 PL，哪些放在 PS

状态：INT8 MLP 已部署 PL（`tools/export_int8.py` 生成权重 → `emg_nn_infer.v` 推理，仿真与 Python 位精确模拟器逐值一致，时延 56µs）。已补齐显式的 4 kSPS/400-100 窗口/RTL 定点带通实验路径；连续流 PL 对齐实验的浮点 LoSo pooled accuracy 为 83.46%，INT8 加权准确率为 83.64%，当前不替换生产权重，实验数据与结论见 `report/signal_chain_alignment.md`。

### Phase 4：手部重建

- 将模型输出映射成手指/腕部低维参数
- 做虚拟手模型驱动
- 加入个体化校准

状态：分类驱动离散姿态（干电极 SNR 尚不足以支持连续角度回归）。已实现：个体化静息校准 + rest 门控（PS 固件，`c` 命令重校准）、PS 端两窗动作确认、共享姿态契约和板载 LCD 本地虚拟手绘制；PC 端 `tools/virtual_hand.py` 可串口驱动并以 `--demo` 离板预览。本轮已完成虚拟手比例、姿态几何和板端整数渲染路径；待做：改线后的 LCD 实机验证、连续运行稳定性和显示更新耗时测量。

### Phase 5：展示与文档

- 做实时展示界面
- 输出资源占用、时序、延迟、准确率
- 整理可复现脚本和实验记录

状态：FFT 疲劳管线（FFT-MDF）已入 PL 并通过 56 词位精确仿真；工程检查单见 `report/competition_checklist.md`、`skill/checklist.md`。当前实现指标已由 `tools/collect_vivado_metrics.py` 汇总到 `report/hardware_metrics.md`；数据路径、PL 导出、生产 NN、PL 对齐实验 NN 和 PS 固件均已完成自动化验证。板级端到端延迟、连续运行稳定性、疲劳链路实测和干净目录复现仍待补齐。

## 本轮优化总结（2026-09-30）

本轮工作的目标是把“PL 数据通路、PS 解析、PC 训练和比赛展示”从能运行推进到参数明确、可复现、可验证。

### 1. 数据通路和 PS 健壮性

- 统一 AXI-Stream DMA 批次：256 个 64-bit word，即 2048 B；`TLAST` 只在批次末尾拉高。
- PS DMA 双缓冲、链接脚本和 `BUF_PACKETS` 已统一到 256 包，避免 DMA 长度与 PL 批次边界不一致。
- 增加 raw/feature 序号缺口检测；feature 序列或通道/特征顺序异常时，丢弃残缺窗口并重新同步。
- 采集模式按 8 个通道的同一序号组帧，发现混帧或乱序时不输出错误训练帧。
- 修正疲劳包解析：`num2` 按有符号斜率分子解析，支持 RTL 定义的 0..3 等级。

### 2. 训练和量化链路对齐

- `tools/train_baseline.py` 与 `tools/export_int8.py` 共用采样预处理配置。
- 新增连续 `*_full.csv` 输入模式，滤波时保留非目标动作样本的状态，窗口筛选时再排除无关标签。
- 新增 PL 定点带通实验路径：200 Hz 输入保持上采样 20 倍到 4 kSPS，再执行 RTL 同款整数带通。
- 显式支持 400/100 窗口和步长，并将实验模型输出到独立目录，不覆盖生产 `data/models/nn_int8/`。
- 实验结果：生产基线 LoSo pooled accuracy 为 `84.04%`；连续流 PL 对齐实验浮点结果为 `83.46%`，INT8 加权结果为 `83.64%`。当前证据不足以替换生产权重。

### 3. 虚拟手展示与脱离 PC

- 修正握拳时指尖弯曲上限、拇指链条长度和拇指根部遮挡。
- 修正腕屈/腕伸角度和手掌/手指比例，保留 `P v=1` 与 `schema=2` 协议兼容。
- 新增 `sw/ps_uart_print/pose_contract.h` 生成链路，PC 和 PS 共用动作编号、22 维字段、置信度门限、两窗确认和超时参数。
- PS 端新增无浮点 LCD 渲染器：使用整数角度查表、线段/圆盘、内置 5x7 字模和三帧 RGB888 framebuffer；板端能独立显示动作、疲劳等级和门控状态。
- 已生成 `report/pose_preview_*.png` 作为离板展示检查素材；LCD 物理接线、位流下载和长时间运行仍需上板验证。

### 4. 自动化验证结果

| 验证项 | 结果 |
|---|---|
| 数据路径与 TLAST | 通过，批次边界正确 |
| PL 导出集成仿真 | 通过，6400 raw、200 feature 位精确 |
| 生产 INT8 NN 仿真 | 通过，64/64 窗口位精确 |
| PL 对齐实验 INT8 NN 仿真 | 通过，64/64 窗口位精确 |
| 疲劳链路仿真 | 通过，56 个结果词位精确 |
| PS 裸机固件 | 编译通过 |
| 硬件实现指标 | WNS 1.561 ns，LUT 37.18%，BRAM 18.57%，DSP 38.64%，DRC 0 |

详细数据、复现命令和证据索引见：

- `report/pl_ps_data_path.md`
- `report/signal_chain_alignment.md`
- `report/hardware_metrics.md`
- `build/scripts/run_nn_infer_pl_filter_sim.bat`

## 7. 里程碑

### 1 周内

- 完成工程目录和 README
- 跑通 ADS1299 基础采集方案
- 确定动作集合和数据格式

### 2 周内

- 完成预处理与特征提取
- 跑通 baseline 分类模型
- 形成第一版可视化界面

### 4 周内

- 完成 FPGA + PS 联调
- 形成稳定演示版本
- 输出正式报告素材

## 8. 仓库结构

```text
sEMG-HMRS/
├── README.md
├── src/
│   └── rtl/                 # RTL 设计源码（13 模块：采集/预处理/特征/NN 推理/FFT 疲劳/数据导出/顶层）
├── sim/                     # 仿真 testbench（results*/ 为生成产物，脚本再生成）
├── sw/
│   └── ps_uart_print/       # PS 侧裸机固件（UART 数据通路、静息校准、模式切换、判决输出）
├── build/                   # Vivado 工程（git 只跟踪 BD 源码）与构建/调试脚本
│   ├── create_project.tcl   # 工程重建入口（批处理）
│   ├── update_project.tcl   # 源码变更后重扫（check_design.tcl 自动调用）
│   ├── check_design.tcl     # 综合前防御检查（validate_bd_design 等）
│   ├── export_xsa.tcl       # 导出 XSA 给 Vitis
│   ├── switch_ps_uart0.tcl  # UART0 @ MIO14/15 定案脚本
│   ├── scripts/             # 仿真入口 run_*_sim.bat
│   ├── debug/               # 板级调试 XSCT 脚本（dbg_test_k 一键放跑等）
│   ├── boot/                # FSBL + bitstream + PS ELF 的独立启动镜像
│   └── attic/               # 已废弃/一次性修复脚本存档（勿用于现行流程）
├── board/                   # 板级约束与接线文档
│   ├── constraints/         # hz_zynq_ads1299*.xdc（ADC @ J4-17..24, bank13）+ 时钟约束
│   └── README.md            # ADS1299 接线对照表与改线注意点
├── data/                    # 数据集、模型与指标
│   ├── raw/                 # NinaPro DB5（脚本再生成，不入库）
│   ├── models/              # baseline MLP、生产/实验 INT8 权重、疲劳测试向量
│   ├── processed/
│   └── metrics/
├── tools/                   # PC 端工具链
│   ├── emg_reference.py     # 位精确参考模型（RTL 回归金标准）
│   ├── record_uart.py       # 采集模式上位机（打标 + 契约 CSV）
│   ├── virtual_hand.py      # PC 虚拟手（pygame，姿态插值 + 疲劳变色）
│   └── download_dataset.py / prepare_dataset.py / train_baseline.py /
│       export_int8.py / gen_fatigue_mem.py / ...
├── skill/                   # 可复用检查清单（工程检查单、数据通路检查单）
└── report/                  # 设计报告与图表
    ├── signal_chain_spec.md / pl_ps_data_path.md / signal_chain_alignment.md
    ├── hardware_metrics.md
    ├── engineering_notes.md
    ├── ads1299_command_verification.md / evaluation_template.md
    ├── competition_checklist.md
    └── figures/
```

与竞赛指南（3.3.5.4 推荐目录结构）的对照：整体采用推荐结构，额外增加 `tools/`（PC 端数据集与训练工具，对应指南中"测试数据与参考结果"的生产工具）和 `sw/`（PS 侧应用工程，承担指南结构中 `src/ps` 的角色）；`src/hls`、`src/ps` 为指南预留位，暂未建目录。`build/vivado`、`build/vitis_ws`、`build/export`、`tmp/` 为生成物/工作区不入库（见 `.gitignore`），其中 BD 源码（`build/vivado/.../bd/`）作为唯一手写硬件源例外跟踪。仓库内所有目录与文件名均为纯英文，符合指南对命名的要求。

当前工程骨架已经按上述结构落盘。入口脚本为 `build/create_project.tcl`，目标器件为 `xc7z020clg400-2`。使用 Vivado 批处理创建工程：

```text
vivado -mode batch -source build/create_project.tcl
```

日常流程：改 RTL → `build/check_design.tcl`（防 XCI 缓存过期）→ 综合/实现 → `build/export_xsa.tcl` → Vitis 切换 XSA 重编固件；板级放跑用 `build/debug/dbg_test_k.tcl`（先跑 `build/debug/pre_debug_stop.bat` 停核防挂死）。

最终脱离 PC 的启动流程：完成实现、生成 PS ELF 后运行
`build/boot/build_boot_bin.bat`，得到 `build/boot/BOOT.BIN`。将该镜像一次性写入板卡 QSPI 后，板卡上电由 FSBL 自动加载 bitstream 和 PS 裸机程序，LCD 本地显示虚拟手；PC、JTAG 和 UART 仅用于首次烧录、调试或数据采集。QSPI 烧录和断电自启动仍需在目标板上完成实测确认。

## 9. 按比赛要求的交付闭环

每个阶段都要保留“输入、实现、实测结果、复现命令”四类证据：

1. **板级采集**：固定电压或函数源输入，验证 SPI 波形、通道顺序、采样率和数据稳定性。
2. **参考算法**：在 PC 端完成滤波、特征和模型，保存数据格式、训练配置和测试指标。
3. **硬件加速**：将确定正确的模块迁移到 PL/HLS，逐样本对比软件参考结果。
4. **系统联调**：PS 负责配置、DMA 和显示，PL 负责确定性采集、预处理和推理计算。
5. **最终测评**：记录资源、时序、端到端延迟、准确率、功耗或采样稳定性，并填写 `report/evaluation_template.md`。

当前工程已经包含两个层次的 RTL 入口：`src/rtl/ads1299_spi.v` 是 ADS1299 采集接口，`src/rtl/emg_preprocess.v` 是可独立验证的肌电预处理模块。默认仿真顶层为 `ads1299_functional_tb`；寄存器默认值、24 位帧格式和 XDC 必须按实际 ADS1299 载板核对后上板验证。信号链约定见 `report/signal_chain_spec.md`。

## 10. 主要风险

- 没有现成 EMG 前端，导致真实采集延期
- 连续重建缺少高质量标签
- ADS1299 载板需要核对输入保护、参考、BIAS 和供电隔离
- 先做复杂模型会拖慢整体闭环

### 应对方式

- 先用公开数据和模拟输入完成闭环
- 先做动作分类和低维姿态估计，再升级到更细粒度重建
- 先保证工程可演示，再逐步提升模型复杂度
- 运动重建已固化「分类驱动离散姿态 + 平滑插值」路线，不再追求连续角度回归

## 11. 当前建议

现在最应该做的三件事：

1. 跑实现出位流 → 重导 XSA → 按 `board/README.md` 接线表把 ADC 八线改焊到 J4-17..24 → 复测 raw/feature/NN 链路 + 疲劳 T 行板测，并生成 `build/boot/BOOT.BIN`
2. 模式切换全流程板测：`python tools/record_uart.py --port COM3 --enter` 进采集 → 打标采集 → `m` 回监控自动重校准，并记录长时间运行的 raw/feature 序号缺口
3. 补最终竞赛证据：PC 浮点 vs PL INT8 的准确率/时延/资源对比、板级端到端延迟、功耗/稳定性、QSPI 断电自启动和干净目录复现；生产权重继续使用 `data/models/nn_int8/`，PL 对齐实验权重仅作对照，PC 3D 虚拟手只作为调试视图

这个顺序最稳，也最符合竞赛评审对“完整性、可复现性、技术含量”的期待
