# sEMG 手部运动重建与康复训练系统

## 1. 项目目标

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

`sEMG/电极 -> ADS1299 采样 -> PL 预处理 -> 特征提取 -> INT8 推理 / FFT 疲劳 -> AXI-Stream 合流 -> DMA -> PS 解析 -> UART/上位机 -> 虚拟手重建与显示`

当前阶段（2026-09-21）：PL 全链路（采集、预处理、特征、INT8 NN 推理、FFT 疲劳监测多路并行，时分复用：FFT 单核轮服 8 通道占空 10%，NN 占空 <0.2%）已实现，经异步 FIFO 合流为 64-bit AXI-Stream（包 type：1=raw / 2=feature / 3=NN 结果 / 4=fatigue）进 DMA；PS 裸机固件解析全部包类型并经 UART0（115200）输出。ADC 挪脚（J4/bank13）与 `emg_nn_infer` argmax 多驱动修复后重综合通过、0 critical warning，待跑实现出位流并改线板测。板级已实测 raw/feature/NN 链路，疲劳链路板测待做。数据通路约定见 `report/pl_ps_data_path.md`。

### 4.2 功能模块

- 采集模块：SPI 驱动 ADS1299，读取 24 位多通道生物电帧
- 预处理模块：去直流、带通滤波、整流、包络提取
- 特征模块：MAV、WL、Energy、ZC、SSC 窗口特征（与 PC 参考模型逐位一致）
- 推理模块：INT8 MLP（`emg_nn_infer.v`，16-MAC 时分复用阵列，56µs/窗 @100MHz），权重 1377 字 BRAM，与 PC 金模型逐位一致；LoSo 跨被试准确率 84.9%；后续可升级 1D-CNN / TCN
- 疲劳模块：8 通道分时复用 2048 点 radix-2 FFT（`emg_fatigue.v`，自写 RTL 避开 Xilinx FFT IP），512ms 窗计算 MDF 均值，16 点历史线性回归斜率输出三级疲劳指数（正常/轻度/疲劳）
- 判决与校准模块（PS，`sw/ps_uart_print/main.c`）：上电自动静息校准（丢弃 ~2s 后平均 16 个特征窗的每通道 MAV 得基线，动作阈值 = max(3×基线, 下限)），NN 判非 rest 但当前窗 8 通道 MAV 全部低于阈值时改判 rest（R 行附 g=1 标志）；UART 收 `c` 触发重校准；R 行附指示性置信度 p（定点近似 softmax）
- 数据采集模式（运行时可切，无需重编）：UART 发 `r` 在监控模式（115200 文本行）与采集模式（2 Mbaud 二进制帧 `AA 55 | seq u16 | 8×int24`，28 B/帧）间切换；采集模式不打印任何文本保证帧流干净，切回监控自动重做静息校准。PC 端配套 `tools/record_uart.py`（`--enter` 自动两段式入采、`m` 命令切回），用于板卡自采数据集（NinaPro 契约 CSV）
- 重建模块：把模型输出映射为离散手部姿态（rest/张开/握拳/腕屈/伸腕）+ 平滑插值的低维参数
- 显示模块：PC 端虚拟手 `tools/virtual_hand.py`（pygame，串口解析 R/T 行，~350ms 姿态插值，低置信度回退 rest，腕部按疲劳等级黄/红变色，`--demo` 离板演示）；板载屏显示以厂商 lcd_demo 为起点待做（ADC 已让出 bank34 LCD 总线）

## 5. 最小可交付版本

第一版不要追求“全手所有关节的精确连续重建”，先做一个可稳定演示的闭环：

- 8 通道输入（已实现，超出原定 4 通道）
- 5 类基础动作：rest/张开/握拳/腕屈/腕伸（已实现）
- 100ms 滑动窗口（已实现）
- 25ms 步长（已实现）
- 输出动作类别 + 置信度 + 低维手部姿态参数（已实现：R 行携带类别 + 指示性置信度；PC 虚拟手按离散姿态 + 350ms 插值驱动）

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

状态：4 kSPS 重设计完成，特征与 PC 参考模型逐位一致（`tools/emg_reference.py` compare-export 回归全绿）。

### Phase 3：模型训练与部署

- 先在 PC 端训练 baseline
- 再做 INT8 量化或轻量化模型
- 明确哪些逻辑放在 PL，哪些放在 PS

状态：INT8 MLP 已部署 PL（`tools/export_int8.py` 生成权重 → `emg_nn_infer.v` 推理，仿真与 Python 位精确模拟器逐值一致，时延 56µs）。

### Phase 4：手部重建

- 将模型输出映射成手指/腕部低维参数
- 做虚拟手模型驱动
- 加入个体化校准

状态：方案已定——分类驱动离散姿态 + 平滑插值（决策依据：干电极 SNR 不足以支持连续角度回归）。已实现：个体化静息校准 + rest 门控（PS 固件，`c` 命令重校准）；PC 端虚拟手 `tools/virtual_hand.py`（姿态插值 + 疲劳变色，`--demo` 可离板演示）。待做：板载屏虚拟手（起点：厂商 lcd_demo DRM/KMS 例程）。

### Phase 5：展示与文档

- 做实时展示界面
- 输出资源占用、时序、延迟、准确率
- 整理可复现脚本和实验记录

状态：FFT 疲劳管线（FFT-MDF）已入 PL 并通过 56 词位精确仿真；工程检查单见 `report/competition_checklist.md`、`skill/checklist.md`。正式报告未开始，评分硬指标待补（基线对比表、干净目录复现验证）。

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
│   └── attic/               # 已废弃/一次性修复脚本存档（勿用于现行流程）
├── board/                   # 板级约束与接线文档
│   ├── constraints/         # hz_zynq_ads1299*.xdc（ADC @ J4-17..24, bank13）+ 时钟约束
│   └── README.md            # ADS1299 接线对照表与改线注意点
├── data/                    # 数据集、模型与指标
│   ├── raw/                 # NinaPro DB5（脚本再生成，不入库）
│   ├── models/              # baseline MLP、INT8 权重、疲劳 twiddle/测试向量
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
    ├── signal_chain_spec.md / pl_ps_data_path.md / engineering_notes.md
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

1. 跑实现出位流 → 重导 XSA → 按 `board/README.md` 接线表把 ADC 八线改焊到 J4-17..24 → 复测 raw/feature/NN 链路 + 疲劳 T 行板测（bit 记得从 impl_1 拷贝覆盖 `dbg_test_k` 静态副本）
2. 模式切换全流程板测：`python tools/record_uart.py --port COM3 --enter` 进采集 → 打标采集 → `m` 回监控自动重校准
3. 补竞赛硬指标：基线对比表（PC 浮点 vs PL INT8 的准确率/时延/资源）、干净目录从零复现验证；板载虚拟手显示以厂商 lcd_demo DRM/KMS 例程为起点，10 月评估 PYNQ 融合路线

这个顺序最稳，也最符合竞赛评审对“完整性、可复现性、技术含量”的期待
