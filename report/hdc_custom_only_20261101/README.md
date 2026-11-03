# HDC 自学习改为纯自定义手势（V27）

- BOOT：`build/boot/BOOT_20261101_HAND_CONTROL_HDC_DYNAMIC_CUSTOM_ONLY_V27.BIN`
- 基线：V26（`report/system_name_20261101`，哈希绑定见 `baseline/manifest.json`）
- 日期：2026-11-01

## 变更

去掉 HDC 板上自学习流程中固定的 5 个基本手势类（放松/张手/握拳/屈腕/伸腕），
**板上自学习的每一个类别都是用户自定义手势**。PL 分类器（监测页"来源 MLP"、
自校准页、康复训练页）不受影响。

### 学习流程（hdc_learning.h）

- `hdc_begin` 的类数参数即自定义类数，不再 +5；清空重学默认从 1 类起步，
  "新增手势"在现有类之后追加（`hdc_custom=hdc.classes`）。
- 删除同窗 MLP 参照统计（`mlp_cm[5][5]`/`trial_mlp`/`latest_mlp`），
  `hdc_window` 去掉 mlp 参数；学习页"HDC原5/MLP原5"统计与 CSV mlp 行删除。
- 类名统一为 `自定义N`（N 从 1 开始），导出键为 `customN`。

### 模型库快照（hdc_model_store.h，contract 0x07105003 → 0x07105004）

- 文件格式去掉 25 词 5x5 MLP 参照表；类别下限 5 → 1。
- 旧 HMD1 快照在头部 contract 校验即被拒绝（错误 0x402），需重新学习。
  （板上模型本就要求重新佩戴学习，不保留旧快照兼容。）

### 手控映射行空间（lcd_hand.h / hand_control.h）

- 行 0-2 仍是 PL 基本三姿态（放松/张手/握拳，供"来源 PL"联动与
  `hand_upload` 上传，未改动）；自定义类 c 占行 c+3。
- 删除原类 3/4（屈腕/伸腕）"保持上一姿态"特例及 `hand_hdc_pose` 缓存：
  未映射的自定义手势只识别不动手。

### 虚拟关节页（lcd_virtual.h / lcd_hdc_models.h）

- 可编辑行从类 5 改为类 0 起步；实时联动仅对已映射自定义类生效。

## 回归验证（本目录日志）

- `quality_test.log` / `budget_test.log` / `numeric_validation.log`：质量与
  UI 预算回归在最终源码上复跑全过。
- `lcd_test.log` / `imu_test.log`：LCD/IMU 全量回归（8 个自定义类完整学习/
  验证/保存/联动流程，800x480 与 1024x600 双面板）。
- `hand_test.log`：手控行空间重排后的映射/联动/队列回归。
- `learning_workflow_test.log` / `hdc_learning_test.log` / `model_test.log` /
  `pl_control_test.log`：PL 学习后端、纯自定义类动态增长与原子 OOM、
  模型编解码与损坏拒绝、PL 邮箱权威性回归全过。
- `sim/test_hdc_learning.py`：C/NumPy 编码-原型-预测-裕量-质心逐位奇偶
  校验通过（8 类合成与 23 类动态回放）。
- `regression_sources.json`：全部源码哈希绑定。

## 上板状态

未上板。需烧写 V27 BOOT 确认：自定义手势从 1 类起步学习并可新增、
手控页"动作映射"行为 0-2 基本姿态 + 自定义类、模型库另存/加载、
旧模型快照被拒绝提示重新学习。
