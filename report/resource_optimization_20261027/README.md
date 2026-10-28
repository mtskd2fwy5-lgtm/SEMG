# PL 架构核对、资源优化与性能对比

日期：2026-10-27；器件：XC7Z020CLG400-2；工具：Vivado 2025.2。

## 架构确认到什么程度

当前可以确认 PL/PS 的功能分工、模块连接和接口，适合作为本轮等价优化的基线。最新整机尚未完成实物联合验收，因此不把它称为已经最终冻结的硬件结构。

| 功能 | PL | PS |
|---|---|---|
| 肌电采集与处理 | ADS1299 SPI、50 Hz 陷波和梳状抑制、带通、特征提取、FFT/疲劳运算、数据流与跨时钟 FIFO | 完整性检查、记录与分析管理 |
| 意图与个体化学习 | MLP 推理与基础决策；HDC 编码、原型更新、相似度；固定 NMF 基矩阵的协同系数求解 | 静息校准、佩戴适配、用户标签、学习/验证流程、DDR 库分配与任务调度 |
| 机械手 | 六路 PWM、限幅、限速、复位保持与超时保护 | 来源选择、动作映射、MPU 掌部目标生成 |
| 交互与训练 | LCD 视频输出链路、触摸/MPU 接口 | 触控界面、虚拟手映射、康复任务、反馈和 SD 文件 |

HDC/NMF 运算已经在 PL，逐窗任务仍由 PS 提交；这不等于整个个体化学习工作流都迁入了 PL。HDC 模型当前仍按 RAM 生命周期管理。虚拟手是识别与姿态映射，并非已完成连续关节角回归；机械手也没有新增位置或力反馈。

## 本轮优化

基线为 V13 对应的 PL：V13 沿用 V12 硬件。优化前保存 routed DCP、bit、XSA、BOOT、RTL、约束和哈希，并核对发布清单中的 15 项输入/制品匹配。详见 [baseline/manifest.json](baseline/manifest.json)。

唯一改动的功能 RTL 是 `src/rtl/emg_window_features.v`。ZC/SSC 每个有效样本最多增加一次，所以默认段内最大计数为 100、窗口内最大计数为 400；内部段计数及环形段缓存由 32 位缩至 7 位，窗口计数由 32 位缩至 9 位，公开输出仍为 32 位。宽度随参数计算，覆盖 1 和 2 的幂等边界。

八个通道都复用这一修改。滤波数值、幅值与能量累加、模型权重、FFT、400/100 窗口参数、FIFO 深度、接口和保护行为保持原配置。原始/处理波形 FIFO 在 V12 已改用 BRAM，这不是本轮新增的节省。

独立单通道综合：LUT **1322 → 1031（−22.01%）**，FF **1405 → 1017（−27.62%）**，DSP **2 → 2**。该结果仅用于定位收益；整机结论以相同 routed 阶段的报告为准。

## 整机资源与性能

最终自动核对结果见 [资源表](resource_table.md)、[性能表](performance_table.md) 和 [comparison.json](comparison.json)。比较脚本检查基线未被改动、只有预期 RTL 变化、两侧均为 Routed、时序达标、仿真具有终态 PASS，再输出表格。

| 整机资源 | 优化前 | 优化后 | 变化 |
|---|---:|---:|---:|
| LUT | 36,417（68.45%） | 33,948（63.81%） | −2,469（−6.78%） |
| FF | 40,463（38.03%） | 36,991（34.77%） | −3,472（−8.58%） |
| Slice | 13,008（97.80%） | 12,708（95.55%） | −300 |
| BRAM | 45.5 | 45.5 | 0 |
| DSP | 111 | 111 | 0 |
| 控制集 | 1,326 | 1,326 | 0 |

八通道特征模块整体由 10,184 LUT / 12,560 FF 降至 7,682 LUT / 9,088 FF。整机的物理优化会重排其他逻辑，所以整机净节省量与该模块差值不完全相同。空闲 Slice 从 292 增至 592，但总占用仍达 95.55%，本轮不是资源优化的终点。

| 性能 | 优化前 | 优化后 |
|---|---:|---:|
| 每通道采样率 | 4 kSPS | 4 kSPS |
| 特征窗口 / 更新间隔 | 100 / 25 ms | 100 / 25 ms |
| 特征核输入 II | 1 周期 | 1 周期 |
| NMF 最大仿真耗时 | 39.58 µs | 39.58 µs |
| HDC 单样本原型更新最大仿真耗时 | 238.63 µs | 238.63 µs |
| HDC 六类推理最大仿真耗时 | 771.88 µs | 771.88 µs |
| 全局建立裕量 WNS | +0.229 ns | +0.434 ns |
| 全局保持裕量 WHS | +0.036 ns | +0.012 ns |

结论是本轮在保持数值、更新节拍和核内周期的条件下节省资源。WNS 提高，但 WHS 变小；25 MHz 特征时钟域的 WNS 也从 +8.624 ns 变为 +8.275 ns。两侧全部用户时序约束满足，不将其描述为所有路径都改善。DRC 没有 Error，仍保留流水、存储控制和 IO 等 Warning，详见原报告。

XSA 中四份 HWH 去掉生成时间戳后完全一致，`ps7_init.c/h` 逐字节一致，导出 XSA 内的 bit 与本次构建 bit 逐字节一致。候选 DCP、bit、XSA 已冻结在 `candidate/`，哈希记录在 `comparison.json`。

这里的性能有两种口径：

- 实际采集：八通道各 4 kSPS，400 样本窗口、100 样本步长，即 100 ms 窗口、25 ms 更新。首窗不是额外增加 100 ms 运算时间，而是需要先收集足够样本。
- 特征核压力测试：连续每周期输入一个样本，首样本到第 400 个样本跨度 399 周期，之后每 100 周期输出一次；没有新增流水周期。实际特征时钟为 25 MHz，测试台的快速时钟用于逻辑行为验证，不作为电路支持更高频率的证明。

时序裕量来自布局布线静态分析。WNS 改善不自动等于真实运行加速，也不能直接用 `1/(周期−WNS)` 宣称整机最高频率。当前时钟配置不变；本轮优化目标是等价功能和处理节拍下释放逻辑资源。

NMF/HDC 使用同一测试台、同一输入向量和 AXI 背压模型，分别重放冻结旧 RTL 和当前 RTL。性能表记录最大任务周期；真实 DDR 争用、PS 调度、LCD 和 SD 开销不在这些核内时间中。没有把仿真时间当成板上响应时间，也没有新增功耗或识别准确率实测结论。

## 验证证据

- [feature_rtl_runner.log](feature_rtl_runner.log)：四组参数（400/100、8/4、63/9、1/1），合计 103,766 个输出窗口逐周期比较旧/新公开输出及有效信号；覆盖满幅交替、零值、微小信号、随机流、有效间断和窗口中复位。独立计数检查首窗与更新节拍。
- [feature_netlist_runner.log](feature_netlist_runner.log)：默认参数综合后 DSP/逻辑网表重放 80,000 周期、746 个窗口，逐位对照冻结旧 RTL，并验证连续 12,000 个输入产生 117 个窗口。primitive 的 100 ns 全局启动复位结束后才开始比较；后续应用复位仍参与比较。
- [control_regression.log](control_regression.log)：PS/PL 固件协议、28,228 窗决策对照、384 窗推理、机械手 PWM/同帧目标/超时/急停，以及 DMA 背压和溢出恢复。
- [learning_regression.log](learning_regression.log)、[baseline_learning_regression.log](baseline_learning_regression.log)：64 组 NMF、720 次原型训练、26 组 HDC 预测及地址、AXI 异常、超时隔离；同时记录同条件核内周期。
- [full_build.log](full_build.log)：整机综合、实现、bit/XSA 导出及原有 G1–G4 门禁。
- [candidate/utilization_routed.rpt](candidate/utilization_routed.rpt)、[candidate/timing_routed.rpt](candidate/timing_routed.rpt)、[candidate/drc.rpt](candidate/drc.rpt)：最终候选的资源、时序和 DRC；同目录保留层次和控制集报告。

以上是 RTL/网表仿真和工具实现证据。本轮没有烧录、改写 SD 卡或驱动真实机械手；真实运行下的丢帧、DDR 争用、端到端响应、舵机行为仍需使用匹配镜像复核。

## 复现

在仓库根目录执行，先使用项目已有 Python 环境：

```powershell
powershell -ExecutionPolicy Bypass -File build/scripts/run_feature_width_equiv_test.ps1
& D:/FPGA/VIVADO/2025.2/Vivado/bin/vivado.bat -mode batch -source report/resource_optimization_20261027/synth_feature.tcl
powershell -ExecutionPolicy Bypass -File build/scripts/run_feature_width_equiv_test.ps1 -Netlist
powershell -ExecutionPolicy Bypass -File build/scripts/run_learning_test.ps1
powershell -ExecutionPolicy Bypass -File report/resource_optimization_20261027/run_learning_baseline.ps1
powershell -ExecutionPolicy Bypass -File build/build_all.ps1 -SkipBoot
& D:/FPGA/VIVADO/2025.2/Vivado/bin/vivado.bat -mode batch -source report/resource_optimization_20261027/audit_candidate.tcl
python report/resource_optimization_20261027/compare_resources.py
```

日志应按上述文件名保存，比较脚本才会接受本轮证据。原 V13 BOOT 保留；本轮生成的 bit/XSA 是优化候选，未重新打包 BOOT，不把旧 BOOT 当作已包含本轮优化。

## 后续优化顺序

1. 优先处理控制集和分散寄存器造成的 Slice 打包压力；同步检查布局和时序，不能只看 LUT 总数。
2. 若仍需要明显压缩，再评估八通道特征提取共享算术、状态放入 BRAM。通道数据到达间隔允许研究复用，但必须重新验证调度、窗口边界、复位和全部特征周期，不能直接替换现有并行结构。
3. 再评估滤波/频域算术复用、位宽与 DSP 映射；涉及数值精度的优化需要重做信号及模型回归。

这些是下一轮候选，不纳入本轮已测节省量。HDC 类别增长下的 DDR 带宽和延迟扩展性，需要独立板测；减少 LUT 本身不能解决随类别数增加的扫描时间。
