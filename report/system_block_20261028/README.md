# 系统总体结构图

适用于《自学习肌电意图解码康复训练系统》的设计报告与答辩。依据 V17 PL 姿态迁移架构绘制，呈现功能和接口关系。

报告正文优先使用 `compact/system_block_compact.png`（或 SVG/PDF），按 16.5 cm × 约 10.2 cm 设计。当前目录为信息更完整的展开版。

- `system_block.png`：4800 × 3264 高清插图。
- `system_block.svg`：保留文字与形状的可编辑矢量图，字体为微软雅黑。
- `system_block.pdf`：单页矢量图，嵌入中文字体，适合打印与缩放。
- `preview.png`：查看用预览。
- `layout_check.json`：文字边界、重叠检查和连线清单。

生成方式：`python tools/draw_system_block.py`。

## 图示规则

PL 内部将滤波后的采样流分送 FFT 与滑窗特征支路，特征供基础动作网络和在线学习/协同支路使用。HDC 与 NMF 核心计算位于 PL；PS 负责学习采样流程、独立验证、HDC 稳定确认及结果使用。NMF 为固定基矩阵下的协同系数求解。

MPU 的 I²C 采集、静止零偏校准、重力校正、四元数融合、三维矩阵与掌部翻转角度均在 PL。PS 接收带序号和状态的原子快照，负责虚拟手绘制和机械手标定映射目标；六路 PWM 及限幅、限速、超时保护在 PL。RGB 显示扫描与 GT911 触摸连接 PL，PS 管理交互与画面。HP0 负责采集 DMA 与显示 VDMA 的 DDR 访问；学习加速核经 HP1 访问输入、原型和结果。PS 同样访问共享 DDR，并经自身外设连接 SD 与隔离串口。

总体图突出分工、数据支路与执行闭环，将 LUTRAM/BRAM 分配、具体保护参数等细节留在对应实现章节。图中连线为功能/接口关系，不作为电路接线图或电气隔离认证。

核对依据：`src/rtl/emg_pl_export.v`、`src/rtl/emg_learning_accel.v`、`src/rtl/hand_control.v`、`src/rtl/hand_servo_pwm.v`、`sw/ps_uart_print/lcd_imu_3d.h`、`sw/ps_uart_print/lcd_hdc.h` 及当前 README 的系统分工。隔离模块沿用用户原图及报告中的电源域分离描述。

紧凑版 PDF 已重新渲染核对。迁移的数值、RTL、综合网表和整机资源证据见 `report/imu_pl_20261028/`；用户原报告 DOCX 未自动覆盖。
