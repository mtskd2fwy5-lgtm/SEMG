# PL 结构优化与资源、性能对比（V14）

日期：2026-10-27；器件：XC7Z020CLG400-2；工具：Vivado 2025.2。

本轮继续首轮位宽优化，对整机主要重复算术和寄存器状态进行结构优化。以原 V13、首轮候选和本轮最终结果的相同 Routed 阶段比较。窗口、采样率、滤波系数、模型、FFT 点数、FIFO 深度、公开接口及机械手保护参数均保留。

## 实现变化

1. **八通道特征共享运算。** `emg_window_features_shared` 每周期可接收一个带通道号的样本，八个通道共用 MAV、WL、能量、ZC、SSC 运算电路；每通道上下文和分段历史放入异步读 LUTRAM。默认上下文为 8×424 bit，分段历史为 32×110 bit，保留原算法、定点位宽与 32 位公开结果。
2. **八通道带通共享运算。** `emg_bandpass_shared` 复用一组原有高通、低通运算；每通道状态和分数余量放入 LUTRAM。保留系数寄存器锚点、饱和及分数保存逻辑，每周期可处理一个样本，不增加流水周期。
3. **特征结果缓存使用 LUTRAM。** 将八通道五项结果打包成 8×160 bit 缓存，保留 pending、轮询、序列号、背压和同周期覆盖规则。
4. **按事件范围缩小计数器。** 沿用首轮 ZC/SSC 内部段计数 7 bit、窗口计数 9 bit；公开输出仍为 32 bit，宽度随参数计算。

状态 RAM 不进行全阵列复位，用可复位的 `seen` 位屏蔽旧内容；分段历史在 priming 完成前不参与减法，保证上电和中途复位后的首窗与原版一致。原标量模块保留，`BYPASS_BANDPASS=0` 的本地带通兼容路径也保留并参与回归。新增共享模块是对原通道串行输入接口的内部复用，没有新增外部接口。

功能 RTL 仅更改四个文件：`emg_window_features.v`、`emg_bandpass.v`、`emg_feature_bank.v`、`emg_line_filter.v`。原 V13 全部 RTL/约束在上一轮 `baseline/manifest.json` 中冻结，本轮首轮起点在本目录 `baseline/` 中保存。`implement_shared.py` 仅保留初次推导记录，不能覆盖已核验的最终源码。

## 整机资源

| 资源 | 原 V13 | 首轮 | 本轮 V14 | 相对 V13 |
|---|---:|---:|---:|---:|
| LUT | 36,417 | 33,948 | 25,737 | −29.33% |
| FF | 40,463 | 36,991 | 27,047 | −33.16% |
| Slice | 13,008（97.80%） | 12,708（95.55%） | 9,992（75.13%） | −23.19% |
| BRAM | 45.5 | 45.5 | 45.5 | 不变 |
| DSP | 111 | 111 | 55 | −50.45% |
| 控制集 | 1,326 | 1,326 | 1,215 | −8.37% |

空闲 Slice 由 292 增至 3,308。特征模块从 10,184 LUT / 12,560 FF / 16 DSP，降至 1,539 LUT / 168 FF / 2 DSP；滤波链从 3,754 LUT / 2,726 FF / 55 DSP，降至 1,727 LUT / 1,700 FF / 13 DSP。层次数字用于说明来源，整机物理优化会重排其他逻辑，净收益应以整机总量为准。

LUTRAM 属于 LUT 资源，已包含在上述 LUT 总量中，没有当作免费存储。全部阵列改成 BRAM 会增加同步读延迟和调度开销，本轮使用 LUTRAM 以保留原处理周期。最终报告为 0 latch，DRC 无 Error/Critical Warning；仍有 DSP 流水、RAM 控制和 IO 等 Warning，详见 [DRC](candidate/drc.rpt)。

自动核对表见 [资源表](resource_table.md)、[比较清单](comparison.json)；原始证据见 [资源](candidate/utilization_routed.rpt)、[层次](candidate/utilization_hierarchical.rpt)、[控制集](candidate/control_sets.rpt)。

## 性能

| 指标 | 原 V13 | 本轮 V14 |
|---|---:|---:|
| 每通道采样率 | 4 kSPS | 4 kSPS |
| 窗口 / 更新间隔 | 100 / 25 ms | 100 / 25 ms |
| 特征域 / 学习核时钟 | 25 / 100 MHz | 25 / 100 MHz |
| 带通、特征运算输入 II | 1 周期 | 1 周期 |
| 优化增加的流水延迟 | — | 0 周期 |
| NMF 每窗最大仿真耗时 | 39.58 µs | 39.58 µs |
| HDC 尺度更新最大仿真耗时 | 7.82 µs | 7.82 µs |
| HDC 原型更新最大仿真耗时 | 238.63 µs | 238.63 µs |
| HDC 六类推理最大仿真耗时 | 771.88 µs | 771.88 µs |
| 全局 WNS | +0.229 ns | +0.254 ns |
| 全局 WHS | +0.036 ns | +0.036 ns |
| 25 MHz 特征域 WNS | +8.624 ns | +7.043 ns |

本轮收益是**保留吞吐和延迟的资源压缩**。全局建立裕量略增，但共享后的特征域路径变长；该域仍满足 40 ns 周期。不将它描述为所有路径都改善，不从 WNS 外推整机最高频率，不声称已经测得功耗降低或识别准确率提高。

实际窗口为 400 样本，步长为 100 样本。原标量每通道可每周期接收一个样本，新共享核可每周期接收一个任意通道样本；实际接口本来就是逐通道串行输入，单个时钟边沿最多一拍，因此该复用不会损失本项目输入吞吐。连续同一通道输入也纳入 II=1 回归，避免状态依赖造成隐含空拍。

NMF/HDC 数据来自同一测试台、输入向量和可变 AXI 背压模型，最大周期分别为 3,958 / 782 / 23,863 / 77,188；对应 100 MHz。真实 DDR 争用、PS 调度、触摸绘制、SD 和舵机的端到端耗时尚需板上测量，这些核内仿真时间不等同于人体动作响应时间。详见 [性能表](performance_table.md) 和 [静态时序](candidate/timing_routed.rpt)。

## 验证边界与证据

- [shared_equiv.log](shared_equiv.log)：冻结首轮旧标量/旧 feature bank 与新 RTL 逐周期对照。四组窗口参数 400/100、8/4、63/9、1/1；覆盖同通道连续输入、轮询与随机通道、间断、满幅、小信号、背压及三次中途复位。两个分数保存配置各 78,122 个带通有效输出，另含本地带通兼容路径。
- [shared_netlist.log](shared_netlist.log)：独立综合后的滤波与特征网表，约一万拍有效输出，逐周期比较数据、通道、序列和特征输出，含特征背压及中途复位。
- [shared_integrated_netlist.log](shared_integrated_netlist.log)：从本次实际整机模块引用的 OOC DCP 导出网表，实例化整个处理/控制顶层，仅在 ADC 解码后样本边界注入测试流，逐周期核对最终滤波与特征。没有修改或替换运算网表，也没有用孤立模块重新综合冒充整机结果。ADC SPI 本身不在这项注入测试的覆盖范围。
- [processed_filter.log](processed_filter.log)：现有独立 Python 整数参考及 SciPy 频响检查，包含 50–450 Hz 抑制齿、通带、DC、满幅恢复及通道隔离。
- [control_regression.log](control_regression.log)：28,228 窗策略、384 窗 MLP、六路 PWM、同帧目标、急停/超时、DMA 背压与溢出恢复。
- [learning_regression.log](learning_regression.log)：64 组 NMF、720 次原型更新、26 组 HDC 预测、AXI 异常和超时隔离；周期与原基线一致。
- [full_build.log](full_build.log)：本次完整综合、布线、bit/XSA 导出和 G1–G4 门禁；[comparison.log](comparison.log) 为同阶段资源、时序、输入哈希及全部回归证据核对终态。

初版整机测试使用完全同沿的读写时钟，触发了原有 FIFO 空状态预取的 BRAM 同地址冲突提示；运行记录保留在 `shared_integrated_coincident_clock.log`，该中止试跑不作为通过证据。正式回放使用错开的 25/50 MHz 时钟，并额外检查所有被接受的遥测字不含未知位。没有关闭存储原语碰撞检查，也没有修改既有 FIFO 实现。

## 全链路审查与保留项

| 模块 | 本轮处理 |
|---|---|
| 八通道带通、特征和结果缓存 | 共享算术、LUTRAM 状态、有效位复位；本轮主要收益来源 |
| 陷波、梳状滤波 | 原实现已共享运算；梳状历史使用 BRAM，保留滤波响应 |
| FFT / 疲劳 | 原 2048 点串行复用和 BRAM 工作区保留；不降低频谱分辨率 |
| MLP | 原 INT8 权重 BRAM、串行 MAC 保留；不改模型和判决门槛 |
| HDC / NMF | 原共享乘除器、DDR 原型库保留；核内周期回归，无 PS 算法回退 |
| DMA / 跨时钟 FIFO | 原 BRAM、容量和背压/溢出恢复保留 |
| PWM 与控制 | 六轴、同帧目标、限幅限速、超时、急停和复位保持全部保留 |
| AXI、LCD、PS 与 DDR 配置 | 不重构；HWH（忽略时间戳）及 ps7_init.c/h 一致 |

本轮完成的是有等价证明的主要结构热点优化，并非数学意义的全局最优。继续压缩 HDC/NMF 位宽、FFT 存储或模型会引入新的精度/性能权衡，需独立实验数据支持。本次未以减少容量、降低点数或删除保护换取资源数字。

## 镜像与上板复核

版本：`20261027_HAND_CONTROL_HDC_DYNAMIC_V14`。

镜像路径：`build/boot/BOOT_20261027_HAND_CONTROL_HDC_DYNAMIC_V14.BIN`，大小 5,086,684 字节，SHA256：`292f9ee1a971d468f2e293b7775f99c066b9f5b7b226702dc18d09c0decc78a5`。PL 分区、2 个应用加载段及 3 个 FSBL 加载段核对结果统一记录在本目录 `artifacts.json`，打包终态见 [boot_build.log](boot_build.log)。V13 清单中 28 项 PS 源文件和链接配置逐个校验，`main.c` 只允许版本标识变化；原虚拟手、自学习、LCD、训练和映射功能继续继承。PS/DDR 初始化源与旧 XSA 一致，并对 BOOT 中 FSBL 加载段核验后复用原 FSBL。

本轮未烧录或写启动 SD 卡，也未驱动实际机械手。使用新镜像后先复核八路 raw/processed 数据、通道与特征连续性、LCD/SD 同开时缺口、HDC 学习/切换、NMF、疲劳及复位后的状态，再单独验证机械手。板上结果应与相同佩戴/数据的 V13 对照；不要把不同采集条件下的识别变化归因于资源优化。

## 复现

在仓库根目录执行，日志保存为上述文件名：

```powershell
powershell -ExecutionPolicy Bypass -File build/scripts/run_shared_equiv_test.ps1
& D:/FPGA/VIVADO/2025.2/Vivado/bin/vivado.bat -mode batch -source report/resource_optimization_full_20261027/synth_shared.tcl
powershell -ExecutionPolicy Bypass -File build/scripts/run_shared_netlist_test.ps1
powershell -ExecutionPolicy Bypass -File build/scripts/run_line_filter_sim.ps1 -Python D:/PYTHON/python.exe -Processed
powershell -ExecutionPolicy Bypass -File build/scripts/run_pl_control_test.ps1 -SkipVectors
powershell -ExecutionPolicy Bypass -File build/scripts/run_learning_test.ps1
powershell -ExecutionPolicy Bypass -File build/build_all.ps1 -SkipBoot
& D:/FPGA/VIVADO/2025.2/Vivado/bin/vivado.bat -mode batch -source report/resource_optimization_full_20261027/export_integrated.tcl
powershell -ExecutionPolicy Bypass -File build/scripts/run_shared_netlist_test.ps1 -Integrated
& D:/FPGA/VIVADO/2025.2/Vivado/bin/vivado.bat -mode batch -source report/resource_optimization_full_20261027/audit_candidate.tcl
python report/resource_optimization_full_20261027/compare_resources.py
powershell -ExecutionPolicy Bypass -File build/boot/build_pl_control_boot.ps1
```

需要可用 Python 的 PATH；频响回归明确使用本机具备 SciPy 的 `D:/PYTHON/python.exe`。独立网表仿真、整机网表仿真和布线审查分别保留日志，不用综合估算替代 Routed 数字。
