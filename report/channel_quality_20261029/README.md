# V18 无静息参考通道评分

版本：`20261029_HAND_CONTROL_HDC_DYNAMIC_QUALITY_V18`。

通道质量不再采集或保存静息参考。每路最终带通有符号波形累积一秒连续样本，在后台完成评分；八路采用相同参数，不依赖开机时的噪声、不与其他通道相互归一化。动作识别用的静息门控属于独立功能。

## LCD

页面显示各路总分、A–D 等级、RMS、残余工频百分比和当前异常原因。触摸通道卡片后，底部显示所选通道四项分数、峰值因子和低频占比。波形、频谱按钮沿用原入口。无数据、不完整窗口和过期结果不展示旧分数；平线评为 D/0 分，处理输出近满量程强制 D。

## 与参考网站的关系

2026-10-29 重新核对公开算法：
<https://www.emglab.cn/js/core/quality.js?v=2.0.0-p7.3.1>。
获取内容与项目 2026-10-25 留存副本相同，SHA256 为 `0805c437f707dfd701c6a9ad55988daeded24a02aa18cd9a48efba15968ec1d5`。独立实现板端统计，未把网站 JavaScript 直接作为固件。

| 项目 | 网站方法 | 本版板端方法 |
|---|---|---|
| 分布 | 最大/最小幅度各 20% 的 RMS 比值，网站标作 SNR | 相同分位幅度对比思路，定标直方图近似，标为“分布”，不声称真实生理信噪比 |
| 工频 | Hann/Welch、谱线 ±2 Hz、3–15 Hz 邻带中位数、MAD 判决 | 同样的邻带谱插值和 MAD 判决；2048 点、50% 重叠两段，1.953125 Hz/bin，固定 50 Hz 及至 200 Hz 谐波 |
| 伪影 | 5 Hz 以下能量、5σ 异常比例、Pearson 峰度 | 固定参数的同类三项组合，权重 40/30/30 |
| 接触特征 | 峰值因子、2–20 Hz 比例 | AC 峰值因子和 2–20 Hz 能量比，权重 60/40 |
| 总分/等级 | 四项等权，关键最差项限制等级 | 四项各 25%；分布/工频/伪影/低频子项按 <80/<60/<30 限为 B/C/D，保留平线和输出满量程硬保护 |

为适配板端吞吐，窗口长度、频谱分辨率和整数化方式不同，不声称与网页分值逐点相同。峰值因子单项不直接封顶，避免把正常短时发力一概认作接触不良。分数是形态筛查的工程指标；宽带噪声也可能得高分，不能只凭分数证明信号来自肌肉。

继续遵循已确认的“使用处理后数据辅助调整电极”：滤波已衰减部分原始工频、低频漂移和前端失真。高分仅说明当前处理输出未呈现明显异常，不证明干电极阻抗、原始共模或原始 ADC 量程正常。“接触”是波形特征，未增加阻抗/导联脱落测量。

## 调度与内存

采集入口只做冻结窗口与基础统计，后台 worker 每次执行至多 128 个采样/FFT 步骤，或一个局部频谱统计。DMA 等待阶段分块执行，并在各块间检查采集；不在解析回调里做整段 FFT。两组八路窗口位于 PS DDR，FFT 工作区共用，不占用新增 PL BRAM。

若后台不及处理，跳过该路后续诊断窗口并累计 `analysis_drops`，不阻塞原始采集、记录和识别。序号丢失会取消正在处理的旧窗口，完成时间与采样时间分离；超过 1.5 秒的结果不继续显示。吞吐调度已进行主机仿真，实际 ARM 时占和长时间 SD 连续记录仍需板上复核。

## 验证与发布

- `quality_test.log`：基础故障/计分边界/频偏/序号回绕、冻结窗口所有权、间断取消、八路并行后台服务测试。
- `numeric_validation.json`：独立 NumPy FFT 与 SciPy IIR 对照，包括合成噪声、谐波、低频伪影、尖峰和三份历史处理波形，共 416 个通道窗口。
- `lcd_test.log`：800×480 与 1024×600 像素、触摸入口、无参考自动评分、过期显示，以及虚拟手/HDC/康复/SD 页面回归。
- `hand_test.log` / `learning_workflow_test.log`：六路控制、上电同步复位、HDC 保护与 PL 学习故障失效回归。
- `baseline/` 保存改动前源码；`regression_sources.json` 绑定当前验收输入。

V18 只改 PS 质量诊断、显示和后台调度，复用 V17 位流/XSA/FSBL、RTL、约束与模型，逐项 SHA256 校验。PL 资源及时序沿用同一已验收实现，不重新综合不变逻辑。`tools/verify_quality_release.py` 严格核对继承关系；`tools/verify_control_boot.py` 检查 BOOT 的位流、应用和 FSBL 加载内容。

```powershell
powershell -ExecutionPolicy Bypass -File build/scripts/run_channel_quality_test.ps1
powershell -ExecutionPolicy Bypass -File build/scripts/run_lcd_firmware_test.ps1
python tools/verify_quality_release.py
powershell -ExecutionPolicy Bypass -File build/boot/build_pl_control_boot.ps1
```

最终启动文件：`build/boot/BOOT_20261029_HAND_CONTROL_HDC_DYNAMIC_QUALITY_V18.BIN`。大小、哈希与内容匹配记录见 `artifacts.json`。本次不写 SD 或下载硬件。
