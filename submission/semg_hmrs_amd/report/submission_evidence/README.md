# HDMI 与 LCD 同步展示

目标硬件：HZ-ZYNQ_MV01 / XC7Z020CLG400-2，Vivado 2025.2。

## 使用

将匹配的 `BOOT_20261103_HAND_CONTROL_HDMI_MIRROR_V31.BIN` 复制到启动 SD 卡并命名为 `BOOT.BIN`，断电重启。用标准 HDMI 线连接底板 J17 与支持 720p60 的显示器或投影仪，显示器选择对应输入。笔记本常见 HDMI 口是输出，不能作为输入；如需在电脑展示，可接支持 720p60 的 USB HDMI 采集卡。

LCD 继续负责触摸。监测、波形、频谱、训练、自学习及机械手页面均镜像到外接屏，固定输出 1280×720 / 60 Hz / RGB，无音频。此处 60 Hz 是视频扫描频率，界面更新仍由原有渲染调度决定。无需 PC 投屏软件，也不读取 EDID。

HDMI 是非隔离接口，会把板端地与显示设备相连；原有 USB 隔离器不隔离这条新增连接。人体佩戴采集时须采用合适的隔离显示链路，不能仅凭电池供电或 USB 已隔离判断整机仍隔离。

## 结构

PS 只绘制原有一份三缓冲画面。LCD 与 HDMI 的独立 VDMA 读取同一 DDR 帧；HDMI 经两行 BRAM 最近邻缩放、AXIS 视频输出、TMDS 编码与 OSERDESE2 串行化，直接输出底板连接器。

- ATK-4384：800×480 → 1200×720，左右各 40 像素黑边。
- ATK-7016：1024×600 → 1228×720，左右各 26 像素黑边；横向尺寸按整数像素取整。
- HDMI MM2S：`0x43010000`；状态/使能 GPIO：`0x41280000` / `0x41280008`。
- 固定 CEA 时序：总计 1650×750，像素时钟 74.25 MHz，串行时钟 371.25 MHz，DDR 输出 742.5 Mb/s/通道。
- HDMI DDC 与 GT911 共用 IIC2；本实现不加入 DDC 主机，不改变触摸协议。

两读者均接收上次提交后，才提交下次帧；后台帧同时避开双方实际读取及已请求帧。两屏显示同一帧内容，扫描边界独立，最多存在正常的帧相位差，不宣称逐像素同相。缓存清理与内存屏障仍在提交之前执行。HPD 不控制数据流，因此拔线不会阻塞 LCD；读者异常或持续不接受帧时，先等待 VDMA 复位完成，再释放其缓冲占用。串口 `l` 同时启停双屏读取。

## 验证与构建

```powershell
& "$env:AMD_VIVADO_ROOT/Vivado/bin/vivado.bat" -mode batch -source build/scripts/check_hdmi_scaler_netlist.tcl -log report/hdmi_mirror_20261103/scaler_synthesis.log *> report/hdmi_mirror_20261103/scaler_synthesis_console.log
powershell -ExecutionPolicy Bypass -File build/scripts/run_hdmi_test.ps1
powershell -ExecutionPolicy Bypass -File build/scripts/run_hdmi_pipeline_test.ps1
powershell -ExecutionPolicy Bypass -File build/scripts/run_lcd_firmware_test.ps1
powershell -ExecutionPolicy Bypass -File build/scripts/run_hdc_model_test.ps1 -ReportDir report/hdmi_mirror_20261103 -SkipLCD
& "$env:AMD_VIVADO_ROOT/Vivado/bin/vivado.bat" -mode batch -source build/scripts/rebuild_hdmi_mirror.tcl
& "$env:AMD_VIVADO_ROOT/Vivado/bin/vivado.bat" -mode batch -source build/scripts/audit_hdmi_routed.tcl
& "$env:AMD_VIVADO_ROOT/Vitis/bin/vitis.bat" -s build/scripts/update_learning_platform.py
powershell -ExecutionPolicy Bypass -File build/boot/build_pl_control_boot.ps1
```

初次扩展既有无 HDMI 工程时运行 `build/scripts/add_hdmi_mirror.tcl`；已有 HDMI BD 不要重复添加。`refresh_hdmi_mirror.tcl` 用于此分支的模块接口刷新。

独立验证包括两种面板各三帧逐像素比对、随机双向暂停、跨帧/错误隔离、实际 BRAM 网表、10 万个 TMDS 符号、UNISIM OSERDES 位序、MMCM/720p 时序、真实固件双读者缓冲保护及既有交互回归。另用实际生成的 Video Out IP、MMCM 与缩放器联合仿真，在锁定后核对完整 720p 帧的 921,600 个 RGB 像素；此时序测试中的串行器使用替身，真实 OSERDES 已在独立位序测试覆盖。整机资源及时序见本目录原始报告；对比以新增镜像功能前后的同器件布线结果计算，不将功能新增描述为等价优化。

生成镜像不等于已经写卡或完成实板显示验收。显示器兼容性、双屏实际画面、DDR 争用下的采集连续性及触摸响应须在目标板上复核。

## 本次布线结果

同一 XC7Z020、Vivado 2025.2、布线后口径，对比原有单 LCD 硬件与新增 HDMI 的完整系统：

| 资源 | 原有系统 | 双屏系统 | 增量 |
|---|---:|---:|---:|
| LUT | 27,537 | 30,050（56.48%） | +2,513 |
| 寄存器 | 28,793 | 32,346（30.40%） | +3,553 |
| BRAM Tile | 51.5 | 60.5（43.21%） | +9 |
| DSP | 55 | 55（25.00%） | 0 |
| MMCM | 1 | 2 | +1 |
| BUFG | 6 | 9 | +3 |

双屏系统 WNS＝0.231 ns、WHS＝0.035 ns，建立和保持失败端点均为 0；最终 DRC 无错误，方法学报告无 Critical Warning，保留原始告警供复核。新增 BRAM 包括两行缩放缓存及 VDMA、Video Out IP 的缓冲。时序余量不作为界面帧率或 Fmax 提升的证据。

CDC 详细报告仍保留结构性告警：面板模式比较后进入两级同步器，面板 ID 在 DMA 启动前已锁定；`locked` 分别进入 IP 内部同步器和只读状态同步器，两路不组合用于数据决策；`run/reset/locked` 共同异步置位、同步释放视频复位。新增例外仅止于同步器第一级 D 或复位同步链 PRE，后级与功能路径仍计时。原有采集链路的 CDC 告警也保留在报告中，不宣称整机 CDC 告警为零。

ATK-4384 镜像增加的名义 DDR 读取净载荷约 69.12 MB/s；ATK-7016 约 110.592 MB/s，均按 60 帧/s 计算，不含总线开销，不是实板带宽测量。资源及原始报告散列见 `comparison.json`，匹配镜像及验证输入散列见 `artifacts.json`。

