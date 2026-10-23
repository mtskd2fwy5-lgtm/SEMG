# LCD、MPU 与触摸优化记录

> 此为当日较早的二维版本记录。当前三维实现、GT911 坐标起点修复、测试和镜像散列以 [lcd_3d_touch_20261014.md](lcd_3d_touch_20261014.md) 为准。

日期：2026-10-14。用户确认：ATK-4384，800×480，MPU 固定在前臂。
固件标识：`20261014_LCD_RESPONSIVE`。

本次已完成代码修复、主机回归、引脚级 I2C RTL 仿真、完整 Vivado 构建及本地启动镜像打包。尚未上板验证，未测量实机帧率或端到端运动延迟。

## 发现与修复

| 用户现象 | 代码中确认的问题 | 本次改动 |
|---|---|---|
| MPU 响应小、不灵敏 | 传感器输出单位为 0.1°，显示映射却除以 100；配置写事务跳过寄存器地址；CORDIC 输入顺序不符合 atan2；整数滤波丢失小陀螺步进 | 映射改为除以 10；修复配置 FSM；修正 roll/pitch 计算；滤波内部保留 Q8 小数；采样开始间隔为 10 ms |
| 手掌固定、手指错位 | 手掌矩形没有随骨架变换；屈曲和外展共同当作平面旋转，屈指时整体偏向右侧 | 手掌改为可变换的圆角形状；前臂绕肘、腕姿绕腕；手掌和各指共享变换；屈曲改变投影长度，外展控制横向方向 |
| 撕裂、残影 | 仅保护请求的 park 帧不能保护仍在扫描的旧帧；绘制中的可变字符串和局部清屏可能留下不一致内容 | 三帧缓冲同时排除实际扫描帧与已请求帧；完整清理运动区域；绘制列表保存文字副本；完成并清理缓存后再请求换帧 |
| 偶发卡住、持续运动不刷新 | 输入变化可使在途绘制反复重启；原时间片依赖 DMA 等待起点，长期没有 TLAST 时预算失效；无缓存 DDR 绘制成本高 | 在途帧完成，新输入只覆盖待绘制状态；每次使用新的 2 ms 工作预算；检查 DMA 完成后及时返回；APP/显示区启用 L1 缓存，EMG DMA 区保持非缓存 |
| 触摸按键无效或只能点一次 | GT911 坐标高字节被误当作 FT5x06 事件位；零触点状态没有发布抬起；菜单只变标签 | 按 GT911 状态触点数发布按下/抬起；错误和复位清除按下；菜单通过主循环调用已有模式切换、静息校准、MPU 校准路径 |

另补齐“劳”字字形，修正置信度条满格宽度，增加完成帧、待绘制、合并更新、绘制列表溢出计数。

## 实现范围

- 保留现有裸机 PS、PL I2C 前端、VDMA 和姿态契约。没有修改分类模型、分类数据或 PoseFrame 格式。
- 保留任务开始前已有的 BD/VDMA/video-out 改动及 SOF repair 删除；这些不是本次新引入的改动。
- 前臂 roll/pitch 使用现有轴分配和方向常量。用户尚未提供模块丝印轴的朝向，因此实机方向仍需核对。
- 前臂显示为二维投影：一个倾角控制绕肘旋转，另一个控制上下位移。单个 MPU 的倾角不能直接测出肘部空间位置。
- 2 ms 是每次绘制调用的目标预算，在图元和缓存批次之间检查时间与 DMA 状态；并非已实测的硬性最坏阻塞上限。新场景构建间隔至少 20 ms，也不是实际 50 FPS 的测量结果。
- framebuffer 的 L1 缓存逐行清理并使用 DSB 后提交；映射为 inner write-back / outer noncacheable。EMG DMA 内存保持 noncacheable。硬件缓存行为仍需实机验证。

## 验证结果

| 验证 | 命令/证据 | 结果 |
|---|---|---|
| ARM 固件编译 | `sw/ps_uart_print/build.bat` | `BUILD OK`，无编译错误 |
| 实际 C 渲染与输入回归 | `build/scripts/run_lcd_firmware_test.ps1`；`sim/results_lcd/firmware_test.log` | `TEST_PASS LCD` |
| MPU、GT911 引脚级 I2C 仿真 | `build/scripts/run_lcd_input_sim.bat`；`sim/results_lcd_input/simulate.log` | `TEST_PASS LCD_INPUT`，正常结束，无 fatal/timeout |
| Vivado 2025.2 完整综合、布局布线、bitstream | `build/build_all.ps1 -SkipBoot`；`build/check_design.log` | `CHECK COMPLETE`；G1–G4 PASS |
| 本地镜像打包与复核 | `build/build_all.ps1 -SkipBuild`；`report/lcd_build_gates_20261014.log` | `PIPELINE RESULT: ALL GATES PASS`，G1–G5 PASS |
| 最终空白差异检查 | `git diff --check` | 无错误；仅存在 Git 的 LF/CRLF 提示 |

C 回归直接包含当前 `main.c`，模拟 MMIO、计时器、VDMA 实际/请求帧及帧缓冲。覆盖：800×480 与 1024×600、连续输入不重启绘制、延迟接受 park 请求、扫描/请求帧内容不变、完整缓存清理先于提交、全量与分片渲染逐字节一致、缓冲边界、计时回绕、重复点击、静息/MPU 校准和记录模式不混入触摸/MPU 文本。主机测试验证调度与内存访问逻辑，不等同于验证 Cortex-A9 缓存指令或真实 VDMA 扫描行为。

RTL 回归覆盖五项配置寄存器的地址和值、平放、30° roll/pitch、100 Hz 开始间隔、小幅正负陀螺输入、掉线恢复及触摸按下/抬起/再次按下。30° 稳态输出分别约为 29.0° 与 29.7°；小陀螺输入输出分别为 +0.3° 与 −0.4°，证明小幅输入没有被整数量化完全丢弃。

最终 routed timing：WNS **0.085 ns**、WHS **0.019 ns**，TNS/THS 为 0，报告为 `All user specified timing constraints are met`。综合期间存在原有的生成时钟约束阶段警告；最终 implementation 时序检查通过。没有宣称所有 Vivado 日志零 warning。

G1 检查受保护系数绑定，G2 从网表解码系数，G3 检查错误 DSP 常量，G4 检查最终布线时序，G5 检查 BOOT.BIN 的 FPGA 分区与本次 bitstream 字节一致。全部通过。

## 本地产物

| 文件 | 大小 | SHA-256 |
|---|---:|---|
| `build/boot/BOOT.BIN` | 4,240,120 B | `7CECD38F129000638B8AC4799B963109629C6D86D7181A795F137EF12BB3D101` |
| `sw/ps_uart_print/ps_uart_print.elf` | 72,928 B | `95C11012AA92D2BCBCB84FD15896DCAE9C6CF34A0604B199B0C2F022E979AF4B` |
| `build/vivado/hand_motion_reconstruction.runs/impl_1/design_1.bit` | 4,045,684 B | `CD9E844078A8D83F66770F94ADDA0C0465BCBF4FB5C621CCB0E5842CCAA74550` |

镜像使用项目已有的 FSBL、新 bitstream 和当前应用 ELF；本次没有修改 PS 时钟/接口配置。未执行板卡下载或 SD 卡写入。

`report/lcd_preview_20261014.png` 来自实际 C 固件输出的 framebuffer，包含五种姿态、前臂倾斜和菜单；它是软件渲染预览，不是实机截图。

## 操作与实机验收

1. 启动时保持前臂稳定约 1 秒，MPU 零位由 100 个不同传感器样本计算。需要重采时点菜单中的“MPU校准”，或在监测串口发送 `z`。
2. 菜单“监测”进入 115200 波特率监测；“记录”进入原有 2 Mbaud 二进制采集；“校准”运行原有肌电静息校准；“MPU校准”重采前臂零位。
3. 底部姿态按钮用于本地预览，再点同一按钮退出预览；选菜单操作也会退出预览。预览状态显示 `PREVIEW`，不改变分类结果或采集数据。
4. 上板后核对触点坐标是否对应按键、松手后能否再次点击、前臂两个倾角方向是否符合安装，并持续运动观察是否残影/撕裂。发送 `d` 启用诊断，检查 `[STAT] lcd done/pending/merged/overflow`、MPU 链路和肌电序列连续性。
5. 实机应进一步验证缓存开启后的启动、连续采集、记录/监测切换和掉电重连，并测量真实刷新率和最长输入响应时间。

## 主要源码与回归入口

- `sw/ps_uart_print/main.c`：调度、输入、菜单、骨架渲染和 VDMA 缓冲所有权。
- `sw/ps_uart_print/display_memory.S`、`startup.S`、`build.bat`：内存属性、缓存清理和启动链接。
- `src/rtl/mpu6050_tilt.v`、`touch_gt911.v`：I2C 协议、运动计算及恢复。
- `sim/lcd_firmware_test.c`、`lcd_input_tb.sv`：功能回归。
- `build/scripts/run_lcd_firmware_test.ps1`、`run_lcd_input_sim.bat`：复现测试。
