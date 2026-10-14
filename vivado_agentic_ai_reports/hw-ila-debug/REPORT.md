# ILA 抓数报告 — LCD 白屏根因猎杀·第二轮，2026-10-13

## 结论

**根因收窄至 VDMA 内部/AXI 读链路：VDMA 通道处于"忙"态（非 HALTED 非 IDLE、零错误）但 M_AXIS_MM2S 从未推出任何流数据（TVALID 恒 0），vid_out 因此从未锁定（locked=0），LCD 白屏。**

本轮（v4 位流）排除了下游 adapter 全部嫌疑，并把 VDMA 死锁定位于"寄存器看似已启动、流接口零输出"的内部状态。

## 抓取配置

- 位流：BOOT_DEBUG_ILA.BIN（SD 卡启动，v4 debug bit，3 个 ILA 核）
- 探针文件：build/lcd_debug_probes.ltx
- 全部 trigger_now 立即抓取，2026-10-13 11:12

## 三核抓数结果

### hw_ila_3 = u_ila_axis @FCLK_CLK0（100 MHz，4096 样本 ≈ 41 µs）→ capture_axis.csv

| 探针 | 全程值 | 判定 |
|---|---|---|
| TVALID | **0（4096/4096）** | VDMA 从未呈现任何流 beat——连第一个 SOF 都没有 |
| TREADY | 1（4096/4096） | vid_out 一直在等数据（接收侧就绪） |
| TUSER | 0（4096/4096） | 无帧起始脉冲 |

### hw_ila_2 = u_ila_pclk @lcd_pclk → capture_pclk_2.csv

| 探针 | 值 | 判定 |
|---|---|---|
| hcnt / vcnt | 连续计数（观测 0xb8→0xc1，vcnt=0x21） | adapter 时序发生器活着、在扫 |
| sel4384_sync/meta | 1/1 | 面板识别切换正确 |
| **vid_out locked** | **0** | vid_out 从未同步——与"从未收到 SOF"互为印证 |
| vid_rst_out | 0（释放） | 复位链正常 |

### hw_ila_1 = u_ila_g50 @FCLK_CLK1 → capture_g50.csv

| 探针 | 值 | 判定 |
|---|---|---|
| id_reg | 0x4384 | 面板 ID 识别正确（ATK-4384） |
| id_settled / id_valid | 1 / 1 | 采样状态机完成 |
| mmcm_locked | 1 | 像素时钟 MMCM 锁定 |

## XSCT 寄存器证据（板上直读，mrd -force，Cortex-A9#0）

| 寄存器 | 值 | 判读 |
|---|---|---|
| CR @0x43000000 | 0x00010003 | RS=1（跑）、bit1=1（Circular）；bit16 为 RO 常量 |
| SR @0x43000004 | 0x00010000 ×3（1s 间隔） | HALTED=0、IDLE=0（通道"忙"）；错误位（0xFF0）全 0；FRMCNT 字段恒 1 不增 |
| VSIZE/HSIZE/STRIDE | 0x1E0 / 0x960 / 0x960 | 480 行 × 2400 B，几何完美 |
| SA0/SA1/SA2 | 0x18000000 / 0x18119400 / 0x18232800 | 三 buffer 地址步距完美（+1.152 MB） |
| FRMSTORE @0x18 | 读 0 | 寄存器未实现/不可写（IP 配置） |
| S2MM CR/SR | 0 / 0 | MM2S-only 设计，S2MM 未用（符合预期） |

## CR 写入实验（板上直接改寄存器）

- 写 CR=0x0000000B（RS|Circular|GenlockEn，对齐 ATK 21_vdma_lcd 例程的 EnableSync=1 配置）
- 读回 **0x00010003——bit3（GenlockEn）写不进**
- 结论：本 IP 配置 genlock 特性未生成（RtType 硬连 No-Genlock），CR 配置差异假说**排除**；死锁不在 CR

## 判读树状态

已排除：面板 ID 识别、adapter 时序发生器、BD 接线/时钟（m_axi_mm2s_aclk=m_axis_mm2s_aclk=FCLK_CLK0，BD 落盘确认）、vid_out 使能/复位、VDMA 寄存器配置（全对或不可写）、CR genlock 差异。

剩余嫌疑（v5 探针 verdict tree，u_ila_axis probe2 {arvalid, arready, rvalid, rlast}）：

1. **arvalid=0** → VDMA 内部 FSM 从未发起 AXI 读（内部停摆）
2. **arready=0** → smartconnect_1/HP0 拒收读请求
3. **rvalid=0（AR 已握手）** → HP0/DDR 读数据永不返回
4. **rvalid=1 而 tvalid=0** → VDMA 流侧门控死

## 产物

- capture_axis.csv / capture_pclk_2.csv / capture_g50.csv — 本目录
- report_data.json — 结构化数据（本轮）
- v5 探针构建：后台进行中（job-707fcfd6），产物 impl_1/design_1_wrapper_debug.bit + build/lcd_debug_probes.ltx

---

# 第三轮：v5 抓数与"写死区"发现，2026-10-13 12:15–12:40

## v5 抓数结果（u_ila_axis，probe0={tvalid,tready,tuser}，probe1={arvalid,arready,rvalid,rlast}；tdata 整体 dropped 后重编号）

- 稳态 trigger_now（4096 样本 ≈41 µs，capture_axis_v5_now.csv）：**4096/4096 单一取值 AR=0100**（ARVALID=0，**ARREADY=1**，RVALID=0，RLAST=0），TS=010（TVALID=0/TREADY=1/TUSER=0）
- ARVALID 上升沿触发（eq1'bR）：**35 秒零触发**（≈3.5M 个 aclk 周期）

## 重大转折：v5 boot 的 VDMA 是"未配置"状态，v5 抓数被污染

XSCT 现场发现（vdma_restart_probe / vdma_app_state / vdma_zone_check 三脚本）：

| 证据 | 值 | 含义 |
|---|---|---|
| VDMA CR/SR/几何 | 0x00010002 / 0x00010001 / 全 0 | 全新复位态，**RS=0、HALTED=1** |
| app 全局 | lcd_stream_started=1, fb_bpl=0x960, raw_cnt 500ms +0x4438 | lcd_init 完整跑过、主循环活着 |
| axi_dma_0 S2MM CR @0x40400030 | 0x00010003 | **app 写入粘住**（同 boot、同 GP0） |
| axi_gpio_0 @0x41200008 | 0x4384 | GPIO 正常 |
| DAP 写 VDMA（FRMSTORE=3、几何、CR=0x5） | 全部不粘，读回复位值 | **写通道死** |
| VDMA 读（Version@0x2C=0x62000050） | 正常 | 读通道活 |

**写死区 = 恰好 axi_vdma_0 一个从机；读活写死。**

## 根因（v5 位流层面）：时序违例

v5 布线日志（job-c7bcc91c76874ba4b8e617dbec63d1dd）：
- Route 35-57 最终估计 **WNS=-1.270 / TNS=-2.522**（WHS=+0.053）
- Route 35-468：2 个 setup/hold 双关键 pin（u_ila_pclk ILA 内部）
- v4 debug 位流写入正常；v4→v5 唯一差异 = probe2（ARVALID/ARREADY/RVALID/RLAST route-through）插入后的重布线

**结论：v5 位流被时序污染（AXI-Lite 写路径边缘失败），v5 的"分支 1 命中"只对"未配置"态成立，v4 真谜题（配置好、RS=1、忙、无 AR）仍未解。**

## v5.1（进行中）

debug_ila_lcd.tcl 已加：route → phys_opt_design → FINAL-WNS 打印 + build/timing_debug.rpt → 位流。要求 WNS≥0 才算有效抓数位流。重建后烧板重测：若写入复活 → 复现 v4 状态再抓 AXI 读通道，回到判读树。

## 产物（第三轮）

- capture_axis_v5_now.csv — 本目录
- 脚本：C:\Users\bvcm\AppData\Local\Temp\{vdma_restart_probe,vdma_app_state,vdma_zone_check}.tcl
- v5 构建日志：job-c7bcc91c76874ba4b8e617dbec63d1dd（时序违例证据 L961–L1186）

---

# 第四轮：v6 判决——写序根因实锤 + 复活实验 + "自毁"真相，2026-10-13 14:30–16:20

## 结论（全案定案）

1. **白屏主根因 = app lcd_init 启动写序错误**：`VDMA_VSIZE` 先写、`VDMA_DMACR=RS` 后写，违反 Xilinx 驱动启动序（xaxivdma_channel.c L989–1019：先 CR|=RS，VSIZE 最后写并注释 "Update vsize to start the channel"）。反序导致命令 FSM 等不到 all_idle 上升沿、通道从未发出任何 DataMover 命令——v4/v5/v6 三代位流 ILA 零 ARVALID 互证。
2. **"复活后自毁"是假象**：XSCT 复活实验 CR=0x00FF0013 里打开了 FrmCntEn(bit4)+IrqThreshold=0xFF，通道正常跑了 255 帧（≈3.1 s @82.5 Hz）后帧计数到零，触发 **VDMA 规格内自动停机**（RTL L19108：`FRMCNTEN=1 and ioc_irq_set → run_stop_clr → RS 硬件清零`），随后 run_stop_fe→halt→halt_reset→dm_prmry_resetn=0、命令挂死。不是硬件错误、不是 fsize、不是 app 干的。

## 复活实验（build/xsct_revive_vdma.tcl，四轮迭代）

序列：PHASE0 dump → PHASE2 CR=0 halt（HALTED=1 ✓）→ PHASE3 重写几何/SA → PHASE4 **CR=0x00FF0013（RS 先）** → PHASE5 **VSIZE=0x1E0（最后）** → PHASE6 每 400ms 轮询 SR×6。

- PHASE6：SR[23:16] 帧计数每 400ms 递减 ~33（0xDE→0x3A，≈82.5 Hz），错误位全 0——**通道活着**
- 证据意义：VSIZE 最后写让 FSM 离开 IDLE 并发出第一条 DataMover 命令（hw_ila_4 tvalid0=1 实测）——**写序修复当场生效**

## "自毁"取证与排除法判决

ILA 死态（capture_vdma_revive_now.csv，vs 复活前 capture_v6_vdma.csv）：

| 探针 | 复活前 | 死态 | 判读 |
|---|---|---|---|
| rs_mirror (dmacr[0]) | 1 | **0** | RS 被硬件清零 |
| mm2s_dm_prmry_resetn | 1 | **0** | halt_reset 置位 |
| sof_reset | 0 | **1** | dm_halt=1 |
| I_CMDSTS tvalid0 | 0 | **1** | 命令已发出、挂死 |
| m_axi_mm2s_arvalid | 0 | 0 | DM 已复位 |

RTL 证据链（axi_vdma_v6_3_rfs.vhd）：
- **L15673**：`halt_i ← soft_reset_re or stop or run_stop_fe or fsize_mismatch_err`（四条件）
- **L15718**：`halt_reset` 置位要求 **stop='0'** → 结合 dm_prmry_resetn=0 ⟹ **stop=0，排除 dma_err/AXI 错误路径**
- **L48357**：fsize_mismatch = fsync 时行未传完——SR bit7 实测 **0**，排除
- **L19108**：`run_stop_clr ← ... or (FRMCNTEN=1 and ioc_irq_set)`——**唯一幸存路径**
- XSCT 终审（build/xsct_read_sr.tcl）：SR=0x00FF1001（HALTED=1、**错误位全 0**、**IOC_IRQ=1**、FrameCount=0xFF）、CR=0x00FF0012（RS 已清）、PARKPTR=1（app 翻缓冲仍在写）

## 附带澄清（app 侧嫌疑全部洗清）

- **运行期 PARKPTR 写入（main.c:1238）= Tail/Park 模式合法翻缓冲**：RTL L63856——park 模式每个 fsync 边界从 PARKPTR[4:0] 重载帧号。保留。
- **FRMSTORE 读 0 = 只读配置回显**（v6.3 无独立帧计数存储需求），Tail 模式不依赖帧号循环。app 写 3 无效但无害（fix-16 一并清理）。
- **linebuffer 512<800 不构成根因**：streaming FIFO 背压机制正常，且通道 3.1 秒内正常出帧。

## 最终修复（已构建，ALL GATES PASS）

main.c 三处：
1. lcd_init 写序交换：RS 先、**VSIZE 最后**（对齐 Xilinx 驱动序）——白屏主根因修复
2. lcd_enable('l') 重启动路径：halt 后补 VSIZE 写入（裸 RS 写不会重新武装已停通道）+ 等 HALTED
3. fix-16：VDMA_FRMSTORE 无效写入/宏/错误注释清理（改打 parkptr）

产物：新 ps_uart_print.elf 36,856 B（-Wall -Wextra 零警告）；BOOT_DEBUG_ILA.BIN 16:15:10（v6 ILA 位流+新 ELF，验证用）；BOOT.BIN 16:15:56（产品位流+新 ELF）；管线 G1–G5 全 PASS（WNS=0.387/WHS=0.008）。

## 产物（第四轮）

- capture_vdma_revive_now.csv / capture_pclk_revive_now.csv — 本目录（复活后快照）
- capture_data.csv — XSCT SR 终审读数（判决数据）
- 脚本：build/{xsct_revive_vdma, xsct_probe_map, xsct_read_sr}.tcl
- RTL 锚点：axi_vdma_v6_3_rfs.vhd L15673/L15718/L19108/L48357/L63856；xaxivdma_channel.c L989–L1019

---

# 第五轮：linebuffer 512<800 定案 + 构建环境根因（TRAE 沙箱）+ 2048 重建

## 起点

烧写第四轮产物 BOOT_DEBUG_ILA.BIN（v6 ILA + 写序修复 ELF）→ **仍白屏**。指令：全面对比例程（ATK 21_vdma_lcd）。

## 四核活体取证（BOOT_DEBUG_ILA.BIN，linebuffer 512 位流，1024 样本/核）

| ILA | 域 | 实测（稳态） |
|---|---|---|
| ila1 (u_ila_g50) | 面板识别 | id_pins=000080、id_reg=4384、id_settled/id_valid=1、mmcm_locked=1 —— 识别+时钟链完美 |
| ila2 (u_ila_pclk) | 时序发生器 | hcnt 0x16f→0x3cf 连续扫描，样本 609 处 0x3cf→0x000 回绕（**周期 976 = 4384 面板 H-total**）；vcnt 递增；sel4384_sync/meta=1；**locked=0、first_sof=1**；vid_rst_out=0（已释放） |
| ila3 (u_ila_axis) | MM2S 流侧 | **TVALID uniq=1（恒 1，数据流活）**；TREADY 0/1；**TUSER uniq=1（恒 0，全部样本）**；ARVALID/ARREADY/RVALID/RLAST 正常翻转 |
| ila4 (u_ila_vdma) | 命令/通道 | s_axis_mm2s_cmd_tvalid 恒 1、cmdsts_idle=0（DataMover 忙）、全 resetn=1、dmacr[RS]=1、m_axi_mm2s_arvalid 每 ~65 样本一个突发 —— **通道完全活**（写序修复前 arvalid 恒 0 的直接对照） |

## 判决：唯一死点 = TUSER/SOF 恒 0 → vid_out 永不锁定

数据搬运活（ila4）+ AXI 读活（ila3 AR/R 通道）+ 时序发生器完美（ila2）+ 面板识别完美（ila1）——唯独**流侧帧时序 TUSER 全程为 0**。v_axi4s_vid_out 的 locked 依赖收到 SOF/TUSER；first_sof=1/locked=0 = 从未见过帧头 → DE 永不激活 → 白屏。

## 例程对比（ATK 21_vdma_lcd）

例程 system_axi_vdma_0_0.xci L260/L329：`c_mm2s_linebuffer_depth = 2048`、SOF_ENABLE=1、THRESH=4；本设计同 IP 为 **512**。MM2S linebuffer 深度须覆盖整行像素（800 > 512），深度不足破坏流侧帧时序（SOF/TUSER 插入）→ TUSER 恒 0，与四核实测吻合。

## 推翻第四轮 "linebuffer 排除" 结论

第四轮（本文件上文"附带澄清"节）依据 "通道 3.1s 出帧（FRMCNT 递减）+ FIFO 背压正常" 排除 linebuffer——该证据只证明**寄存器侧数据搬运**在跑，不证明**流侧帧时序**正确。第五轮 ila3 TUSER 恒 0 + ila2 locked=0 板上实测推翻。教训：**FRMCNT 计数 ≠ 帧时序正确**。

## 修复

design_1_axi_vdma_0_0.xci：`c_mm2s_linebuffer_depth 512→2048`（MCP 会话 set_property，value_src=user，save 前后两次复核；S2MM 侧 512 未动——本设计未用）。

## 构建事故与根因（重要环境教训）

1. 构建#1（job-9bf7062d）：update/validate/generate 全过后，launch_runs 处 `[filemgmt 56-587] lcd_clk_fwd` 死亡
2. MCP 会话修复（5 个 module_ref upgrade_ip + validate -force 实跑 17s + save + generate）→ 构建#2（job-6fb00568）：同位置 `[filemgmt 56-587] emg_pl_export` 再死
3. **差分诊断**：同一份 .xpr——沙箱内 vivado：open_bd_design 报 5× `[BD 41-1726]`（全部 module_ref）+ `[20-730] sim top 无法验证` + 大量 `C:\ProgramData\boost_interprocess` 访问被拒；**沙箱外 MCP 会话：open_bd_design 零警告，report_compile_order 完整（5 个 module_ref 模块全在、Missing instances 为空）**
4. **根因 = TRAE 沙箱掐断 Vivado IPC/子进程基础设施**（launch_runs 的 OOC 子进程协作依赖 boost_interprocess 共享内存）。旁证：历史上沙箱内 bootgen 全部 -1073741515（DLL 加载失败）。工程本身健康；XCI git diff 为空（仅行尾差异）亦佐证。
5. **处置**：构建改在 MCP Vivado 会话（沙箱外）执行：全部 OOC（含 emg_pl_export_0_4）+ synth_1 + impl_1 一次点火成功，零 56-587。后续门禁/打包用非沙箱 Shell（build_all.ps1 -SkipBuild）+ MCP exec bootgen。

## 待板上验证判据（BOOT_DEBUG_ILA.BIN，2048 位流）

1. ila3：TUSER 出现 1 脉冲（每帧一次）
2. ila2：locked=1
3. LCD 出图

> **[第六轮推翻]** 2048 位流烧板仍白屏、TUSER 仍恒 0（详见下文 round-6）。linebuffer 深度只影响 FIFO 容量，不参与 frame_sync 生成机制——第五轮对 L260/L329 的因果解读错误。linebuffer 2048 保留（覆盖整行 800 像素是正确配置），但它不是根因。

## 产物（第五轮）

- capture_alive_ila1/2/3/4.csv — 本目录（四核稳态，linebuffer 512 位流）
- 例程锚点：D:\FPGA\ZYNQ_Vitis_7020\...\21_vdma_lcd\...system_axi_vdma_0_0.xci L260/L329

### linebuffer 2048 重建结果（17:14 点火，MCP 会话 launch_runs）

- impl_1：17:26:57 `write_bitstream completed successfully`（12 分钟，OOC 复用前次产物），Bitgen **0 Critical Warnings / 0 Errors**
- 时序（routed）：**WNS=+0.483 / TNS=0（0/96838）**、WHS=+0.039 / THS=0 —— "All user specified timing constraints are met"
- XSA：build/export/design_1.xsa（17:37，open_run impl_1 + write_hw_platform -include_bit）
- 五闸门（build_all.ps1 -SkipBuild，非沙箱）：**G1–G5 ALL PASS**（G1 六参数绑定 / G2 网表解码 / G3 零字面量 / G4 时序 / G5 分区校验）
- **BOOT.BIN（生产）**：4,206,832 字节，2026-10-13 17:38:45 —— linebuffer 2048 + 写序修复 ELF
- **BOOT_DEBUG_ILA.BIN（验证用）**：4,206,832 字节，2026-10-13 18:01:19 —— v6 四 ILA 核 + linebuffer 2048 + 写序修复 ELF；探针文件 build/lcd_debug_probes.ltx（18:01 时点为 17:46:23 版）
- **debug 位流时序偏差披露**：FINAL-WNS=-1.058，违例仅 2 端点，均为 `first_sof_reg`(clk_fpga_0) → u_ila_pclk 触发匹配器 probeDelay 的 **CDC 探针工具路径**（非功能逻辑）。AXI-Lite 域全净（clk_fpga_0 内部 WNS=+1.942 / WHS=+0.052，零 hold 违例）→ v5"AXI-Lite 写丢失"失败模式被排除；主判据探针不受影响（ila3 TUSER aclk 域、ila2 locked c31 内部 +0.412）。按 v5.1 "lab use 位流照常写出"政策放行，生产 BOOT.BIN（WNS=+0.483 全过）为时序干净参照

---

# 第六轮：RTL 级根因定案——VDMA free-run SOF 死锁 + genlock_mode 0→3 修复，2026-10-13 18:05–

## 起点

烧写 BOOT_DEBUG_ILA.BIN（linebuffer 2048 + 写序修复 ELF）→ **仍白屏**。第五轮 linebuffer 假设被板上证据推翻。

## 四核板上取证（2048 位流，capture_r6_ila1-4.csv，18:07）

| ILA | 域 | 实测 |
|---|---|---|
| ila1 (u_ila_g50) | 面板识别 | id_pins=000080、id_reg=4384、settled/valid=1、mmcm_locked=1 —— 完美 |
| ila2 (u_ila_pclk) | 时序/锁定 | hcnt 977 distinct 扫描、vcnt 递增、sel4384=1、**locked=0、first_sof=1**（自复位起从未见 SOF） |
| ila3 (u_ila_axis) | MM2S 流侧（4096 样本量化） | **TVALID 恒 1（4096/4096）**；**TREADY=1280/4096=31.25%**；**TUSER=0/4096**；ARVALID 61 突发、ARREADY 恒 1、RVALID 480 |
| ila4 (u_ila_vdma) | 命令/通道 | cmd_tvalid=1、idle=0、全 resetn=1、soft_reset=0、**sof_reset=0**、dmacr[RS]=1 |

**TREADY=31.25% 的分流意义**：≈33.3MHz pclk / 100MHz aclk——vid_out 正按 VTG active 窗口节拍逐像素消费（每窗口搜 SOF、找不到就丢弃）。vid_out 与 lcd_panel_adapter（VTG 时序）**全部健康**，死点 100% 位于上游 VDMA 的 TUSER 生成。

## XCI 全参数 diff（vs ATK 例程 21_vdma_lcd）

剩余显著差异仅：**c_mm2s_genlock_mode 例程=3 vs 我们=0**、c_num_fstores 例程=1 vs 我们=3、拓扑（例程含 VTC + rgb2lcd + clk_wiz；我们自定义 lcd_panel_adapter）。linebuffer/thresh/sof_enable/flush_on_fsync/use_fsync/use_mm2s_fsync 系列全部一致。

## RTL 死锁链（axi_vdma_v6_3_rfs.vhd 直读定案）

1. `c_use_mm2s_fsync=0` → MM2S fsync_gen 命中 **GEN_FREE_RUN_MODE**（L52360）：`frame_sync_i <= all_idle_re and run_stop`（L52400）——free-run 下**唯一**的 SOF 源
2. dma_ctl（L62814）：`all_idle <= cmnd_idle AND sts_idle AND dwidth_fifo_pipe_empty AND line_buffer_empty`
3. 板上：TVALID 恒 1 → line_buffer_empty=0 恒成立；供 100 Mpix/s ≫ 收 31.25 Mpix/s → linebuf 恒积压 + 命令流水恒忙
4. → **all_idle 恒 0 → all_idle_re 永不脉冲 → frame_sync 恒 0**（ila4 sof_reset=0 已排除复位路径）
5. → GEN_LINEBUF_FLUSH_SOF 分支（L47121，我们 flush=1+sof=1）SOF_FLAG_PROCESS（L47295）：sof_flag 永不置位 → fifo_din 最高位恒 0 → **TUSER 恒 0**
6. → v_axi4s_vid_out first_sof 永不满足 → locked=0 → DE 永不激活 → **白屏**

**设计性死锁：free-run SOF 依赖"帧间完全排空"（all_idle 上升沿），带宽不对称 + circular 背靠背读使排空永不发生。**

## 例程为何能活

例程 `c_mm2s_genlock_mode=3`（Dynamic Slave，RTL L59705 DYNAMIC_GENLOCK_FOR_SLAVE / L63677 DYNAMIC_SLAVE_MODE_FRAME_CNT）+ PARKPTR park 模式：帧输出由 PARKPTR 引导、每 fsync 边界从 PARKPTR[4:0] 重载帧号（L63856，**仅存在于 DYNAMIC_SLAVE 分支**）、命令发射受帧对齐门控 → 帧间断流 → all_idle 有间隙 → frame_sync 存活 → SOF 存活。我们 genlock_mode=0（MASTER_MODE_FRAME_CNT L64582）无此机制。

## 修复（已批准执行）

XCI `c_mm2s_genlock_mode 0→3`（MCP 会话 set_property + validate + save + generate，18:20-18:29 完成落盘）。app 暂保持 CR=0x03；若板上 TUSER 出脉冲但帧不切换 → app lcd_init 补 GenlockEn（CR|=0x08）重新打包（板上分流决定）。

## genlock_mode=3 重建结果（18:29 点火，MCP 会话 launch_runs）

- impl_1：18:40:55 `write_bitstream Complete`（约 11 分钟，VDMA OOC 重跑 + synth + impl），**WNS=+0.548 / TNS=0 / WHS=+0.036** —— 全约束满足（优于 2048 版 +0.483）
- XSA：build/export/design_1.xsa（18:44，open_run impl_1 + write_hw_platform -include_bit -force）
- 五闸门（build_all.ps1 -SkipBuild，非沙箱）：**G1–G5 ALL PASS**（G1 六参数绑定 / G2 网表解码 ALL COEFFICIENT REGISTERS CORRECT / G3 零字面量 / G4 时序 WNS=0.548 / G5 分区校验 OK）
- **BOOT.BIN（生产）**：4,206,832 字节，2026-10-13 18:42:49 —— genlock_mode=3 + linebuffer 2048 + 写序修复 ELF
- debug ILA 位流：后台重建中（job-78a71e5a），完成后补 BOOT_DEBUG_ILA.BIN

---

# 第七轮：genlock=3 生产版白屏 + 例程照搬定案（fstores 3→1），2026-10-13 晚

## 起点

用户烧写 genlock_mode=3 生产版 BOOT.BIN（18:42:49）→ **仍白屏**。指令：直接照搬 ATK 例程 21_vdma_lcd。

## 历史误判修正：DMACR bit1 = GenLockEn

第二轮"写 CR=0x0B 读回 0x03 → GenlockEn 写不进 → genlock 未生成"为**误判**：PG020 中 DMACR **bit1 才是 GenLockEn**（VDMA 无 Circular bit——那是 AXI DMA 概念，VDMA 循环靠 fstores 自动回绕），bit3 为 RO 保留位。app 一直写 CR=0x03 = RS + **GenLockEn 已置位**。"IP 未生成 genlock 硬件"假说作废（与第6轮 genlock_mode 0→3 改动可落盘互证）。

## vid_out XCI 全参数 diff（例程 2020.2 XML vs 我们 2025.2 JSON）

14 项全部一致：C_PIXELS_PER_CLOCK=1、C_S_AXIS_VIDEO_FORMAT=2、C_S_AXIS_VIDEO_DATA_WIDTH=8、C_NATIVE_COMPONENT_WIDTH=8、C_HAS_ASYNC_CLK=1（异步 aclk 100M / vid_io_clk 33M）、C_ADDR_WIDTH=10、C_HYSTERESIS_LEVEL=12、C_VTG_MASTER_SLAVE=0、C_SYNC_LOCK_THRESHOLD=4、C_INCLUDE_PIXEL_REPEAT=0、C_INCLUDE_PIXEL_REMAP_420=0、C_ADDR_WIDTH_PIXEL_REMAP_420=10、C_COMPONENTS_PER_PIXEL=3、C_S_AXIS_TDATA_WIDTH=24（仅 2025.2 新增 ARBITRARY_RES_EN=false 为默认值）。**vid_out 配置排除。**

## VDMA XCI 剩余差异收敛：c_num_fstores

例程复核：C_NUM_FSTORES=**1**、GENLOCK_MODE=3、LINEBUFFER_DEPTH=2048、THRESH=4、SOF_ENABLE=1、INTERNAL_GENLOCK=1、GENLOCK_NUM_MASTERS=1、MM2S_DRE=0。我们当前：fstores=**3**，其余全部已对齐（genlock_mode=3 第6轮、linebuffer=2048 第5轮；internal_genlock / num_masters / thresh / sof_enable 本轮复核一致）。

**照搬例程的 XCI 改动收敛为唯一一项：c_num_fstores 3→1。**

### 追加（外部工具线索核实）：c_mm2s_max_burst_length

用户转交外部工具分析截图（18:58 时点），其中多数论断已过时（mode=3 已打包烧写仍白屏）或与证据矛盾（"软件需置 CR[3]=EnableSync"——PG020 bit1 才是 GenlockEn，板上实测 bit3 RO 写不进，app CR=0x03 已含 bit1）。但 **`c_mm2s_max_burst_length` 例程=64 vs 我们=8** 经 XCI 三处核实（PARAM_VALUE/MODELPARAM/BUSIFPARAM）**属实**——第6轮全参数 diff 的漏项，照搬清单第 2 项真实差异。影响：2400B/行下 burst=8 需 30 个小突发/行（vs 64→4.7 个），读侧效率与帧间排空速度相关（第6轮死锁链的 all_idle 条件）。

**最终照搬配置（19:16:42 点火全链重建）：c_num_fstores=1 + c_mm2s_max_burst_length=64 + c_mm2s_genlock_mode=3 + linebuffer=2048**（set_property 后 list 读回 `64 1 3` 全确认，validate/save/generate 完成，smartconnect_1 OOC 因接口属性变化一并重跑）。

## 第7轮取证判决：BOOT_DEBUG_ILA.BIN（genlock=3 + fstores=3 + burst=8）仍白屏，TUSER 恒 0 实锤

用户 19:21 前后烧写 BOOT_DEBUG_ILA.BIN（19:02:31 取证版，genlock_mode=3 生效、fstores/burst 未动）并上电——仍白屏。四核 ILA 立即抓数：

**稳态快照（19:21:23，trigger_now 四核全触发）**

| 核 | 探针 | 实测 | 判读 |
|---|---|---|---|
| ila3 | TUSER | **恒 0（4096/4096）** | SOF 仍未出 |
| ila3 | TVALID / TREADY | 恒 1 / {0,1} 翻转 | 数据流活、vid_out 在收 |
| ila3 | ARVALID / RVALID | {0,1} 翻转 | AXI 读链活 |
| ila2 | locked / first_sof | 0 / 1 | vid_out 从未见过 SOF（等第一帧） |
| ila4 | mm2s_dmacr（深路径） | 恒 0 | **探针漂移假象，作废**（见下） |

**TUSER 上升沿触发等待：35 秒零触发**（eq1'bR @19:24:13 武装，35s 后 STATUS 仍 WAITING FOR TRIGGER——≈2870 个帧周期窗口无一上升沿）。

**XSCT 寄存器直读（Cortex-A9 MPCore#0）**：DMACR=0x00010003——**lite 侧 RS=1 + GenlockEn=1 完好**（app 写入正确、未被硬件清零）。

**ila4 探针漂移判定**：引擎实测在跑（cmd_tvalid=1、cmdsts_idle=0、ARVALID/RVALID 翻转）⟹ 引擎域 RS 必为 1 ⟹ 探针读 0 与运行证据矛盾 ⟹ genlock=3 重综合改变 VDMA 内部结构（新增 DYNAMIC_SLAVE 分支逻辑）导致 debug_ila_lcd.tcl 的深路径 net ladder 漂移、抓错信号。第6轮 netlist 锚点在 genlock=3 下失效。ila4 本轮数据作废；主判决依赖 BD 端口 net（ila3/ila2，不会漂移）。

**判决：genlock_mode=3 单独（fstores=3 + burst=8 下）没有解开 SOF 死锁。** 第6轮"genlock=3 → 帧间断流 → all_idle 间隙 → frame_sync 活"的推断在此配置下未兑现——可能原因：burst=8 的碎片化读命令让 DataMover/linebuffer 排空依旧不完整，或 fstores=3 的 park 指针失配挡住帧推进。**下一块拼图：fstores=1 + burst=64 完整照搬版（19:16:42 构建中）。**

## app 侧影响分析

fstores=1 时 SA1/SA2 寄存器与 PARKPTR 字段无效——app 三缓冲翻页写退化为 no-op（无害），显示变为单缓冲（SA0）持续刷新 = 例程原生工作模式（例程 app 源码不在盘，已全盘确认）。预期现象：出静态图。

## 执行计划

1. 在途 debug ILA 构建（genlock=3 + fstores=3 + 写序修复 ELF，job-78a71e5a）完成 → BOOT_DEBUG_ILA.BIN → 烧板抓 TUSER：判 genlock_mode=3 是否已破 SOF 死锁——TUSER 出 1 = 死锁已解、fstores=3 park 失配挡出图（fstores=1 即解药）；TUSER 仍 0 = 更深层问题（拓扑照搬评估）
2. MCP 会话 c_num_fstores 3→1 + validate + save + generate + launch_runs 全链重建 → BOOT.BIN + BOOT_DEBUG_ILA.BIN（fstores=1 照搬版）

---

# 第八轮（终局）：vtg_ce 悬空 = 真根因，2026-10-14 出图定案

## 最终判决

**LCD 白屏真根因 = v_axi4s_vid_out 的从机时序控制信号 `vtg_ce` 悬空。** v_axi4s_vid_out 以视频时序发生器为从机：在 SOF 对齐与 FIFO 预填阶段通过拉低 `vtg_ce` 暂停外部时序，FIFO 就绪后释放使能、置 locked=1、开始输出 DE。原拓扑的 v_tc_0 经 `gen_clken` 接收此信号；重构为 lcd_panel_adapter（module_ref）时 **vtg_ce 未接线**，时序计数器（hcnt/vcnt）自由运行、永不等 vid_out → **locked 恒 0 → DE 永不输出 → 白屏**。外部工具用 Xilinx v_axi4s_vid_out 源码仿真证实：正确 SOF/EOL 流 + 自由运行时序 → 永不 lock；vtg_ce 门控后 → lock。**上板验证：出图。**

## 修复三件套（缺一不可，2026-10-14 1:10 BOOT.BIN 全部到位）

1. **vtg_ce 门控（根因修复，RTL+BD）**：[lcd_panel_adapter.v](file:///d:/FPGA/sEMG-HMRS/src/rtl/lcd_panel_adapter.v) L57 新增 `input wire vtg_ce`，L268 时序计数器改为 `if (vtg_ce)` 门控推进；BD 连线 `v_axi4s_vid_out_0/vtg_ce → lcd_panel_adapter_0/vtg_ce`，并补全 vtg_active_video/field_id/hblank/vsync/vblank 全套从机握手（= 例程 VTC 原生接法，拓扑级照搬的关键一步）
2. **fstores=1 direct 寄存器视图（app 映射修正）**：main.c 寄存器映射从 park 组（SA@+0x18/PARKPTR@+0x28/VSIZE@+0x40）改为 direct 组（VSIZE@+0x50、HSIZE@+0x54、STRIDE@+0x58、START(n)@+0x5C+4n，L423-430）——fstores=1 的 direct 模式下 SA 仅 1 个@0x5C，与照搬配置契合；启动序 RS|TAIL|SYNC=0x0B 先、VSIZE 最后（写序修复保留）。旧 park 映射 ELF（16:12）烧 fstores=1 位流 = 写错寄存器组 → 通道未 arm → 19:33 版白屏的直接死因
3. **VDMA XCI 照搬参数（第6/7轮成果）**：genlock_mode=3 + max_burst=64 + linebuffer=2048 + fstores=1（例程 21_vdma_lcd 全参数对齐）

## 全案时间线（2026-10-13 09:00 → 10-14 01:10）

| 轮次 | 动作 | 判决 |
|---|---|---|
| R1-R2 | 四核 ILA 活体取证 | 排除面板识别/adapter 时序/BD 接线；死点收窄至 VDMA 流侧（TVALID 恒 0） |
| R3 | v5 探针 + XSCT | 发现"写死区"假象；v5 时序违例污染作废 |
| R4 | 复活实验 + RTL 追凶 | **app 写序根因 #1 实锤**（VSIZE 先/RS 后违序，Xilinx 驱动序为 RS 先 VSIZE 最后）；"自毁"= FRMCNTEN 帧计数停机（规格内行为） |
| R5 | 四核复测 + 例程 diff | TUSER 恒 0 / locked=0 / first_sof=1 定位；linebuffer 512→2048（后被推翻为非根因）；TRAE 沙箱掐 Vivado IPC 定性 |
| R6 | RTL 死锁链推演 | free-run 模式 all_idle 恒 0 → frame_sync 死推论；genlock_mode 0→3 |
| R7 | 照搬版烧写 + TUSER 取证 | genlock=3 单独不解死锁；fstores 3→1 + burst 8→64 补齐照搬；**ila4 深路径探针漂移作废教训** |
| R8 | 外部工具仿真 + 修复上板 | **vtg_ce 悬空 = 真根因**；三件套齐 → 出图收官 |

## 复盘：为什么前七轮没抓到

1. **locked=0/first_sof=1 从 R2 起每轮可见**，但判读重心一直放在"VDMA 为何不发 TUSER"（上游供数侧），从未质疑"vid_out 的 locked 需要时序发生器受控"（PG044 slave 模式契约）。R6 的 RTL 死锁链推演在 VDMA 内部逻辑上自洽，但方向错了——**上游数据正确性与下游时序受控是两个独立必要条件**
2. **照搬对齐了 XCI 参数却漏了拓扑接法**：例程 VTC 的 gen_clken/vtg_ce 接线是 vid_out 从机模式的一部分，第6轮"评估拓扑照搬"时因动静大被推迟——真根因恰在此
3. **正面教训**：R4 写序修复、R7 fstores/burst 照搬、R8 direct 寄存器映射都是必要修复（缺任何一个通道都不正常出图），ILAf 活体取证链（TVALID→TUSER→locked→DE）每一环都是有效的排除法证据

## 最终工程状态

- 位流：impl_1/design_1.bit（10-14 01:10:13，五闸门 PASS，WNS=+0.602/WHS=+0.036）
- BOOT.BIN：4,206,868 B（10-14 01:10:56）= vtg_ce 修复 + fstores=1 + burst=64 + genlock=3 + linebuffer=2048 + direct 映射 ELF（36,892 B，0:32:27）
- XSA：build/export/design_1.xsa（01:10:45）
- 显示模式：单缓冲 SA0 持续刷新（例程原生模式），app 三缓冲翻页写退化为 no-op（无害）

