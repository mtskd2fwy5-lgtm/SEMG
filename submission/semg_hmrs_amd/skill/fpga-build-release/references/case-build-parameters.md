# 案例：参数正确不等于生成物正确

性质：依据原工程代码和日志整理的摘要，不是逐字交互。环境：AMD XC7Z020、Vivado 2025.2；以下路径仅是原工程证据定位，不是使用本技能的依赖。

**失败观察**：RTL 系数看似正确，但 module reference/OOC 包装将部分正参数按字符串解释，实际综合网表系数错误。仅靠行为仿真不能发现全部生成物差异。

**处理方法**：核对实际参数类型/值、解码网表系数、识别异常 DSP 常量，再检查 Routed 时序和启动镜像内容。来源：`build/build_all.ps1`、`tools/verify_coeff_regs.py`、`tools/scan_literal_b.py`、`tools/verify_boot_partition.py`。

**已验证结果**：另一轮冻结合同下，以激活存储、状态分 bank 与共享计数压缩整机 Routed 资源：LUT 36,417→23,793，FF 40,463→24,622，DSP 111→49；相关通路逐周期/网表对照通过，未提高工作时钟。来源：`report/resource_optimization_v15_20261027/README.md`、`report/resource_optimization_v15_20261027/comparison.json`、`report/resource_optimization_v15_20261027/equivalence.log`、`report/resource_optimization_v15_20261027/netlist_test_complete.log`、`report/resource_optimization_v15_20261027/integrated_test.log`。

**复用边界**：适用于核对实际构建输入和同条件优化；原语检查器、BOOT 字序和历史资源数字不可直接移植。软件侧改动也应绑定不变硬件哈希，来源：`report/lcd_responsiveness_20261030/README.md`。数字不代表当前版本资源，也不保证其他工程相同收益。

