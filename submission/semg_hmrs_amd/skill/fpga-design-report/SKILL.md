---
name: fpga-design-report
description: Write evidence-based FPGA design reports and architecture diagrams with clear RTL/HLS, processor, host and board responsibilities, comparable resource/performance results and reproducible build instructions. Use for reviews or competitions; verify the actual template and rules rather than assuming an application domain.
---

# FPGA 设计报告与验证证据组织

输入：读者/用途、实际模板/规则、用户最新稿、目标器件/工具、实现结构和验证证据。先核对，不预设 AMD 赛道、Zynq、PYNQ 或具体应用；保留用户框架和文风。

首次复用可填写 [任务与验收模板](references/task-template.md)，缺少内容先查实际工程与材料。

按数据/控制路径说明输入输出、RTL/HLS 模块、处理器/主机、板级接口及边界。FPGA 算法逻辑属于硬件实现；处理器调度、配置与显示不应混成同一种“软件算法”。接口要说明传什么、何时传、谁拥有和失效怎么办，避免只有箭头没有语义。

围绕问题、实现选择和可复核结果展开，详见 [报告提纲与量化模板](references/report.md)。资源比较注明器件/工具/约束/阶段，时延说明起止点和统计方法；不把仿真周期当实板响应，也不把数值等价当应用准确率提升。

若使用 AMD FPGA 自主选题赛道，可选用[赛道报告结构模板](references/amd-autonomous-track-report-template.md)。它参考本工程采用的五部分竞赛报告框架，用于组织章节与证据，不是所有 FPGA 报告的默认格式；动笔前仍须核对当届指南和用户提供的模板。

输出面向读者，省略内部数据代号与冗长调试历史，保留支持结论所需的方法和范围；证据索引另列。优点用实测或已验证结果支撑，不虚构应用效果或获奖验证。文档导出时使用可用的格式工具并检查最终版面。

协作材料分原始可见交互、整理案例和工具证据。无原文不补写历史逐字对话；不输出系统指令、内部推理或凭据。规则随赛道变化，不把历史评分表当通用要求。

方法来源及历史指南示例见 [项目报告案例](references/case-report-evidence.md)，仅在相应赛道/案例需要时读取。该技能验证的是事实组织与复现方法，未证明评委评分效果。
