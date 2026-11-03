---
name: fpga-ps-pl-debug
description: Debug FPGA-to-processor integration involving register protocols, DMA/cache ownership, CDC snapshots, firmware scheduling, framebuffer displays and output state machines. Use for stale data, mixed snapshots, stalled UI or reset/enable/ACK mismatches; adapt to the actual SoC or host interface.
---

# FPGA 与处理器联调排障

先区分源数据、PL 结果、处理器接收、显示、目标下发与外部输出，逐层寻找首次不一致。PS/PL 是常见划分；纯 FPGA、软核或 PC 主机系统按实际端点替换，不能要求存在 Zynq 或 LCD。

获取：硬件/固件版本、地址/数据位宽/字节序、命令-应答合同、时钟/复位域、缓冲/缓存、轮询或中断、状态/错误及触发条件。优先读现有源码与日志；已有安全使能条件不因调试而自动绕过。

首次复用可填写 [任务与验收模板](references/task-template.md)，按端点逐层收集观察。

- 旧值、混帧、无输出、复位/使能不同步：读 [寄存器、CDC 与控制状态](references/control.md)。核对原子快照/提交、代次、ACK、过期与失效处理。
- 界面卡顿、触摸、像素或刷新错误：系统含 framebuffer 显示时读 [显示和主循环调度](references/lcd.md)。使用真实固件的 host 测试或板端观测，不另画相似界面替代验证。

按影响测试：正常路径之外覆盖重复/超时、断流、配置切换、复位与回绕；保持生产分支，不用软件回退冒充硬件正确。硬件输出测量需分内部逻辑、引脚、电平转换和负载行为；无反馈时不宣称外部设备已到位。

输出最早异常层、代码/日志证据、修复与验证、版本依赖和剩余不确定项。host 时间不作处理器性能，命令成功不作物理闭环成功。显示和执行器不是所有 FPGA 工程的必需模块。

可选来源案例：[原子控制](references/case-atomic-control.md)、[显示调度](references/case-ui-scheduling.md)。其中轴数、PWM、显示尺寸、页面生命周期仅是历史工程选择。

