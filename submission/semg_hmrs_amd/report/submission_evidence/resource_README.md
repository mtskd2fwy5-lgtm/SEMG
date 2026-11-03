# PL 存储与执行通路优化 V15

器件：XC7Z020CLG400-2；工具：Vivado 2025.2；日期：2026-10-27。

本轮承接 V14 的带通与特征共享实现，对 MLP 激活存储、FFT 频带累加状态和六轴 PWM 计数继续优化。模型、滤波参数、FFT 点数、处理接口和更新节拍保持一致。冻结的 V14 源码及哈希位于 `baseline/`；实际功能 RTL 变更为 `emg_nn_infer.v`、`emg_fatigue.v`、`hand_servo_pwm.v`。

## 实现

- MLP 输入和隐藏层激活由复位寄存器阵列改为 LUTRAM，以有效位保留缺失输入及复位的零值语义，隐藏层先写后读；显式复用有符号 8×8 位乘加通路。
- FFT 的 30 个频带累加器组织为六个 bank，每个 bank 五行，每行 51 bit；有效掩码屏蔽历史内容，共享累加及编码选择逻辑。FFT 运算核与输出格式保持一致。
- PWM 使用共享微秒计数和子周期计数，直接比较脉宽，替代六路时钟换算乘法器；按参数缩窄看门狗计数。六轴同帧更新、限幅限速及急停和超时优先级保留。

## 完整设计布局布线结果

| 指标 | V13 | V14 | V15 | 较 V13 |
|---|---:|---:|---:|---:|
| LUT | 36,417 | 25,737 | 23,793 | −34.67% |
| FF | 40,463 | 27,047 | 24,622 | −39.15% |
| Slice | 13,008 | 9,992 | 9,284 | −28.63% |
| Slice 占用 | 97.80% | 75.13% | 69.80% | −28.00 个百分点 |
| BRAM | 45.5 | 45.5 | 45.5 | 保持 |
| DSP | 111 | 55 | 49 | −55.86% |
| 控制集 | 1,326 | 1,215 | 1,058 | −20.21% |
| WNS | +0.229 ns | +0.254 ns | +0.151 ns | 时序收敛 |
| WHS | +0.036 ns | +0.036 ns | +0.028 ns | 时序收敛 |

相对 V14，LUT、FF、DSP 分别再减少 7.55%、8.97%、10.91%。LUTRAM 包含在 LUT 总量中。实际空闲 Slice 为 4,016。完整设计 DRC 无 Error 或 Critical Warning；详细资源、时序和检查项位于 `candidate/`。本轮收益为保持处理性能的资源压缩，未提高工作时钟。

独立模块采用相同综合阶段比较：MLP 为 1,796→1,264 LUT、1,335→423 FF；FFT/疲劳为 3,815→2,346 LUT、2,713→1,214 FF；PWM 为 867→749 LUT、256→244 FF、6→0 DSP。模块数字用于定位收益，整机净收益以上表为准。

## 性能与验证证据

采样率仍为每通道 4 kSPS，窗口为 400 样本，步长 100 样本，特征每 25 ms 更新，PWM 周期 20 ms。逐周期对照要求数据、有效握手和输出周期一致，优化不增加流水延迟。

继承的学习核在 100 MHz、相同输入和指定 AXI 背压测试中的最大周期为：NMF 3,958（39.58 μs）、HDC 尺度更新 782（7.82 μs）、原型更新 23,863（238.63 μs）、六类推理 77,188（771.88 μs）。学习 RTL、模型、平台接口不变，以冻结哈希和上一轮通过证据确认继承。这些是核内仿真耗时，板端端到端响应另测。

- `equivalence.log`：生产权重和随机权重各 32 窗 MLP，覆盖重复/反序特征索引、满幅、背压和中途复位；PWM 的 1/25/3 MHz 参数逐周期比较。
- `fatigue_equivalence.log`：72 窗共 576 词，对 V14 的全部输出及状态逐周期比较。
- `fatigue_regression.log`：相同 576 词与 Python 整数参考一致，覆盖活动、削顶与背压。
- `netlist_test_complete.log`：独立综合网表中的生产 MLP、默认 25 MHz/20 ms PWM，以及 FFT 两个完整窗的 16 词，比较数据和周期并核对整数参考。
- `integrated_test.log`：实际整机模块引用 OOC DCP 导出网表与完整 RTL，在 ADC 解码样本边界注入相同数据，比较 MLP 和 FFT 输出及周期；测试覆盖两轮 FFT 结果和缓存复用，不替代 ADC 引脚级验证。
- `control_regression.log`：28,228 窗策略、384 窗推理、PWM、同帧目标及 DMA 壳回归。
- `final_gates.log`：系数绑定、综合网表系数解析、DSP 常量及 Routed 时序 G1–G4 检查。
- `comparison.log`、`comparison.json`：模型及约束哈希、三处 RTL 变更、同阶段资源、时序、总线偏斜和测试终态核对。

## 复现与镜像

在仓库根目录执行：

```powershell
powershell -ExecutionPolicy Bypass -File build/scripts/run_v15_equiv_test.ps1
powershell -ExecutionPolicy Bypass -File build/scripts/run_v15_fatigue_equiv_test.ps1
powershell -ExecutionPolicy Bypass -File build/scripts/run_v15_netlist_test.ps1
powershell -ExecutionPolicy Bypass -File build/scripts/run_v15_integrated_test.ps1
python report/resource_optimization_v15_20261027/compare_resources.py
powershell -ExecutionPolicy Bypass -File build/boot/build_pl_control_boot.ps1
```

镜像为 `build/boot/BOOT_20261027_HAND_CONTROL_HDC_DYNAMIC_V15.BIN`。`artifacts.json` 保存最终镜像、位流、应用及证据哈希，并核对 BOOT 中 PL、应用和 FSBL 加载段。PS 源文件与已验证版本逐项比较，`main.c` 仅修改版本标识。镜像生成后需在板上复核采集、LCD/SD、学习、协同、疲劳和机械手联动；本轮未执行实板下载或写 SD。

## 报告修订

评审报告保留用户原框架和硬件图片，突出应用、职责划分、在线学习、协同训练、虚实联动与量化优化。测试数据以“独立留出批次”“代表性采集数据”等可理解术语说明，内部数据编号仅保留在工程证据中。

输出位于 `report/design_report_20261027/`，第一部分为两页，第二部分按原结构组织。作者脚本为 `update_report.py`，排版通过文档技能渲染器与本机 Word 转 PDF 完成，再检查每页 PNG；QA 中间文件不作为交付报告。

