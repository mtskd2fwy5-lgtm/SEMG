# PS 决策迁入 PL：第一阶段（2026-10-23）

本次迁移维持现有模型、特征顺序、置信度表和动作确认规则。适配采样引导、六候选评分及独立验证仍由 PS 执行；验证通过后，选中的 CH4→CH1→CH2→CH3→CH5→CH6 环移直接作用于 PL 的归一化前输入，CH7/CH8 不动。没有迁移为在线更新模型权重，也没有实现论文中的完整连续 SAL 优化。

## 结构及运行约定

- `emg_control_inference.v`：完整 40 字特征窗口校验、配置快照、六种映射、原 INT8 MLP；不等待 DMA ready。
- `emg_control_policy.v`：80 窗丢弃、16 窗静息均值、阈值 `max(3*baseline,1000)`；保留 PS 的 uint32 溢出和比较语义。Q20 softmax 与 PS 共用生成常量，逐类整数除法；新动作 70%、维持/静息 50%，动作确认 3 窗、静息 6 窗、不确定最多 8 窗。序号不连续时重置连续计数。
- `emg_pl_export.v`：新增参数 `CONTROL_ENABLE`，默认 0 保持原链路；当前 BD 使用 `emg_pl_control` 适配器启用独立链路。DMA 背压只影响遥测，不能停住特征消费或决策；丢失通过既有 overflow 信号报告。
- `emg_pl_control.v`：PS AXI GPIO 与 25 MHz PL 的双向确认邮箱，双触发器同步控制位，载荷保持到确认；窗口开始时锁定映射及 epoch。
- PS `pl_control.h`：配置排队、确认和 epoch 校验。LCD、康复训练使用 PL 的最终 accepted word，不再重复门控/时序平滑。PS 静息均值仅作显示/报告镜像，若特征遥测丢失，其数值不能替代 PL 基线。
- 连续 250 ms 无有效新特征/推理触发 stale；协议错误锁存 fault，重新静息校准可复位。stale/fault 阻止 PS 采用后续遥测并停止康复有效计时。界面显示静息校准、等待数据、配置确认或决策异常。

映射适配仍需两轮真实标注，只有独立验证至少提高 3 个百分点才应用非零偏移；上电不保存映射。模型本身准确率不因本次迁移自动提高，迁移目的是等价决策及消除 PS/DMA 对决策的依赖。

## 接口

新 AXI GPIO 地址：`0x41240000` command，`0x41240008` status（双通道，前者全输出、后者全输入）。旧固件默认不访问新地址，必须使用匹配 PL 与 PS 的镜像。

command：bit31 request toggle；7:4 epoch；bit3 recalibrate pulse；2:0 shift。PS 发送后保持，直到 ack、epoch、shift 均匹配；期间后续请求排队合并，复位请求不会被映射请求覆盖。

status：31:16 magic `0x504c`；bit15 ack toggle；11:8 epoch；6:4 shift；bit3 fault；bit2 stale；1:0 校准阶段。

type3/id6 最终决策，sequence 为窗口起点：31:28 epoch；bit27 stale；26:24 shift；bit23 valid；22:21 校准阶段；20:14 候选置信度；13:11 候选类别；bit10 门控；9:3 最终动作置信度；2:0 最终动作。原 id0–5 logits/argmax 继续遥测，不能作为执行依据。R 行输出候选类别及对应置信度，P 行保持最终动作协议；门控改为静息时 R 的 p 对应静息类分数。

`b` 串口诊断增加 `[PLCTRL]`：状态字、epoch、shift、待确认状态、已接受/拒绝包数。监测/二进制录制仍使用原模式；录制时消费 id6 更新本地状态，不混入文本。

## 机械手边界

`hand_servo_pwm.v` 为独立的六路 PWM 原语，20 ms 同步帧、目标范围检查、每帧限步、指令超时和急停锁存。未实例化到 BD，未分配引脚，没有动作到脉宽表，也没有连接机械手。500–2500 μs 是原协议范围，不能代替六个舵机的实际机械限位。初次使能直接采用首个有效目标，限速只约束后续帧；再次使能前需要确认实际起始位置。停止 PWM 不保证舵机卸力，实物急停还需电源措施。

## 验证

- 实际 `main.c` 编译为独立 C oracle，与 XSim 逐窗口对照 28,228 窗：7,500 合成边界/序号/溢出窗口，EMG008 4,104 窗、009 10,078 窗、015 2,171 窗、018 有效前段 4,375 窗。全部置信度、最终/候选类别、门控、计数及校准阶段一致。这是实现等价性验证，不是新的独立识别准确率评估。
- 384 窗完整特征→映射→MLP 测试覆盖六种映射，与 INT8 参考所有 logits 一致；检查窗口中途修改配置仍使用原快照、CH7/8 固定、序号回绕、stale、错误特征及复位。
- 实际 PL shell 停止 AXI 接收至 feature/result FIFO 溢出，仍按窗完成决策；检查接收恢复、id6 导出、异步命令确认、无流时重新校准。
- 六路 PWM 测试：关闭默认无输出、脉宽、原子更新、限步、非法命令与帧边界、超时、急停锁存。
- 实际固件 mock MMIO 测试：握手与 epoch、拒绝旧配置、PL 决策优先、PS 门控不重复执行、原 argmax 不能旁路、stale 及请求合并。
- 原完整 ADC/滤波/特征/推理回归：6,400 raw、6,400 processed、200 feature 字及 5 个推理窗口逐位一致。其校验脚本原先硬编码旧模型目录，本次改为读取 RTL 默认 MEM_FILE 的同目录 quant_params，避免错误对比。
- 原 LCD 双分辨率、触摸、康复、通道质量、波形/频谱、帧缓存/字体与串口二进制回归通过；ARM 编译通过，仅供应商 FatFs 中原有 unused vol 警告。

重跑：`powershell -ExecutionPolicy Bypass -File build/scripts/run_pl_control_test.ps1`。`-SkipVectors` 仅在参考代码和数据未改动、已有有效向量时用于缩短迭代。

## 编译与硬件状态

BD 配置、全系统综合/实现及候选 BOOT 的最终结果见本目录构建记录与 artifacts.json。尚未完成实机验证，尚未写入 SD 卡。不要把新 PS ELF 与旧 bitstream 混用。

复建顺序：运行 `build/scripts/add_pl_control_gpio.tcl` 更新接口；`build/build_all.ps1 -SkipBoot` 完成整机验收；`build/boot/build_pl_control_boot.ps1` 编译匹配 PS 并生成独立命名的 `BOOT_20261023_PL_CONTROL_V1.BIN`。默认旧 BOOT.BIN 不被该脚本覆盖。

后续版本说明：上述文件名对应本轮历史产物；加入握拳反馈后，当前源码及打包脚本默认生成 `BOOT_20261023_GRIP_FEEDBACK_V1.BIN`，见 `../grip_feedback_20261023/README.md`。复建历史版本须使用匹配的历史 PS 源码，不能仅改文件名或构建标签。

### 本次最终构建结果

- `BOOT_20261023_PL_CONTROL_V1.BIN`：4,901,452 字节，SHA256 `9865de200eb8dbedf5838b9d5c85ec749d6d68027425423e48d7ca8ede678f31`。XSA 内的 bit 与当前实现逐字节相同；BOOT 内完整 PL 分区及 PS ELF 的全部非空 PT_LOAD 段匹配。记录见 `artifacts.json`、`boot_build.log`。
- G1 参数绑定、G2 系数寄存器译码、G3 DSP 常量、G4 布线时序全部通过。G3 新增了严格限定到 `emg_control_policy/numerator_reg` 的合法乘数 100（置信度百分比），并通过解析器回归；没有放开其他 DSP 常量检查。
- Routed WNS **+0.320 ns**、WHS **+0.002 ns**；新控制内核最差 setup 路径余量 +17.184 ns。WHS 很小，不应据此推断后续改动仍能通过时序。
- LUT 38,368/53,200（72.12%），FF 34,002/106,400（31.96%），Slice 12,467/13,300（93.74%），BRAM 29.5/140，DSP 95/220。相对之前实际基线增加 LUT 1,945、FF 1,613、DSP 3；Slice 利用率已高，后续扩展应重新验证布局布线。
- 原默认 `build/boot/BOOT.BIN` 仍为 4,733,316 字节、修改时间 2026-10-23 02:26:05，本次没有覆盖，也没有写 SD 卡。

### 跨时钟及告警核对

`cdc_routed.rpt` **不是零告警报告**：CDC-1 22,576、CDC-2 4、CDC-3 19、CDC-6 14、CDC-9 2、CDC-10 1、CDC-13 149、CDC-15 166。计数包含大量复位扇出、分布式异步 FIFO 数据路径和显示/触摸/MPU 接口，不能仅凭时序通过宣布全部 CDC 合格。本次只完成新增决策邮箱的定向核对，未对原全系统 CDC 做完整签核，也未新增 waiver。

- 四个请求/确认控制位均被识别为带 ASYNC_REG 的同步结构。邮箱载荷按握手保持，接收端在两级请求同步后才采样；状态源保持到确认返回。命令的 recalibrate 位为同一握手载荷，其“CDC-1”来自无 CE 的脉冲生成结构，不是单独异步脉冲输入。
- 用 `report_pl_control_mailbox.tcl` 对当前 routed DCP 执行 `report_timing -user_ignored`，不修改约束或 DCP：覆盖命令 8 个目的寄存器、状态 11 个实际非恒定目的寄存器。命令最大数据延迟 **1.393 ns**，状态最大 **1.613 ns**，小于相应 40 ns/10 ns 目的周期，更小于两级同步等待时间。异步组使这些路径不参与普通 setup/hold 签核，因此本结果是当前布线的单独核对，未来重新布线必须重查。
- PDRC-190 指向 `ack_sync_reg` 后的 AXI GPIO 输入同步级；两端时钟引脚实查均为 `clk_fpga_0`（100 MHz），见 `mailbox_audit.log`。这条告警不代表 ack_sync 之后又跨了异步域。
- 现有 XPM 显示 FIFO 的 4 项 bus-skew 均满足，余量 9.047/9.322/9.148/9.224 ns；并非对所有自定义 FIFO 的额外认证。
- 剩余复位释放、LCD 外部 IO 约束以及其他既有 CDC 告警保留在报告中；完整设计仍须结合实机验证。本镜像是候选版本，不是机械手实物验收版本。

### 上板验证

1. 保留 SD 卡原 BOOT.BIN 的备份，将本候选镜像复制到启动卡并命名为 BOOT.BIN，断电后重启；不要单独混用新 ELF 与旧 bit。
2. 放松静止，确认 LCD 识别状态从静息校准进入有效识别；依次检查静息、张手、握拳、腕屈、腕伸，核对动作和置信度。原适配引导仍在 PS，保持两轮独立采样和验证流程。
3. 发送小写 `b` 查看 `[PLCTRL]`：magic 正常、pending=0、ready=1、stage=2；采样中 accepted 应增长。进行一次静息重新校准，检查重新进入校准后恢复。
4. 对照测试监测、波形录制、SD 保存、康复训练及重新适配，确认 UI/记录模式切换后识别继续更新。若显示等待数据/决策异常，保存上述诊断输出，不绕过门控。
5. 本次不接机械手。六路 PWM 原语没有引脚和动作脉宽表，需另行确认实际安全端点、供电/电平及急停后再集成。
