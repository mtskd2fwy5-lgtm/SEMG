# 提交内容清单

本目录由 `tools/assemble_submission.ps1` 从工程工作区选取内容生成，用于提交源码与工程资料。顶层 README 和本清单保留为提交说明；板卡、数据及构建脚本 README 与工程中的对应说明同步维护。

## 已包含

- PL RTL、PS 裸机固件、HDL/C/Python 测试源码以及 Python/PowerShell 辅助工具。
- Vivado 块设计、配套 IP 的 XCI 配置和板级引脚、时序约束。
- `data/models/nn_int8/`、`data/models/hdc_memory.mem`、`data/models/model_params.mat` 等选定模型资料，以及选定评估指标；具体以目录文件为准。
- 四类通用 FPGA 开发技能：构建与发布、数据流验证、PS/PL 联调和设计报告；附模板、踩坑清单及独立工具。
- 设计报告、AMD 指南核对表、AI 协作记录，以及选定的资源优化和 HDMI 实现验证资料。

项目简介和复现步骤见 [README.md](README.md)。选定模型资料不等于全部生产构建或测试依赖，运行前须检查实际引用的初始化文件。

## 目录与用途

| 目录或文件 | 内容与用途 |
| --- | --- |
| [src/rtl/](src/rtl/) | 采集、DSP、学习推理、姿态解算、机械手 PWM 和显示输出 RTL |
| [sw/ps_uart_print/](sw/ps_uart_print/) | PS 裸机应用、LCD 交互、训练任务、模型与 SD 管理 |
| [board/](board/README.md) | 板卡接线说明和引脚、时序约束 |
| [build/](build/) | Vivado 块设计、IP 配置、工程构建与 BOOT 打包脚本 |
| [build/scripts/](build/scripts/README.md) | 模块回归、网表检查和工程维护脚本 |
| [sim/](sim/) | HDL 测试平台、C/Python 参考与固件测试源码 |
| [tools/](tools/) | 串口记录、BIN 解码、数据分析、模型转换及发布检查 |
| [data/](data/README.md) | 选定模型参数、存储器初始化文件与评估指标 |
| [skill/](skill/README.md) | 通用 FPGA 开发技能、模板、踩坑清单和独立检查工具 |
| [report/](report/) | 设计报告、指南核对表、AI 协作记录及选定验证证据 |

## 提交要求索引

| 内容 | 对应位置 |
| --- | --- |
| 项目简介与复现步骤 | [README.md](README.md) |
| 源码、板级工程及配置 | `src/`、`sw/`、`board/`、`build/` |
| 仿真与参考对照 | `sim/`、`tools/`、`report/submission_evidence/` |
| 模型与评估资料 | `data/` |
| 可复用技能 | `skill/` |
| 可编辑设计报告 | [design_report.docx](report/design_report/design_report.docx) |
| 设计报告 PDF | [报告.pdf](report/报告.pdf) |
| 指南核对 | [competition_checklist.md](report/competition_checklist.md) |
| AI 协作记录 | [submission_guide_review.md](report/ai_collaboration_20261103/submission_guide_review.md) |

## 未包含

- `.Xil`、Vivado/Vitis 本机工作区、编译缓存和临时文件。
- 生成的 DCP、XSA、位流、ELF 和 BOOT 启动镜像。
- 原始人体肌电录制、大量导出波形，以及选定证据之外的本机日志。

## 使用与核对

使用时应匹配说明中的器件、工具版本、板卡接线和第三方许可。本包保留构建入口与选定证据，未完成新环境下的全链路复现；部分脚本需本机环境配置。主机、行为仿真、综合网表、布局布线和实板结果分别解释，不能相互替代。

发布 ZIP 的 SHA256 记录在同名 `.sha256` 文件中，用于核对下载或复制后的文件完整性；历史验证报告中的哈希继续对应历史输入，不随说明翻译而改写。
