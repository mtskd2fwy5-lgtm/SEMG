---
name: fpga-stream-validation
description: Validate FPGA acquisition, DSP and DMA streams for framing, loss, replay, reset, signedness and processing-stage consistency. Use for FIFO/DMA recording faults or reference-versus-stream mismatches; includes a standalone integer-CSV sequence audit, independent of application domain.
---

# FPGA 流式数据完整性与处理链验证

先获取实际输入合同：采样/时钟、帧/通道、位宽与字节序、序号/时间戳含义、ready/valid 或其他握手、复位域、FIFO 深度、DMA/缓存与记录格式。无处理器工程跳过软件侧，无序号则使用现有帧标志/测试模式，不补造真值。

首次复用可填写 [任务与验收模板](references/task-template.md)，再选择相应验证分支。

1. 保留原数据与哈希，检查帧长、头尾、序号回绕/缺失/重复/倒退；区分记录顺序和真实采样时间。损坏区间单独标注，不静默删除后声称流连续。
2. 从源→FIFO/CDC→DMA/缓存→解析→文件分层定位。整块重复优先核对缓冲长度、所有权与复位协调，不直接认定采样源异常。
3. 明确 raw、各级处理后数据、包络/特征和推理结果的合同；文件名不证明真实链路。对齐采样/通道/状态后与参考比较，避免重复滤波或错缩放。
4. 按需注入已知计数/斜坡/冲激/正负边界，验证背压、跨块、复位、故障恢复与缺帧。原有有效数据路径优先复用。

详细输入模板、分层定位及脚本示例见 [流式验证流程](references/analysis.md)。使用数据驱动推理时，另读 [数据与模型合同](references/models.md)，区分实现等价、离线探索与泛化验证。

`scripts/audit_stream.py` 仅需 Python 标准库，适用于带无符号序号和整数列的 CSV。没有相应列或单位为浮点时先确认格式，不强行取整迁就脚本。输出异常位置/计数及数值统计；不推断业务标签或物理单位。

交付：完整性结论、异常位置、证据、真实处理合同、可复现检查及不能恢复的数据。应用特定经验仅在需要时读 [采集案例](references/case-stream-replay.md) 或 [模型案例](references/case-model-contract.md)，不要求提供肌电条件才能使用本技能。

