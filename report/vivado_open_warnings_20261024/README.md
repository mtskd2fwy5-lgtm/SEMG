# Vivado 工程告警修复（2026-10-24）

本轮处理旧文件引用、模块引用解析和 LCD 生成时钟约束的应用阶段；保留现有采集、识别、康复、HDC 和机械手控制 RTL。

## 已确认的根因

- XPR 直接引用不存在的旧模块 `_0_4` DCP，以及迁移前目录下的 WCFG；当前模块版本为 `_0_7`。
- Vivado 2025.2 在打开 XPR、尚未打开 BD 时，模块引用处于延迟解析状态；打开 BD 后，五个引用均为 Up-to-date。这与实际源码缺失不同。`build/open_project.tcl` 将打开和验证 BD 纳入入口。
- `hz_zynq_lcd.xdc` 在综合时引用 OOC 黑盒内的 `c31_raw/c50_raw`，产生四条 12-4739。生成时钟相关约束迁至 `hz_zynq_lcd_timing.xdc`，仅在实现阶段 LATE 处理；构建 Tcl 和路由验证 Tcl 检查时钟及路径是否存在。
- 两种 LCD 模式的输出延时增加 `-add_delay`，确保保留两组分析。5 ns setup/hold 沿用既有工程假设，尚无面板精确时序规格实测。
- 补全两种模式后，原内部时钟参考点造成约 4.95 ns 未计入的 DCLK 转发路径延迟，50 MHz 模式暴露负裕量。最终改为在 `lcd_clk` 输出上创建两个反相生成时钟，并为每个定义同时指定 `-master_clock` 和 `-add`；输出延时引用实际 DCLK 上升沿，保持原 5 ns 预算。独立检查已确认两种模式均有有效且通过的 setup/hold 路径。

## 复现

```powershell
powershell -ExecutionPolicy Bypass -File build/build_all.ps1 -SkipBoot
& 'D:/FPGA/VIVADO/2025.2/Vivado/bin/vivado.bat' -mode batch -source report/vivado_open_warnings_20261024/verify_routed.tcl
powershell -ExecutionPolicy Bypass -File build/boot/build_pl_control_boot.ps1
```

GUI 建议从仓库根目录使用 `vivado -source build/open_project.tcl`。若已有旧工程窗口，先关闭该工程再重新打开，避免缓存旧的文件引用。直接打开 XPR 后也可先打开 `design_1.bd`，再刷新 IP 状态。

原 V1 的 XPR、BD、bit、routed DCP、XSA、ELF 和 BOOT 保存在 `baseline/`。新镜像使用 `20261024_HAND_CONTROL_V2` 标签，保留 V1 独立镜像。诊断阶段带有不兼容 XDC 检查的实现已主动停止；旧内部时钟模型的实现时序不通过，未打包发布。交付只采用 `final_impl.log` 对应结果和通过门禁的新镜像。

## 验证记录

- 顶层及 EMG 模块综合：0 Critical Warnings、0 Errors；最终实现日志也无 Critical Warning / Error。
- 独立重开：`verify_open.log` 的 `REOPEN_VERIFICATION_PASS`；五个 module_ref 均正常，无缺失的工程输入文件，LCD XDC 阶段属性正确。
- 独立路由核查：`verify_routed.log` 的 `ROUTED_VERIFICATION_PASS`；六路 PWM 球位和 LVCMOS33 保持正确。
- 最终整机时序：WNS **+0.293 ns**、WHS **+0.065 ns**，TNS/THS 均为 0。31.25/50 MHz LCD 的 setup/hold 分别见 `lcd_c31_raw_*.rpt`、`lcd_c50_raw_*.rpt`。
- `boot_build.log`：G1 参数绑定、G2 网表系数、G3 DSP 常量和 G4 路由时序全部 PASS；随后 XSA/bit/ELF/BOOT 完整匹配检查 PASS。
- V2 BOOT：`build/boot/BOOT_20261024_HAND_CONTROL_V2.BIN`，5,016,148 字节；各输入和产物 SHA256 见 `artifacts.json`。
- 资源：LUT 39,939（75.07%），FF 35,998，Slice 12,759（95.93%），BRAM 29.5，DSP 101。较 V1 为 LUT +12、FF 不变、Slice -142、BRAM/DSP 不变；这是实现结果变化，未做架构优化。
- methodology 仍有 9 项普通 Warning：2 LUT 异步复位、1 同步链放置、1 CDC 检查、4 自动生成时钟按名称引用、1 control set 使用建议。未隐藏或降级；本轮未将这些全部重构处理。面板 5 ns 预算仍待真实规格/板测核实。

未进行板上实测或机械手接线验证。旧版 V1 BOOT 保留不变。
