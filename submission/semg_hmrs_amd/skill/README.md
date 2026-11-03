# FPGA 开发可复用技能包

面向 FPGA 的设计、验证、联调、优化与发布。技能按开发任务划分，不要求使用某种传感器、算法、处理器或固定工程目录。肌电 Zynq 工程仅作为历史验证案例，按需读取 `references/case-*`；案例中的器件、地址、参数和业务流程不作为新项目默认值。

## 技能入口

| 技能 | 适用范围与输入 | 使用方法与输出 | 已验证来源/效果 | 失效条件 |
|---|---|---|---|---|
| [fpga-build-release](fpga-build-release/SKILL.md) | 实际构建与参数不一致、定点迁移、资源优化、交付核对；提供器件/工具、源清单、约束、基线及范围 | 按合同检查参考→RTL→实际网表→实现→发布；输出比较、验收与产物清单 | OOC 参数绑定错误促成实际系数检查；历史整机资源优化经周期和网表对照，详见案例 | 厂商原语/工具/接口或初始化变化须重验；历史数值不代表新项目；未验证跨厂商构建 |
| [fpga-stream-validation](fpga-stream-validation/SKILL.md) | FIFO/DMA 丢帧/回放、记录格式或处理级不一致；提供时钟、帧/序号、复位与数据级合同 | 分层完整性和数值对照；可独立审计整数 CSV；输出异常位置、真实合同及排除范围 | 定位过单侧 FIFO 复位导致旧数据回放；脚本验证回绕/缺失/重复/倒退歧义 | 未知帧格式不能猜；无序号或浮点列不直接套整数脚本；不推断物理原因 |
| [fpga-ps-pl-debug](fpga-ps-pl-debug/SKILL.md) | 寄存器应答、CDC 快照、缓存/显示调度、输出状态问题；提供端点/协议和观测 | 数据→接收→目标→输出分层排查；输出首次异常点、修复和验证 | 快照、原子提交、极性与真实固件渲染/调度回归已有案例 | 地址/缓存/电平须按平台重设；host 不能证明实板速度或外设到位；不要求有 LCD/PWM |
| [fpga-design-report](fpga-design-report/SKILL.md) | FPGA 设计评审/报告/竞赛证据；提供实际模板、最新稿、结构和量化证据 | 沿用户框架说明 RTL/HLS、处理器/主机和板级职责；输出报告及证据索引 | 历史指南/职责核对、同口径资源比较与报告组织可追溯 | 换赛道核对规则；未验证评委评分/获奖效果；摘要不等于原始对话 |

[FPGA 开发踩坑清单](pitfalls.md) 汇总 **24 项**，按构建发布、定点迁移、FIFO/DMA、PS/PL、资源性能、推理与证据六组组织。每项给出现象、原因/检查点、排查处理及验证，保留已定位原因与待验证物理推断的区别。

## 拿到目录后如何使用

各技能均提供 `references/task-template.md`，含可填写输入、提示词及验收输出；从任务模板开始即可。

1. 阅读相关 `SKILL.md`，按 reference 输入模板填写自己的工程合同。工程路径相对用户仓库，不相对个人技能安装目录；优先使用自己的已有构建和验证工具。
2. 示例提示词：“使用 `$fpga-build-release`。工程根目录【路径】，器件/工具【版本】，顶层与构建入口【位置】，基线【产物】，改动【范围】。先核对实际构建输入，再验证行为并比较资源/性能；执行范围【用户要求】。”
3. 其他任务替换技能名与所需输入；无需先读应用案例。无 PS、DMA、显示或模型的系统，跳过相应分支，不能为使用技能而引入这些模块。
4. 用 [案例模板](case_template.md) 留下自己的观察、纠错、改动及验证。只在需要了解来源时读 `case-*`；案例是整理摘要，不是完整历史逐字交互。

## 两个独立校验脚本

Python 3 标准库即可运行，可复制相应技能目录，不依赖本仓库固件/模型/原始数据。

### CSV 序号与数值审计

输入 `capture.csv`：

```csv
seq,value0,value1
65535,-5,3
0,8,-2
2,4,1
```

```powershell
python skill/fpga-stream-validation/scripts/audit_stream.py capture.csv --signal-columns value0,value1 --sequence-column seq --counter-bits 16 --output audit.json
```

示例应回绕 1 次、缺号 1 个；输出哈希、极值/均值/AC RMS、重复/倒退歧义等。源文件只读，输出已存在会拒绝。可按真实有符号数据级提供 `--signed-rail-limit`；不自动猜位宽、时间、单位或标签。详见 [输入与边界](fpga-stream-validation/references/analysis.md)。

### 同条件资源/性能比较

```powershell
python skill/fpga-build-release/scripts/compare_resources.py baseline.json candidate.json
```

JSON 结构见 [完整示例](fpga-build-release/references/workflow.md)。要求器件、工具、约束、阶段和工作负载一致，输出差值，不把余量改善自动当提速。该脚本比较导出数值，不解析或认证厂商报告。

## 解压即用的示例与自检

从包根目录执行（只需 Python 3.9 及以上标准库）：

```powershell
python -X utf8 validate_package.py
python fpga-stream-validation/scripts/audit_stream.py examples/stream.csv --signal-columns value0,value1 --sequence-column seq
python fpga-build-release/scripts/compare_resources.py examples/baseline.json examples/candidate.json
```

示例全部为人工构造的通用输入，不是实际板卡测量。CSV 应回绕 1 次、缺号 1 个；资源示例 LUT 100→70（-30%）、延迟保持 400 周期。输出到 stdout，不覆盖输入。

`validate_package.py` 核对四个入口名称/描述、全部本地 Markdown 链接与 Python 语法，运行工具回归；它不是完整 YAML 校验器。发布前另外使用 skill-creator 的官方格式检查。自检不需要原工程目录、私有数据、工具链或网络。

## 交付与验证范围

仓库 `skill/` 是交付源，另提供可分发 ZIP。四个 `fpga-*` 目录可分别复制到个人 Codex `skills/`，用相应 `$fpga-*` 名称调用；其他智能体或人工可直接使用模板和脚本，不要求 Codex。

本包包含四项技能、四份任务模板、24 项踩坑清单、两份核对表、一个案例模板、两个校验工具、三份示例数据和包自检。通用工作流不依赖具体应用。案例只保留“观察→方法→验证结果→失效条件”，原工程证据路径以代码文本说明来源，哈希见 [evidence_sources.json](evidence_sources.json)；独立包不包含庞大构建日志、原始波形、模型或原始协作对话。

已验证：工具异常/边界/CLI、自检、源码与安装/压缩包的一致性，并在临时解压目录运行。尚未开展陌生队伍/新代理端到端复用或跨板卡/跨厂商完整构建；方法写成可迁移不代表这些测试已完成。历史资源和数值结果按各案例范围引用，不代表新工程收益。

补充：[发布核对表](checklist.md)、[数据路径核对表](data_path_checklist.md)、[案例模板](case_template.md)。完整协作原文须另行真实导出和脱敏，不能由案例摘要代替。

