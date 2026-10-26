# 六路机械手接入 / 20261024_HAND_CONTROL_V1

后续 V6 的控制分工与操作以 [MPU 旋转及 HDC 联动说明](../hand_mpu_20261025/README.md) 为准：轴 0 由 MPU 控制，动作映射只控制五指；屈腕/伸腕不映射到机构，自定义手势有显式 HDC 联动模式。以下保留 V1 构建与接线记录。

用户已向厂家确认支持 3.3 V PWM。当前尚未接线，也没有机构标定值。
本次追加 PL 执行控制和 LCD 标定，不修改肌电滤波、模型权重及五类识别策略。
实物运动、接线方向和机械到位均未验证；此处的软件测试不替代实测。

已生成候选：[BOOT_20261024_HAND_CONTROL_V1.BIN](../../build/boot/BOOT_20261024_HAND_CONTROL_V1.BIN)。
完整构建门禁及 XSA/bit/ELF/BOOT 分区匹配检查通过，证据见 `gates.log`、
`boot_build.log` 和 `artifacts.json`。部署时将此候选复制为启动卡的 `BOOT.BIN`；
本轮没有改写用户 SD 卡。

实现后 LUT 39,927（75.05%）、FF 35,998、Slice 12,901（97.00%）、
BRAM 29.5、DSP 101。相对接入前增加 1,559 LUT、1,996 FF、434 Slice、
6 DSP，BRAM 不变；WNS +0.392 ns、WHS +0.051 ns。
详细对照见[资源比较](resource_comparison.md)。剩余 Slice 399，后续 PL 学习
引擎追加需要重新实现评估；本次没有把整个系统提前改成资源优化版。

## 接线

根据 HZ-ZYNQ MV01 底板原理图 20250910 第 1 页核对 J4，并用 AMD
`xc7z020_clg400.pkg` 核对器件球位。原始厂家引脚表存在错位，未据其分配。

| 轴 | 原机械手功能 | FPGA 排针 | 器件球位 |
|---|---|---|---|
| 0 | 掌部/基座旋转 | J4-5 | V7 |
| 1 | 拇指 | J4-6 | U7 |
| 2 | 食指 | J4-7 | W8 |
| 3 | 中指 | J4-8 | V8 |
| 4 | 无名指 | J4-9 | U9 |
| 5 | 小指 | J4-10 | U8 |

J4-37 或 J4-39 接机械手信号地/舵机电源负端。舵机使用其要求的独立电源，
不可从 FPGA 的 3.3 V 引脚供电。直接接舵机 PWM 信号线时，断开原 Arduino
对应输出，不能把两个控制器的输出并接。轴 0 暂称旋转，未认定为腕屈伸。

以上引脚属于 Bank 13、LVCMOS33，不与现有 J4-17..24 的 ADS1299 接线重叠。

## LCD 操作

入口：**设置 → 机械手**。

1. 首先保持输出关闭，卸除负载，逐轴核对接线。选择轴后用 ±10/±50 us
   设置待测脉宽；数值变化只修改编辑值，不立即输出。
2. 点“单轴测试 1 秒”才输出该轴，其他五路保持低电平。1500 us 只是编辑
   初始值，未被视为该机构的安全中位；如厂家给出起始值，以其为准。
   500–2500 us 只是协议边界，不能直接当作机械可达范围。
3. 通过小步试动确定可用区间，分别记录脉宽下限和上限。下限/上限指脉宽
   大小，不代表张开/闭合方向。已记录按钮会高亮。六路共 12 项都完成后
   `CAL` 显示 4095。修改任一限值会禁用全部既有映射，需重新确认。
4. 切换“动作映射”，点动作名称循环选择类别，逐轴编辑并点“记录本轴目标”。
   六路目标均在标定区间内后，点“确认六轴映射”。可用“禁用此类”取消该行。
   每个动作对应一个六轴姿态；不依据“张手/屈腕”等名称自动推断目标。
5. “启用 PL 联动”会先上传标定和完整映射，随后请求使能。需要 PL 监测就绪、
   当前类别已有映射且没有故障。切到没有映射的类别会停机，需补齐映射后
   再显式启用。建议先配置五类；`MAP=31` 表示原五类都启用。
6. “保存 SD 标定”写入 `HAND0.CFG` / `HAND1.CFG` 两个轮换备份，含版本、
   序号及 CRC32。读取时选择最新的有效记录；坏记录可回退上一份。
   波形录制时拒绝配置读写。读取与重启均不恢复输出使能。

“停止输出”和页头“停止”可取消待发启用命令，停止 PWM；单轴测试离开页面、
打开菜单或达到 1 秒也会停止。停止信号不等于切断舵机电源，部分舵机会保持位置。
首次使能没有真实当前位置，不能保证从实际角度平滑起步。连续已使能的目标切换
按每 20 ms 帧最大 20 us 改变脉宽；它是命令限速，不是速度/位置闭环。

界面上的 OFF/TEST/PL AUTO、CAL、MAP、LINK、IO 和 FAULT 是命令/配置状态。
LINK=1 为接口签名缺失，2 为队列错误，3 为应答超时；IO 非零表示配置文件操作
失败。机构没有角度/接触/电流回传，因此不能声称“已到位”。

自定义 1–3 的目标可预先编辑、保存，但目前只有原五类是 PL 权威分类来源。
PS HDC 的自定义分类不会自动驱动机械手；PL 个体化学习、中文命名及模型绑定
持久化仍属于后续功能，未借本轮机械手接口宣称完成。

## 实现与验证

`emg_pl_control` → `hand_control` → `hand_servo_pwm` → 六个顶层输出。
PS 的 GPIO5 邮箱地址为 0x41250000，状态为 0x41250008；命令负载保持到
状态快照中返回 ACK。PS 只上传标定、映射、模式和保活，自动模式的类别来自
PL 最终稳定决策，独立于 DMA 消费情况。

20 ms PWM 帧；PS 租约 250 ms、PL 决策新鲜度 250 ms、PWM 原语看门狗
250 ms。原 PL 校准未就绪/断流/故障、无映射、非法类别和停止命令都会关闭
输出。单轴测试只开放选中的一根信号线。发生故障后不会自动恢复联动。

验证命令：

```powershell
powershell -ExecutionPolicy Bypass -File build/scripts/run_hand_control_test.ps1
powershell -ExecutionPolicy Bypass -File build/scripts/run_pl_control_test.ps1 -SkipVectors
powershell -ExecutionPolicy Bypass -File build/scripts/run_lcd_firmware_test.ps1
powershell -ExecutionPolicy Bypass -File build/scripts/run_sd_record_test.ps1
powershell -ExecutionPolicy Bypass -File build/scripts/run_uart_record_test.ps1
```

仿真覆盖 ACK 跨时钟、默认关闭、单轴隔离、错误范围、不完整映射、PL 类别来源、
双看门狗和停止。实际 PS 源码测试覆盖应答等待、停止优先、超时取消待发使能、
手动超时/页面退出、CRC 错误与备份回退、双分辨率触摸和渲染。
SD 测试覆盖短文件/多余数据、短写、同步/关闭错误及录制互斥。

LCD 预览：`hand_800_0.png` / `hand_800_1.png`，对应标定/映射页。
完整实现与引脚核对结果见同目录构建、时序、资源和 `pwm_pins.tsv` 报告。
旧版资源、DCP、bit、XSA、ELF 保存在 `baseline/`，本轮未先做 FIFO 等资源优化。

## 构建

```powershell
& 'D:/FPGA/VIVADO/2025.2/Vivado/bin/vivado.bat' -mode batch -source build/scripts/add_hand_control.tcl
powershell -ExecutionPolicy Bypass -File build/build_all.ps1 -SkipBoot
powershell -ExecutionPolicy Bypass -File build/boot/build_pl_control_boot.ps1
```

Vivado 2025.2 的 `update_module_reference` 在此工程会拒绝更新，单纯删除重建
仍可能保留旧端口；脚本复用工程已有处理方式，重新索引源文件、清理本模块
生成的 mref 缓存并升级受限 IP 后重建，保留原连线和参数，再核对 GPIO 宽度与方向。
BOOT 打包须通过既有系数、常量 DSP、时序门禁，并核对 XSA、bitstream 与 ELF
加载分区，不能只更新 PS 并沿用缺少 GPIO5 的旧 PL。

首次常量 DSP 门禁拦截了 PWM 的 6 个 `脉宽 × 25 MHz 时钟换算` 常量乘法。
核对实际网表模块、实例、动态输入和常量 25 后，新增仅限这六个实例的例外；
错误常量、滤波模块及未知实例仍拒绝，独立反例测试通过。未跳过滤波系数检查。
XSim 有一次在 PWM 全部断言通过后的退出阶段发生访问异常，完整重跑通过，
原始日志和重跑日志分别保存在 `pl_test.log`、`pl_test_retry.log`。

`report_cdc` 仍有全工程的 Unknown/Unsafe 分类，未宣称 CDC 报告全绿。
本次手控制邮箱采用数据保持至 ACK 的传输：请求与应答双触发器同步，接收端
只在同步请求变化后读取稳定负载；状态字和 ACK 一起快照回传。已检查源码中的
保持条件，并用不相关时钟仿真验证；不能把直接分类为 Unknown 的多位负载等同
于逐位同步后拼接的状态，也不能据行为仿真宣称全工程所有 CDC 已验证。
