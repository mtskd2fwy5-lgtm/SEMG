# 工程经验与环境备忘（sEMG-HMRS）

> 本文件是跨会话记忆断点的保险：工作区从旧路径迁移后，AI 助手的项目记忆目录会重建。
> 这里固化环境层面踩过的坑与解法，避免重复排查。设计细节见 README 与 report/ 下各文档。

## 环境

| 项 | 值 |
|---|---|
| 板卡 | 合众恒跃 HZ-ZYNQ 核心板，XC7Z020-2CLG400I（规格书确认，厂商 xdc 注释里的 clg484 是笔误）|
| PL 时钟 | U18 = 25 MHz（IO_L12P_T1_MRCC_34）|
| PS 调试串口 | **UART0 @ MIO14/15**，115200-8N1；CH340C **物理直连 MIO14/15**（2026-09-10 实查接线结案）。底板手册 2.3.8「CH340 经 J23 接 UART1/UART3」说法**错误**；板子丝印虽标"UART1"，但 Zynq-7000 的 MIO14/15 电气上只能是 UART0（RXD=14、TXD=15）。UART1/MIO48/49/J23 跳线路线全部作废 |
| DDR3 | 2× MT41K256M16 RE-125，32 位总线，1GB（不是 Vivado 默认的 MT41J128M8）|
| QSPI | MIO1-6（已启用，为脱机启动预留）|
| Vivado | 2025.2，`D:\FPGA\VIVADO\2025.2` |
| 路径 | 根目录 `D:\FPGA\sEMG-HMRS`——**必须无空格**，旧路径 5 个空格是一系列脚本坑的根源 |

## ADS1299 前端接线（易错点）

8 根 SPI 信号约束在核心板 J1 连接器 20-28 脚——**底板把这些脚复用为 LCD/CMOS**，
前端板必须直连核心板 B2B 连接器，不能经过底板外设接口。

## PS 裸机 UART 坑（2026-09-10 定案，代价最大的一课）

`sw/ps_uart_print` 曾三处寄存器级 bug，导致 COM3 **全程零字节**（UART0/UART1 两个时代都如此）：

1. **FIFO 偏移错**：TX/RX FIFO 是 `0x30`，写成 `0x38`（那是 FLOWDEL 流控阈值）——字符全进了
   流控寄存器，从未真正发送。权威依据：`xuartps_hw.h` 的 `XUARTPS_FIFO_OFFSET=0x30`。
2. **波特率公式漏 +1**：`baud = clk/(BAUDGEN*(BAUDDIV+1))`（xuartps.c L562）。100MHz/115200
   正确配对 BAUDGEN=62、BAUDDIV=13（115207bps）；错配 54/16 实际只有 108.9k（-5.4%）。
3. **MR=0x26 是 6 数据位**：8N1 = `0x20`（CHARLEN_8=0x00 | PARITY_NONE=0x20）。

**最终真相（物理层）**：CH340C **物理直连 MIO14/15**——此前按底板手册 2.3.8 走的
UART1/MIO48/49 + J23 跳线路线全部作废。结案修复链：
`build/switch_ps_uart0.tcl`（改 BD：UART0 @ MIO14/15、UART1 关）→ 重导 XSA（无 bit 也可，
bit 用 `_ide/bitstream` 旧副本）→ 从 XSA 解包新 ps7_init.tcl（MIO_PIN_14=0x16E1/RXD、
MIO_PIN_15=0x16E0/TXD）→ main.c `UART_BASE=0xE0000000` → ninja 重编。
实测放跑配方 `build/debug/dbg_test_k.tcl`，COM3 收到完整横幅（2026-09-10）。

排查方法论教训：
- `ps7_peripherals_init_data_3_0`（ps7_init.tcl 内）**本来就会配好 UART**（当前 BD 为 UART0），
  调试会话启动即生效——别再手写第二遍初始化。
- 寄存器直发验证：必须先 `source ps7_init.tcl; ps7_init; ps7_post_config`
  再操作，否则 MIO 复用还是 BootROM 默认值（GPIO），发了也白发。
- hw_server 会拦截 FIFO 地址（UART0 为 `0xE0000030`）的**读**（read-once 保护），`mrd`
  会报错中断脚本，所有 mrd/mwr 要包 catch；环回自检看 SR 位（RXEMPTY=0x02）即可，不要读 FIFO。
- "寄存器不同地址读到同一个值" = DAP 通路不可靠的标志，该次实验数据全部作废。
- **丝印/手册/规格书三方冲突时，以万用表/实物接线为准**；Zynq MIO14/15 电气上只能配 UART0，
  板子丝印写"UART1"不代表 MIO14/15 是 UART1。
- 串口终端打开时首行乱码 = 半截字节波特率失步，无害。

## JTAG 调试坑（2026-09-10 定案）

- **`rst`（系统复位）清 PL** → app 首次访问 PL 内 AXI DMA(0x40400000) 时总线挂死，核无法暂停
  （跨连接、跨 hw_server 重启都救不回，只能再 rst 解卡）。IDE launch 必须 `resetSystem=false`；
  脚本流程先 `fpga` 烧 PL 再 `dow`。
- **挂死分级（2026-09-11 实测）**：轻度挂死 XSCT `rst` 可解；**深度挂死连 `rst` 都报
  `APB AP transaction error, DAP status 0xF0000021`**（A9 核目标都不枚举），重启 hw_server 只能
  清部分 sticky 位（0xF→0x3）救不回 APB 通路——**唯一出路是板子断电重上电**。
- **「每次调试都要断电」根因定案（2026-09-11）**：IDE launch 的 `programDevice` 烧 bit 时
  **核还在跑**，app 正轮询 PL 内的 DMA 寄存器（0x40400000 在 PL 里），bit 烧写瞬间清空 PL
  → CPU 挂死在总线上 → `dow` 写 DDR 报 `Memory write error / AP transaction timeout`。
  **修复：调试前先停核**——双击 `build/debug/pre_debug_stop.bat`（XSCT `stop`，5 秒），然后 IDE launch
  永远安全，无需断电。已实测：核 Running 时 stop → 重烧 bit → dow → 放跑，零断电全通过。
- **XSCT `dow` 后立即 `con` 有 PC 提交竞态**：核可能从旧 PC 恢复执行（永不经过 main）→
  断点不命中、核显示 Running。**解法：`dow` 后先 `stp`×2 再 `con`**。
- IDE 断点排查三板斧：**第 0 步先看调试工具栏的「Deactivate All Breakpoints」开关**（2026-09-11
  实锤：此开关一关，所有断点灰色空心且永不命中，与"未绑定"外观完全相同，极易误诊为路径/ELF 问题；
  XSCT 设的地址断点不受此 UI 开关影响，会造成"脚本断点能停、IDE 断点不停"的假象）。
  之后：① PROBLEMS 有 ld 错误 = 调试会话锁 ELF（先停调试再 Build）；
  ② 断点灰色空心 = ELF/源码行号不匹配（重 Build）；③ 断点红色但不停 = 旧 PC 竞态
  （Suspend 看调用栈，若在旧循环 → 重新 launch 或改用脚本流程）。
- 调试会话活跃时点 Build 必失败（hw_server 锁 ELF）；Vitis 增量构建可能不感知源码变化，
  不见效就删 build 目录全量重编。
- Cortex-A9 只有 6 个硬件断点，超过会静默失效。
- 掉电重上电后 IDE 首次 launch 若 PL 烧写失败，先手动跑一次 ps7_init 类脚本再 launch。

## Vivado 工具坑（2025.2 实测）

1. **`[Common 17-354] Could not open 'C' for writing` / `[Common 17-1257] Failed to create directory 'C'`**
   （OOC run 启动即报，run 被标红但实际完成，.dcp 正常生成——非致命）。
   根因：多进程并发 launch_runs 时竞争复制本地用户数据（AMD AR# 63253）。
   **根治（2026-09-10 已验证）**：设置用户环境变量 `XILINX_LOCAL_USER_DATA=no` 和 `HOME=C:\Users\<user>`，
   重启 Vivado 生效。旧修法（删 `%APPDATA%\Xilinx\Vivado\tclapp\manifest.tcl` + `.manifest_lock`）
   只能临时缓解，manifest 会被重建，删除 `tclapp` 目录也会复发。并发数建议 `-jobs 8`（16GB 内存上限）。
2. **`Board 49-26` 警告洪水**（每次开工程 ~100 条）：精简安装 + 全量板卡库。
   改名 `data/xhub/boards/XilinxBoardStore` 无效（扫描是递归的），
   必须**移出**到 `data/xhub/`（如 `XilinxBoardStore.disabled`）。
3. **`[Project 1-5713] Board part ''`**：环境中没有任何可用板卡时每次 open_project 必报
   （全新空工程实测同样报）。无法消除，无害，别再查了。
4. **`save_project` 已删除**：工程命令立即回写，不要调用。
5. **`add_files`/`remove_files` 单文件路径必须 `[list]` 包装**，否则空格路径被按空格拆分。
6. **XDC 限制**：不支持 `if` 语句；`set_output_delay` 的 `-max`/`-min` 不能合并一条。
7. **时钟域**：`clk_fpga_0` 由 PS7 IP 在实现阶段创建，综合阶段用户 XDC 里引用会失败
   → 时钟组约束放 impl-only XDC（`board/constraints/hz_zynq_clock_groups.xdc`）。
8. **导出 XSA 前必须 `open_run`**，否则报 "No IPI block design hardware handoff"。
9. **后台长任务**：本机沙箱对子进程有 2 分钟超时，Vivado 批处理（~8 分钟）要用
   WMI `Win32_Process.Create` 拉起脱离进程树（build 下脚本按此模式运行）。
10. Vivado 保存工程会自动重写 xpr（如重加空的 `BoardPart` 选项），手改 xpr 会被覆盖。

## 板级调试工具集（build/debug/，2026-09-11 整理）

| 工具 | 用途 |
|---|---|
| `pre_debug_stop.bat` | **每次 IDE 调试前双击**：停核防总线挂死（内部调 dbg_stop.tcl） |
| `dbg_stop.tcl` | XSCT 停核（connect → stop） |
| `dbg_test_k.tcl` | 一键放跑：stop → ps7_init → fpga → dow → stp×2 → con |
| `dbg_test_a.tcl` | 断点链路自检：放跑配方 + main 断点，`Stopped: (Breakpoint)` 即健康 |
| `dbg_probe.tcl` | 只读探测目标状态/核状态 |

XSCT 调用：`D:\FPGA\VIVADO\2025.2\Vitis\bin\xsct.bat <脚本>`。

## 验证体系（改动必查）

```powershell
# 1. RTL 位精确验证（Python 参考模型，秒级）
cd sim\results 后运行 tools\emg_reference.py 的 compare-*（详见 emg_reference.py --help）
# 2. 全链路实现检查（~8 分钟，含 bit + XSA）
& "D:\FPGA\VIVADO\2025.2\Vivado\bin\vivado.bat" -mode batch -source build\check_design.tcl
```

- PL 信号链 4 级全部与 Python 定点参考模型位精确：带通（3000 样本）、
  滑窗特征（49 窗）、特征 bank（120 词）、全链路 export（2080 raw + 80 feature 词）。
- PS 侧裸机监控程序：`sw\ps_uart_print`（build.bat 编译，run.ps1 经 XSCT 烧录运行）。
- 未接 ADS1299 时 PS 打印 `[DMA] no PL data yet` 属正常。

## 待办 / 扩展方向

- PL 端轻量神经网络推理引擎（40 维特征 → 动作类别 + 置信度）
- PS 端解析/个体化校准/虚拟手模型驱动
- QSPI 脱机启动（fsbl + 启动镜像）
- 实测数据采集与评估（report/evaluation_template.md）
