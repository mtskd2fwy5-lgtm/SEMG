# V17：MPU 姿态解算迁入 PL

版本：`20261028_HAND_CONTROL_HDC_DYNAMIC_IMU_PL_V17`。目标器件 `xc7z020clg400-2`，Vivado 2025.2。本次将原 PS 六轴姿态算法定点化迁至 PL，保留原肌电链路、NMF/HDC、疲劳分析、虚拟手映射、康复训练和机械手保护。

## 分工与实现

PL 保留现有 50 MHz MPU6050 I²C 前端和 100 Hz 六轴采集，新增 100 MHz Q24 姿态解算器。它完成重力初始姿态、连续静止校准、陀螺零偏及温漂跟踪、重力弱校正、四元数积分与归一化、固定重力基底、三维旋转矩阵、前臂旋转的 swing/twist 分解、角度展开和掌部范围限制。共享乘法器及迭代除法/平方根，寄存器使用单写口 LUT RAM，程序常量存入 BRAM。

PS 通过非阻塞 GPIO 邮箱读取冻结结果，负责状态/新鲜度校验、虚拟手绘制及已标定机械手目标生成。生产 ARM 路径不再进行四元数融合；测试专用 C 解释器和旧浮点参考不进入 ARM 镜像。肌电静息校准、佩戴适配、学习流程与训练管理仍在 PS。PL 六路 PWM 及限位、限速、超时保护沿用原实现。

## 接口与失效处理

- 旧六轴 GPIO 地址及含义保留，新增 `axi_gpio_7`：`0x41270000` 写命令，`0x41270008` 读响应；ABI `0x17494D55`。
- 命令 bit31 为逐次翻转的事务标志，`[27:24]` 为操作码：1 冻结快照、2 读索引、3 重新校准。响应 bit31 为确认，其余 31 位为有符号数据。
- 30 字结果包含 ABI、有效/校准/旋转/静止状态、样本计数、Q12 三维矩阵、掌部角度、零偏、丢帧/过载计数、计算周期和诊断四元数。定义见 `sw/ps_uart_print/lcd_imu_3d.h` 与 `src/rtl/mpu_attitude.v`。
- 六轴总线在采集序号双级同步并稳定三个时钟后锁存；源总线在下一次 10 ms 采样前保持。前端 50 MHz 和姿态 100 MHz 为不同 FCLK 域，采用稳定窗口快照，不以两个频率的整数关系替代 CDC 设计。整机报告核对实际捕获路径、同步链与时序；行为仿真验证稳定等待和快照规则，不将其当作亚稳态实测。
- 快照整帧冻结，防止矩阵分量来自不同采样；重校准中断旧快照读取。断连、样本停更超过 100 ms、ABI/矩阵范围错误、计算过载或 PS 事务超时会使姿态失效。

## 数值与功能验证

冻结迁移前实际 V16 源码、XSA、位流及启动镜像于 `baseline/`，由旧浮点算法产生参考轨迹；Q24 Python 模型、RTL 逐位回放与测试专用 C 解释器使用同一生成程序。

| 项目 | 结果 / 依据 |
|---|---|
| 浮点参考对照 | 13,528 样本，32 次复位，未发现超阈值差异 |
| 矩阵元素最大误差 | 0.002197265625（单位矩阵尺度） |
| 掌部翻转角最大差 | 1° |
| RTL 对定点模型 | 全部回放逐位一致 |
| 核内最长观测耗时 | 6,112 周期 / 100 MHz = 61.12 μs |
| 传感器更新周期 | 10 ms；最长观测计算占 0.6112% |

覆盖掌心/手背初始姿态、翻掌后抬臂、600°/s 快速翻转、非交换 XYZ 旋转、冲击、静止热漂、真实慢转、竖直启动、运动中重新校准、序号/时间回绕与丢帧。最长耗时是该组轨迹的观测值，不是全状态形式化最坏时延或板上端到端测量。

`rtl_mailbox.log` 验证快照冻结、有符号读取、重新校准、重连和停更失效；`netlist_mailbox.log` 使用本次整机构建的实际 OOC 网表，验证校准、真实六轴 60° 翻转、快照、复位和断连。`mailbox_firmware.log` 验证生产 PS 接收器，包括读帧末尾发生校准或断连的边界。

`lcd_test.log`、`hand_test.log` 和 `learning_workflow_test.log` 保留两种 LCD 分辨率、144 条页面路由、虚拟手映射、HDC 稳定判决、疲劳/康复、上电六轴同步复位与故障失效测试。原机械手和 HDC 实现通过冻结源码哈希核对。

## 整机资源与发布

最终 Routed 资源及时序见 `resource_table.md`、`comparison.json`、`utilization_routed.rpt` 和 `timing_routed.rpt`。对比基线是 V16 复用的 V15 优化硬件；本次增量包含姿态核、新增 GPIO 和 AXI 互联，不将独立核综合估算充当整机增量。

| 整机指标 | V16 | V17 | 增量 |
|---|---:|---:|---:|
| LUT | 23,793 | 27,370（51.45%） | +3,577 |
| FF | 24,622 | 28,784（27.05%） | +4,162 |
| Slice | 9,284 | 11,098（83.44%） | +1,814 |
| BRAM | 45.5 | 49.5 | +4 |
| DSP | 49 | 53 | +4 |
| WNS / WHS | +0.151 / +0.028 ns | +0.386 / +0.036 ns | 均通过 |

时序收敛中将乘法结果缩放与共享寄存器写入拆成两个时钟，保持 Q24 舍入及数值不变。新 50/100 MHz 捕获路径采用 20 ns 数据路径上界与 10 ns 总线偏斜约束；原时钟组约束前缀逐字保留，未通过全局假路径或降低 100 MHz 工作频率规避核内时序。

新增跨时钟 TIMING-6/7 严重告警已消除。自动 CDC 报告仍会保守标记稳定窗口总线，并非所有项目均为 Safe；结合 10 ms 源保持、同步/稳定等待协议、96 位端点覆盖及物理时延/偏斜检查解释。TIMING-37 为源总线同时扇出至旧诊断 GPIO 和新姿态捕获，实际偏斜通过；原有工程警告在基线独立复核，未以豁免隐藏。完整审查见最终 impl_1 目录下 `METHODOLOGY_RESOLUTION_REPORT.md`。

完整构建证据为 `full_build.log`，验收入口为 `tools/verify_imu_release.py`。`regression_sources.json` 绑定本次源码、ROM、测试和构建脚本；最终 `artifacts.json` 绑定实际位流、XSA、应用、FSBL 及 BOOT。打包检查会核对 BOOT 中位流字序变换和 ARM/FSBL 的所有有效加载段，以及 FSBL 初始化代码与新 XSA 一致。

```powershell
python tools/gen_imu_microcode.py
powershell -ExecutionPolicy Bypass -File build/scripts/run_imu_test.ps1
powershell -ExecutionPolicy Bypass -File build/build_all.ps1 -SkipBoot
# 从本次整机 OOC checkpoint 导出，再执行 -Netlist。
# export_imu_netlist.tcl / audit_imu_routed.tcl 由 Vivado batch 执行。
powershell -ExecutionPolicy Bypass -File build/scripts/run_imu_test.ps1 -Netlist
python tools/compare_imu_resources.py
# Vitis: refresh the platform / FSBL from the new hardware export.
# D:/FPGA/VIVADO/2025.2/Vitis/bin/vitis.bat -s build/scripts/update_learning_platform.py
python tools/verify_imu_release.py
powershell -ExecutionPolicy Bypass -File build/boot/build_pl_control_boot.ps1
```

重新生成程序、修改生产代码或 RTL 后，必须重跑对应测试和构建、刷新源码绑定，不可沿用旧日志放行。

## 上板复核

本次未写 SD、未下载硬件，仿真与静态时序不能替代实板验证。新 BOOT 的版本、大小和哈希以 `artifacts.json` 为准；复制到启动 SD 卡时需另行命名为 `BOOT.BIN`。

上电连接 MPU 后先进行临时跟踪，非竖直前臂连续静止约 1 秒后完成正式校准；原校准按钮及串口 `z` 触发 PL 重新校准。校准使用当时真实安装姿态，不能把实际掌心朝下校准期望为自动朝上。依次复核抬臂、翻掌后抬臂、左右转动、连续翻掌及重校准，确认虚拟手方向；机械手仍需有效标定和明确启用。

掌部保留左 45°、右 225°的约定及标定脉宽映射。没有 MPU 或姿态过期时，不再以旧姿态继续跟随。六轴 MPU 无绝对航向参考，持续动态偏航仍可能累积误差，本迁移不宣称消除物理不可观测的航向漂移。

紧凑报告框图：`report/system_block_20261028/compact/system_block_compact.png`，同时提供 SVG/PDF；图中已将姿态融合标入 PL、结果接收与虚实映射标入 PS。原用户 DOCX 未覆盖。

## 最终启动镜像

`build/boot/BOOT_20261028_HAND_CONTROL_HDC_DYNAMIC_IMU_PL_V17.BIN`

大小：5,081,624 字节；SHA256：`d658b97866811d188c5d8a84e2a434c10863dc23b539035ff8faa79f2bfb0f53`。

Vitis 平台与 FSBL 已从新 XSA 刷新，完整打包核验通过（1 个应用加载段、3 个 FSBL 加载段）。未写 SD 或下载硬件。
