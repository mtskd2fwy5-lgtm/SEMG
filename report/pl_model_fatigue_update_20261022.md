# 多佩戴 PL 模型与疲劳等级稳定更新

日期：2026-10-22。

## 多佩戴识别模型

`data/models/nn_int8_board_multiwear/` 保存了 EMG008/009 为主、加入 EMG012–016 后的 INT8 权重与软件黄金向量。已将 `emg_nn_infer` 默认 BRAM 初始化文件切换到该目录；原有 NinaPro 和实验模型权重未覆盖。

EMG017 完整留出测试：浮点准确率 88.85%，INT8 准确率 87.84%，两者窗口预测一致率 97.86%。这是一个新佩戴记录的评估，不代表所有重佩戴条件。权重映像通过 64 个窗口、每窗 5 logits 和类别输出的 XSim 逐项比较。

## 疲劳等级防抖

疲劳 MDF 和频谱仍每个 2048 点窗（约 512 ms）更新。仅在 RTL 疲劳等级输出处增加三级连续确认：候选等级连续三个窗一致后才改变显示状态，约 1.5 秒确认时间，约比首个候选晚 1.0 秒。MDF、斜率和频谱数据没有平滑或延迟。

同步更新 `tools/gen_fatigue_mem.py` 的黄金模型。224 个疲劳/频谱输出字通过 XSim 对照，全部一致。

## Hann 窗对照

使用 EMG008、EMG009、EMG017 的处理后稳定标注片段，按 2048 点非重叠窗计算 20–450 Hz MDF，对比矩形窗和 Hann 窗。Hann 的相邻窗 MDF 绝对变化中位数/95 分位均未下降：

| 记录 | 矩形窗中位 / P95 (Hz) | Hann 中位 / P95 (Hz) |
|---|---:|---:|
| EMG008 | 5.86 / 16.60 | 6.84 / 20.61 |
| EMG009 | 4.88 / 16.60 | 5.86 / 23.44 |
| EMG017 | 3.91 / 13.67 | 5.86 / 18.55 |

因此当前固件不加入 Hann：在这些实际片段里没有观察到抑制 MDF 跳动的改善，反而更差。该离线比较使用已处理波形，疲劳模块的输入高通略有不同；它不足以证明所有记录都如此，但足以说明不能仅凭谱泄漏理论就加入 Hann。

## 产物与验证

- 浮点模型：`data/models/emg008_009_multiwear.joblib`
- INT8 权重：`data/models/nn_int8_board_multiwear/nn_int8_weights.mem`
- 量化参数与软件指标：`data/models/nn_int8_board_multiwear/quant_params.json`、`data/metrics/nn_int8_board_multiwear.json`
- 导出器：`tools/export_board_int8.py`
- 疲劳回归：`tools/gen_fatigue_mem.py` + `build/scripts/run_fatigue_sim.bat`，224/224 字通过。
- 分类器回归：`build/scripts/run_nn_infer_sim.bat`，64/64 窗口通过。

## PL 构建门禁

2026-10-22 全量 Vivado 构建和 BOOT 打包完成，`build/build_all.ps1` 的五项门禁全部通过：

- G1 参数绑定：6 个保护参数均按 RTL 整数值绑定。
- G2 系数网表解码：全部正确。
- G3 DSP 常量扫描：无 literal-B DSP、无错误常量命中。
- G4 布线时序：全部约束满足，WNS=0.432 ns，WHS=0.054 ns。
- G5 BOOT 分区：BOOT.BIN 内 bitstream 与新 bitstream 字节校验一致。

可用于启动 SD 卡的映像：`build/boot/BOOT.BIN`（4,655,668 字节，2026-10-22 19:31:41 生成）。
