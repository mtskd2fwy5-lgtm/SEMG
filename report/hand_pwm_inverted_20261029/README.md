# V20 六路 PWM 反相光耦适配

版本：`20261029_HAND_CONTROL_HDC_DYNAMIC_PWM_OPTO_V20`。

按用户确认的接线，六路 PWM 输出均经过反相光耦。因此在 `hand_control` 的最后一级输出统一取反：内部逻辑和脉宽均保持正脉冲语义，输出引脚改为低有效。

| 状态 | FPGA 引脚 | 反相光耦后 / 舵机端 |
| --- | --- | --- |
| 空闲、复位、停止、急停、超时或非法目标 | 高 | 低 |
| 有效 PWM 脉冲 | 低 | 高 |

掌部与五指共六轴全部反相。500–2500 μs 范围、已保存脉宽、机械手方向、20 ms 帧周期、限速、六轴原子复位、单轴隔离、HDC 映射、MPU 旋转和全部 watchdog 规则保持原义。不是把目标脉宽改成 `20000−目标值`，也不需要因为此次电平变更重新标定。引脚仍为 J4-5..10：V7、U7、W8、V8、U9、U8。

本版适用于上述反相光耦接线；直接绕过光耦接舵机时，引脚电平语义不再适用。表中的复位电平指 FPGA 已完成配置、控制逻辑处于复位时；FPGA 尚未配置时的外部信号状态由板级电路决定。

## 实现与继承

RTL 只修改 `src/rtl/hand_control.v` 的最后一级输出；内部发生器、控制寄存器、算法、MLP/HDC/NMF、MPU 姿态、SD 模型库、康复训练和 LCD 功能全部继承 V19。PS 应用只更新版本标识。引脚约束只更新极性说明，不改引脚、电气参数或时序例外。

由于极性属于 PL 输出电路，本版重新综合、布局布线并导出含新位流的 XSA，再生成匹配 BOOT，不能仅替换旧 BOOT 内的 ARM 应用。

## 验证

- `polarity_rtl.log`：冻结 V19 正脉冲控制器作独立参考，逐周期比较全部状态字及反相后的六路输出，覆盖约 227 万个时钟周期及原有完整控制用例。
- `pin_rtl.log` / `pin_netlist.log`：RTL 与独立综合后的真实网表均验证六轴低有效宽度 500/833/1300/1700/2200/2500 μs、20 ms 周期、单轴隔离、脉冲中急停/复位、非法目标和超时高电平空闲。
- `hand_test.log`：PS 固件 ACK、STOP、HDC 联动、MPU、标定、实时映射与六轴同步上电复位回归。
- `hardware_build.log`：完整工程重建与原有滤波系数、综合网表、时序等验收门。
- `timing_routed.rpt` / `utilization_routed.rpt` / `drc.rpt`：新整机实现结果；`output_pins.txt`：实际 routed 引脚与电气标准核对。
- `regression_sources.json`：本轮验收输入；`baseline/`：变更前 V19 源码、位流、XSA 和 routed checkpoint。
- `tools/verify_hand_pwm_release.py`：严格核对 V19 源码继承、仅最终输出反相、软件只更新版本标识、RTL/综合网表测试及 routed 证据；旧版本的发布证据保持不变。

最初 pin 测试在 DUT 复位后没有清理仍留在测试输入中的旧命令，导致 watchdog 场景未合法启动；按现有协议补上 STOP 后验证。最初综合网表导出使用了不支持的 `rename_ref -top` 选项，已移除额外重命名并使用原顶层名。失败记录保留在 `pin_rtl_initial_test_setup.log` 和 `netlist_export_initial_command.log`，最终结果以正式日志为准，未为测试修改控制算法。

```powershell
powershell -ExecutionPolicy Bypass -File build/scripts/run_hand_pwm_polarity_test.ps1
# 先执行 export_hand_pwm_netlist.tcl 生成测试综合网表
powershell -ExecutionPolicy Bypass -File build/scripts/run_hand_pwm_polarity_test.ps1 -Netlist
powershell -ExecutionPolicy Bypass -File build/build_all.ps1 -SkipBoot
powershell -ExecutionPolicy Bypass -File build/boot/build_pl_control_boot.ps1
```

输出：`build/boot/BOOT_20261029_HAND_CONTROL_HDC_DYNAMIC_PWM_OPTO_V20.BIN`。本轮不改写 SD 卡，不下载硬件；尚未连接实物光耦验证传播延迟和舵机侧电平。
