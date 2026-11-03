# 自学习肌电意图解码康复训练系统

## 项目简介

本项目面向上肢康复训练与肌电人机交互，基于 AMD Zynq-7000 XC7Z020 构建集肌电采集、意图解码、个体化学习、虚实手联动与训练反馈于一体的板端系统。通过 ADS1299 采集八通道表面肌电，由 FPGA 完成实时信号处理与边缘计算，ARM 负责触摸交互、数据管理和康复训练流程。

系统支持常见动作识别和自定义手势学习，通过虚拟三维手与六轴机械手展示识别结果；利用肌肉协同反馈相对用力变化，辅助完成单动作、组合动作和抓握强度训练。触控 RGB LCD 为主要交互平台，HDMI 可将同一界面同步展示到外接屏幕。

## 主要功能与系统分工

- **采集与分析**：八通道同步采集，工频及谐波抑制，滤波波形、频谱、中值频率、通道质量和疲劳趋势显示。
- **识别与自学习**：MLP 识别放松、张手、握拳、屈腕和伸腕；HDC 支持板上学习、独立验证、自定义手势命名及 SD 模型保存与切换。
- **虚实手联动**：自定义虚拟手关节映射和机械手动作映射，MPU 相对姿态控制整体方向与掌部旋转，六路 PWM 驱动五指与掌部。
- **康复训练**：单动作与组合任务，次数、保持及休息时间设置，完成率、响应和稳定性反馈；NMF 肌肉协同参与相对用力反馈与连续抓握控制。
- **数据记录与展示**：SD 同步记录原始和最终滤后波形、动作标注及训练结果，支持 PC 导出分析；LCD 与 HDMI 镜像展示。

| 部分 | 职责 |
| --- | --- |
| PL（FPGA） | ADS1299 SPI、工频及谐波滤波、滑窗特征、FFT 与疲劳分析、MLP 推理、HDC 编码/学习/推理、NMF 系数求解、MPU 姿态融合和六路 PWM 输出保护 |
| PS（ARM 裸机） | 校准及佩戴适配流程、学习引导与稳定判决、模型与 SD 文件管理、LCD 触摸和虚拟手绘制、数据分析、康复任务及映射目标管理 |
| 显示与执行 | LCD 提供触摸交互；HDMI 镜像同一帧缓冲；PS 提交机械手目标，由 PL 输出 PWM |

HDMI 固定输出 1280×720、60 Hz，视频扫描频率与界面重绘帧率不同。肌肉协同反馈相对激活程度，不等同于机械手实际握力测量；疲劳趋势用于科研与训练反馈。

## 工程目录

| 目录 | 主要内容 |
| --- | --- |
| [src/rtl/](src/rtl/) | PL 源码：采集、滤波、特征、频谱、学习推理、姿态解算、机械手 PWM 与 HDMI |
| [sw/ps_uart_print/](sw/ps_uart_print/) | PS 裸机固件：LCD 交互、模型管理、康复任务及 SD 记录 |
| [board/](board/README.md) | 板卡接线、引脚分配与时序约束 |
| [build/](build/scripts/README.md) | Vivado 块设计、IP 配置、构建、验证及 BOOT 打包脚本 |
| [sim/](sim/) | HDL 测试平台、参考模型和固件测试代码 |
| [tools/](tools/) | 数据记录与分析、BIN 转 CSV、模型转换和发布检查工具 |
| [data/](data/README.md) | 模型参数、初始化文件、评估指标及数据格式说明 |
| [skill/](skill/README.md) | 通用 FPGA 开发技能、模板与踩坑清单 |
| [report/](report/) | 设计报告、测试证据、资源性能对比与阶段记录 |

## 复现环境

| 类别 | 配置 |
| --- | --- |
| 主控板 | HZ-ZYNQ_MV01 底板及 HZ-ZYNQ_CV01 核心板，器件 `xc7z020clg400-2` |
| 采集与姿态 | ADS1299 八通道采集模块、MPU6050 |
| 交互与存储 | ATK-4384 触控 RGB LCD、FAT32 启动 SD 卡；HDMI 显示设备可选 |
| 机械手 | 五指加掌部旋转共六轴，独立舵机电源；当前 FPGA PWM 适配后级反相光耦 |
| 开发工具 | Windows、Vivado/Vitis 2025.2，安装 Zynq-7000 器件支持及 ARM 裸机工具链 |
| 辅助工具 | Git、Python 3；数据分析工具按需使用 NumPy、SciPy、Matplotlib 等；固件主机测试使用 MSVC C 编译器 |

接线及电平要求见[板卡说明](board/README.md)。人体采集须核对供电和所有外接链路的隔离条件，HDMI 也属于外接电气链路。

## 复现步骤

### 1. 获取源码并配置工具

推荐使用完整仓库复现。若从提交 ZIP 解压，先进入其中的 `semg_hmrs_amd/` 目录；当前精简包未包含生产 MLP 的 `nn_int8_board_multiwear/` 和 FFT 的 `fatigue/twiddle2048.mem`，须从同一仓库修订补齐后再构建。其他内容范围见 [MANIFEST.md](MANIFEST.md)。

获取完整仓库后进入工程目录：

```powershell
git clone https://github.com/mtskd2fwy5-lgtm/SEMG.git
cd SEMG
```

将以下安装目录替换为本机实际路径。该目录应包含 `Vivado/`、`Vitis/`、`gnu/` 和 `data/`：

```powershell
$env:AMD_VIVADO_ROOT = 'C:\AMD\2025.2'
$env:Path = "$env:AMD_VIVADO_ROOT\Vivado\bin;$env:AMD_VIVADO_ROOT\Vitis\bin;$env:Path"
```

当前生产链需要以下初始化文件，须保留原有相对路径：

- `data/models/nn_int8_board_multiwear/nn_int8_weights.mem`：MLP 权重与量化参数初始化。
- `data/models/fatigue/twiddle2048.mem`：2048 点 FFT 旋转因子。
- `data/models/hdc_memory.mem`：学习加速器初始化内容。

### 2. 创建 Vivado 工程

新工作区使用保存的块设计、IP 配置和 RTL 创建完整系统工程：

```powershell
vivado -mode batch -source build/recreate_project.tcl
```

预期工程为 `build/vivado/hand_motion_reconstruction.xpr`，顶层为 `design_1`。已有工程使用下列命令同步源码和约束，不重复创建：

```powershell
vivado -mode batch -source build/update_project.tcl
```

首次创建后检查块设计连接、IP 状态与初始化文件引用；综合工作目录下也必须能解析初始化文件路径。`build/create_project.tcl` 是独立 `hand_motion_top` 测试入口，不是完整 PS/PL 系统的创建入口。

### 3. 综合实现并导出硬件

```powershell
powershell -ExecutionPolicy Bypass -File build/build_all.ps1 -SkipBoot
```

此命令执行 Vivado 构建及硬件检查，暂不生成启动镜像。主要输出为：

- `build/vivado/hand_motion_reconstruction.runs/impl_1/design_1.bit`：PL 位流。
- `build/export/design_1.xsa`：包含位流的硬件平台描述。
- 实现目录中的时序、资源及设计规则报告。

检查参数绑定、网表系数和布线时序结果，确认检查通过后再继续。`-SkipBuild` 仅用于复用已有硬件产物，不用于首次构建。

### 4. 建立 Vitis 平台和 FSBL

在 Vitis 中将 `build/vitis_ws` 设为工作区，以 `build/export/design_1.xsa` 创建名为 `platform` 的平台组件，选择 Cortex-A9 的 `ps7_cortexa9_0` 与 `standalone` 裸机环境，生成并构建 Zynq FSBL。确认输出位置与 BOOT 配置一致：

```text
build/vitis_ws/platform/export/platform/sw/boot/fsbl.elf
```

平台已存在、仅更新 XSA 时使用：

```powershell
vitis -s build/scripts/update_learning_platform.py
```

该脚本更新已有平台，不负责从空工作区创建平台。FSBL 必须与本次 XSA 对应的 PS、DDR 及外设初始化一致。

### 5. 编译固件并生成 BOOT

可先单独编译生产 PS 应用：

```powershell
cmd /c "cd sw/ps_uart_print && build.bat --pl-control"
```

输出为 `sw/ps_uart_print/ps_uart_print_pl_control.elf`。按下方验证说明完成对应回归与发布证据后，再执行匹配启动镜像打包：

```powershell
powershell -ExecutionPolicy Bypass -File build/boot/build_pl_control_boot.ps1
```

打包脚本会复核硬件、编译生产固件，并按 `build/boot/boot_image_pl_control.bif` 组合 **FSBL、位流和生产 ELF**；启动镜像输出到 `build/boot/BOOT_<构建标识>.BIN`。应以脚本成功输出和产物校验结果为准，不混用其他硬件构建的 FSBL 或应用。

### 6. 写卡启动与板端操作

将本次成功生成的镜像复制到 FAT32 启动卡根目录，命名为 `BOOT.BIN`。设置开发板为 SD 启动，断电插卡后上电：

1. 检查 LCD 显示、触摸、八通道数据与 MPU 状态，完成静息及姿态校准。MPU 将本次校准姿态作为相对零位。
2. 在通道质量页检查接触和滤后信号，按需完成佩戴适配。
3. 使用 MLP 基础识别，或进入 HDC 自学习采样并独立验证；学习后的模型可另存到 SD，后续可加载切换。
4. 配置虚拟手映射。机械手先完成各轴标定及动作映射，再明确启用联动；标定会实时驱动实际机械手。
5. 选择康复任务并设置次数、保持和休息时间。使用协同抓握前先记录本次佩戴的舒适抓握参考。
6. 需要数据时在 LCD 开启 SD 录制并标注动作，结束后先停止保存，再取卡。HDMI 显示设备连接底板 J17，触摸操作仍在 LCD 上进行。

### 7. 导出录制数据

```powershell
python tools/decode_sd_record.py path/to/EMG000.BIN --outdir output/emg000
```

导出八通道原始 CSV、对应滤后 CSV 和完整性元数据。滤后阶段以文件头为准，当前最终带通输出为 `processed`，不应与旧单陷波文件混淆。格式见[数据说明](data/README.md)。

## 验证说明

常用回归入口如下，更多前提和用途见[脚本说明](build/scripts/README.md)：

```powershell
powershell -ExecutionPolicy Bypass -File build/scripts/run_hdmi_test.ps1
powershell -ExecutionPolicy Bypass -File build/scripts/run_hdmi_pipeline_test.ps1
powershell -ExecutionPolicy Bypass -File build/scripts/run_hdc_model_test.ps1
python skill/validate_package.py
```

HDMI 集成仿真需要先生成 Video Out IP 的仿真文件；固件主机测试需将脚本中的 MSVC 初始化路径配置为本机路径。匹配 BOOT 的发布检查还依赖该构建的网表、硬件审计、回归日志和输入哈希，不能只复制历史日志来满足检查。

HDMI 的完整验证顺序、生成物和实板检查项目见 [HDMI 同步展示说明](report/submission_evidence/README.md)。选入的历史证据用于追溯对应构建，复现时应生成本次输入对应的证据。

上述流程依据现有脚本和构建资料整理，本轮未执行干净环境从源码到 BOOT 的完整重建；首次移植仍需核对工具路径、初始化文件解析和平台输出。行为仿真、综合网表、布线结果与实板运行分别验收。

## 资料与许可

- [设计报告](report/design_report/design_report.docx)
- [FPGA 开发技能包](skill/README.md)
- [提交内容清单与目录用途](MANIFEST.md)
- [AMD 指南核对表](report/competition_checklist.md)

原创代码、工具、模型资产及原创文档采用 [Apache-2.0](LICENSE)，允许使用、修改及商业再分发，并须保留适用声明。第三方字体、AMD 工具与厂商 IP 沿用各自许可，见 [NOTICE](NOTICE) 和[第三方声明](THIRD_PARTY_NOTICES.md)。
