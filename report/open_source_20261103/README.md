# 开源整理记录

项目所有者于 2026-11-03 授权原创项目内容采用 Apache-2.0。许可范围由 `LICENSE`、`NOTICE` 与 `THIRD_PARTY_NOTICES.md` 说明，第三方内容保留原有条款。本次保留原有 Git 历史，不重写历史或强制推送。

本轮整理包含当前 RTL、固件、测试平台、生成工具、模型资料、四类 FPGA 开发技能、选定发布证据，以及 `report/design_report/design_report.docx` 设计报告。本机参考资料、大量导出波形、编译输出、FPGA 构建缓存和新生成的启动镜像未加入。

## 本轮记录的验证

以下为本轮开源整理时留下的验证记录，不表示翻译本说明时重新执行：

- HDC 模型存储、SD 录制、串口帧、PL 后端工作流与生产机械手固件：执行 `run_hdc_model_test.ps1`，日志保存在本目录。
- LCD 固件：同轮回归覆盖两种屏幕尺寸、页面生命周期、HDC 稳定结果共享、机械手连续跟随与模型切换。
- PL 学习加速器：`run_learning_test.ps1` 的 NMF 逐位一致性、Q16/Q32 学习与推理、AXI 故障、超时和重试检查通过。
- PL 机械手控制器：`run_hand_control_test.ps1` 的原子复位与目标提交、来源隔离、看门狗、停止与急停检查通过。
- 通道质量与界面调度：`run_quality_button_test.ps1` 的 C 与 NumPy/SciPy 对照及后台工作限额检查通过。
- 可移植技能包：`skill/validate_package.py` 与 `skill/test_portable_tools.py` 检查通过。
- README 与许可元数据修改前，已有 V30 发布一致性检查通过。历史发布清单仍为历史快照，其中记录的 README 哈希不改写为当前内容的哈希。
- 对可达 Git 历史和暂存内容扫描了高置信度凭据特征；该扫描不等同于全面安全审计。

HDMI 镜像发布包含新的布局布线、XSA/平台更新与匹配 BOOT 检查。HDMI 实际显示、SD 实际写入、实时采集时的 DDR 竞争及电气隔离仍需分别进行实板验收。换用其他电脑时仍需配置本机工具路径，本轮记录不代表已完成干净环境下的端到端重建。
