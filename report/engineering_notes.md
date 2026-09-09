# 工程经验与环境备忘（sEMG-HMRS）

> 本文件是跨会话记忆断点的保险：工作区从旧路径迁移后，AI 助手的项目记忆目录会重建。
> 这里固化环境层面踩过的坑与解法，避免重复排查。设计细节见 README 与 report/ 下各文档。

## 环境

| 项 | 值 |
|---|---|
| 板卡 | 合众恒跃 HZ-ZYNQ 核心板，XC7Z020-2CLG400I（规格书确认，厂商 xdc 注释里的 clg484 是笔误）|
| PL 时钟 | U18 = 25 MHz（IO_L12P_T1_MRCC_34）|
| PS 调试串口 | UART0 @ MIO14/15（RXD/TXD），底板 CH340C + J23 跳线，115200-8N1 |
| DDR3 | 2× MT41K256M16 RE-125，32 位总线，1GB（不是 Vivado 默认的 MT41J128M8）|
| QSPI | MIO1-6（已启用，为脱机启动预留）|
| Vivado | 2025.2，`D:\FPGA\VIVADO\2025.2` |
| 路径 | 根目录 `D:\FPGA\sEMG-HMRS`——**必须无空格**，旧路径 5 个空格是一系列脚本坑的根源 |

## ADS1299 前端接线（易错点）

8 根 SPI 信号约束在核心板 J1 连接器 20-28 脚——**底板把这些脚复用为 LCD/CMOS**，
前端板必须直连核心板 B2B 连接器，不能经过底板外设接口。

## Vivado 工具坑（2025.2 实测）

1. **`[Common 17-354] Could not open 'C' for writing`**（GUI 弹窗 + OOC run 日志）：
   `%APPDATA%\Xilinx\Vivado\tclapp\manifest.tcl` 登记了未安装插件（aldec::activehdl）。
   删 manifest.tcl + `.manifest_lock` 即愈。非致命（run 实际完成）。
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
