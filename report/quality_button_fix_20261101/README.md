# V24 板上缺陷修复：按键全通道检查只显示一个通道（V25）

- BOOT：`build/boot/BOOT_20261101_HAND_CONTROL_HDC_DYNAMIC_QUALITY_BUTTON_V25.BIN`
- 基线：V24（`report/quality_button_20261101`，哈希绑定见 `baseline/manifest.json`）
- 日期：2026-11-01

## 现象

V24 上板实测：在通道质量页按下"全通道检查"后，八路中只有一路显示评分，
其余通道显示"无数据"。

## 根因（代码分析结论，共三层）

1. **结果丢失（主因）**：检查提交时 `cq_result_ok` 读取的是易失的
   `channel_quality[ch].valid`。检查期间任一通道的 type-5 流出现一次
   序号跳变/断流，`cq_ingest` 的 gap 分支就会把该通道的 `valid` 清零——
   包括早已算完并发布结果的通道。八路的 worker 按序处理，只有最后一路
   完成时距提交仅数微秒，来不及被清 → 恰好只剩一个通道有数据，与板上
   现象一致。板上存在周期性序号回跳（2026-10-09 取证：maxjump=-127），
   V23 时代的"分通道翻无新数据"闪烁是同一机制的旁证。
2. **吞吐不足（次因）**：`cq_background_tick` 每次空闲机会只推进一个
   32 步 chunk。V23 连续模式在 30% CPU 预算下仍跟不上实时，证明瓶颈是
   机会数而非预算；检查需约 9700 个 chunk，靠逐机会单 chunk 在超时内
   排不空八路窗口。
3. **超时常量溢出（本轮新发现）**：`15000u*333333u` 超过 u32 上限，
   回绕成约 2.1 秒——比采集 1 秒窗口本身还短，任何慢路径都会被误判
   超时。V24 的 `8000u*333333u` 未溢出，因此该缺陷在 V24 上未显现。

## 修复

- `channel_quality.h`：
  - 每通道结果在 stage 8 完成时锁存进 `cq_check_valid` 位图，提交只读
    锁存位，对检查期间的 gap 抹除免疫；
  - 超时改为 `12000u*333333u`（u32 tick 可表达上限约 12.87 秒，注释
    说明约束）。
- `main.c` `cq_background_tick`：一次空闲机会在 2.5 ms/5 ms 墙钟配额内
  连发多个 chunk（do-while burst），`cq_work_pending()` 防空转；配额、
  而非机会数，成为唯一瓶颈。
- `BUILD_TAG` → `..._QUALITY_BUTTON_V25`。

## 回归验证（本目录日志）

- `quality_test.log`：新增"检查期间 gap 抹除"回归——7 路已提交后对
  ch0 注入序号跳变，确认易失 `valid` 被清而八路 `cq_result_ok` 全部
  保持（旧代码该断言失败）。
- `budget_test.log`：调度测试改为 burst 语义断言，并新增八路同检的
  预算路径完成断言（旧测试只喂单通道且固化"每机会一个 chunk"，从未
  覆盖八路预算路径——这是 V24 的测试盲区）。
- `numeric_validation.log`：C/NumPy/SciPy 数值对照不变。
- `lcd_test.log` / `imu_test.log` / `hand_test.log` /
  `learning_workflow_test.log`：LCD/IMU/手控/学习链回归全过。
- `regression_sources.json`：78 项源码哈希绑定。

## 上板状态

未上板。修复对两个根因各自免疫（锁存位不受 gap 影响；burst 使吞吐只受
配额限制，模型推算八路约 60 ms CPU 即可排空），但需重新烧写 V25 BOOT
实测确认：按下后约 1 秒内八路同时出分。若仍异常，开 'd' 观察 [STAT] 的
`quality_calls` 增长率与 `gaps` 计数。
