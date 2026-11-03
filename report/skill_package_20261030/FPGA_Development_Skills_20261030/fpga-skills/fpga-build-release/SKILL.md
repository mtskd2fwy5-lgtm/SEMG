---
name: fpga-build-release
description: Validate FPGA builds, fixed-point RTL migrations, resource/performance optimizations and release artifact consistency. Use when simulation and implementation disagree, comparing candidate designs or packaging a reproducible release; supports vendor-neutral workflows with an optional AMD Zynq adapter.
---

# FPGA 构建、等价验证与发布

先识别用户实际工程：厂商/器件、工具版本、顶层、源清单、参数/IP/约束、参考模型、构建入口和交付格式。不要预设工程目录、处理器、算法、通道数或板卡；已有脚本优先。只分析已有报告时，不启动整套综合实现。

首次复用可填写 [任务与验收模板](references/task-template.md)，不要求另造工程目录或接口。

- 构建/发布：读 [构建与产物核对](references/workflow.md)。检查实际参与构建的源码、参数、IP 和内存初始化，区分源码、综合网表、布线结果与已运行镜像。
- 数值迁移/资源优化：读 [数值与时序等价](references/equivalence.md)。先明确位宽/符号、量化、舍入、饱和、状态和握手，再选参考、RTL、网表与集成验证。优化结果按行为、吞吐、延迟、资源和时序同时评估。
- 资源差值可直接运行 `scripts/compare_resources.py`；JSON 合同和示例在 workflow。该工具不依赖工程，不代替原始实现报告。

按本次改动选择验证范围；保存基线与已有未提交工作。软件改动只有在硬件输入、接口及初始化合同均不变且有证据时才复用硬件产物。生成物和日志需绑定实际输入；失败先定位，不删除断言或修改期望来放行错误结果。

输出：改动及原因、验证命令与结果、同口径资源/性能比较、匹配的交付产物/哈希及未覆盖项。仿真周期、静态时序、实板延迟分开。打包、下载和板端验证分开陈述，执行范围以用户请求为准。

来源与适用边界：方法来自实际 FPGA 参数绑定、定点迁移及优化案例；特定工程的历史证据仅在需要时读 [构建案例](references/case-build-parameters.md) 与 [迁移案例](references/case-numeric-migration.md)。案例器件/地址/数字不作为新工程默认值。尚未验证跨厂商完整构建。
