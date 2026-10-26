# 下一轮手指与组合手势采集

本轮准备扩展人工采集标签和离线候选模型，不会改变现有 PL 的五分类识别器。当前没有这批新增动作的真实波形，因此尚未训练或部署 14 类模型。

## 动作标签

编号 1–5 保持旧含义；6–14 是新增标签。单指动作按已确认的定义执行：只伸出目标手指，其余手指自然屈曲。腕部组合动作在握拳状态下分别屈腕、伸腕。多指组合为拇指/食指/中指的两指及三指同时伸出。

| ID | 动作 | 执行定义 |
|---:|---|---|
| 1 | 放松 | 手和腕自然放松 |
| 2 | 张手 | 五指伸展，腕中立 |
| 3 | 握拳 | 握拳，腕中立 |
| 4 | 屈腕 | 手指自然放松，腕屈曲 |
| 5 | 伸腕 | 手指自然放松，腕伸展 |
| 6 | 拇指伸出 | 仅伸拇指，其余手指自然屈曲 |
| 7 | 食指伸出 | 仅伸食指，其余手指自然屈曲 |
| 8 | 中指伸出 | 仅伸中指，其余手指自然屈曲 |
| 9 | 握拳屈腕 | 保持握拳并屈腕 |
| 10 | 握拳伸腕 | 保持握拳并伸腕 |
| 11 | 拇指+食指 | 同时伸出拇指和食指，其他手指屈曲 |
| 12 | 拇指+中指 | 同时伸出拇指和中指，其他手指屈曲 |
| 13 | 食指+中指 | 同时伸出食指和中指，其他手指屈曲 |
| 14 | 拇指+食指+中指 | 同时伸出这三指，环指和小指屈曲 |

采集标签定义集中在 `tools/capture_actions.py`，并生成 LCD 用的 `sw/ps_uart_print/capture_actions.h`。LCD 的 SD 采集界面分为“基本动作、单指腕部、多指组合”三页；标签编号写进现有每帧动作字段。旧 SD 文件头 schema=0 继续按旧编号解码，新文件头 schema=2 表示扩展标签。

## 采集建议

- 每个动作覆盖轻度和舒适力度，力度档写在采集清单中，不当作分类标签或真实测力值。
- 每轮交错动作顺序。每个动作保持 4–6 秒，前后放松 3–5 秒；另留短的未标注过渡段。
- 手腕中立时采集张手、握拳和单指/多指动作；屈腕、伸腕只用于对应动作。不要为了“纯动作”强行掰住其他手指，无法独立伸展时如实记录自然联动。
- 每个动作至少跨多个重复段采集，并保留完整 raw 与 processed 波形。SD 记录包含两路信号；PC 采集建议 `--signal processed --keep-all --plot`，CSV 旁的 JSON 元数据须与 CSV 一起保留。
- 记录佩戴编号、动作标签、主观力度档、电极接触/凝胶情况和固件。过渡/空白段标为未标注，不记成放松。
- 至少留一整次重新佩戴作最终测试。训练和测试按完整佩戴分组，不能随机拆分相邻窗口。

PC 记录示例（raw 与 processed 同步保存）：

```powershell
python tools/record_uart.py --port COM16 --enter --signal raw --save-both --plot --keep-all --subject s30 --session g1
```

`--save-both` 通过现有参考滤波器从 raw 派生 processed，并对时间戳缺口重置滤波状态；它与板端实时滤波系数一致，但采集开始处的滤波初始状态可能不同。训练使用同名 processed CSV 和对应 JSON sidecar。

绘图模式中按 `1`–`9` 或 `A`–`E` 标记动作，`0` 设为未标注，`Q` 保存。LCD 上先切换采集标签页，再触摸对应动作；开始记录后动作标签随帧写入 SD。新的 PL-control 应用标签为 `20261023_GESTURE_CAPTURE_V1`，生成的独立 BOOT 不覆盖默认 BOOT。

## 离线训练

准备 UTF-8 CSV 清单，路径可相对仓库根目录；每个 `wear_id` 只能属于 train 或 test 之一：

```csv
path,wear_id,split,effort
data/captures/wear_a_processed.csv,wear_a,train,light
data/captures/wear_b_processed.csv,wear_b,train,comfortable
data/captures/wear_c_processed.csv,wear_c,test,comfortable
```

清单中的每个完整数据集都须包含足够的连续 processed 样本；训练集与测试集汇总后都必须覆盖全部 14 类。UART 格式还需同名 JSON sidecar，声明 `signal=processed` 与 `action_schema=2`。运行：

```powershell
python tools/train_gesture_model.py --manifest data/captures/gesture14_manifest.csv --out-dir data/models/gesture14_candidate_20261023
```

工具会输出离线候选权重与分佩戴测试指标，拒绝同一佩戴跨集合、重复内容和缺少类别的输入。它使用现有 4 kSPS、400 点窗口、100 点步长和 40 维特征；输出明确标记 `pl_compatible=false`。评估通过前仍由原五分类 PL 模型运行。14 类结果流、置信度、姿态映射和固件加载契约还需单独设计与验证，不能只替换权重文件。
