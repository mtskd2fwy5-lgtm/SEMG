# 构建、测试与工程维护脚本

本目录保存现有工程的仿真、回归、检查和模块接入脚本。各脚本用途不同，不应按目录顺序全部执行。

## 工程构建入口

| 入口 | 用途与前提 |
| --- | --- |
| [recreate_project.tcl](../recreate_project.tcl) | 从已保存的 HDL、约束和块设计创建 Vivado 工程；目标工程已存在时会拒绝覆盖 |
| [update_project.tcl](../update_project.tcl) | 向已有 Vivado 工程同步当前源码与约束 |
| [build_all.ps1](../build_all.ps1) | 综合实现、参数与网表检查、时序检查及启动镜像流程；跳过选项仅适用于已有产物 |
| [build_pl_control_boot.ps1](../boot/build_pl_control_boot.ps1) | 使用匹配的硬件、Vitis 平台、FSBL 和应用生成并核对 BOOT；需先准备完整平台 |
| [update_learning_platform.py](update_learning_platform.py) | 更新已有 Vitis 平台及应用相关构建，需先准备匹配的平台工作区 |

从工程根目录执行脚本。目标工具为 Vivado/Vitis 2025.2；`AMD_VIVADO_ROOT` 指向包含 `Vivado/` 和 `Vitis/` 的安装目录。部分脚本还需本机编译器、Python 依赖或已生成网表，使用前先核对脚本头部和路径配置。

## 常用验证入口

| 脚本 | 验证范围 |
| --- | --- |
| [run_hdmi_test.ps1](run_hdmi_test.ps1) | HDMI 缩放与视频输出相关模块 |
| [run_hdmi_pipeline_test.ps1](run_hdmi_pipeline_test.ps1) | HDMI 与 LCD 集成数据通路 |
| [run_lcd_firmware_test.ps1](run_lcd_firmware_test.ps1) | LCD 固件、页面导航与交互 |
| [run_hdc_model_test.ps1](run_hdc_model_test.ps1) | HDC 模型存取及相关固件回归 |
| [run_learning_test.ps1](run_learning_test.ps1) | PL HDC/NMF 学习加速器与工作流 |
| [run_imu_test.ps1](run_imu_test.ps1) | MPU 姿态计算及接口 |
| [run_hand_control_test.ps1](run_hand_control_test.ps1) | 机械手目标提交、复位与输出保护 |
| [run_sd_record_test.ps1](run_sd_record_test.ps1) | SD 录制相关逻辑 |
| [run_line_filter_sim.ps1](run_line_filter_sim.ps1) | 工频及谐波滤波链 |
| [run_quality_button_test.ps1](run_quality_button_test.ps1) | 通道评分与界面后台调度 |

测试通过只覆盖对应脚本实际执行的范围。行为仿真、综合网表、布局布线、主机固件测试和实板运行需要分别核对。

## 接入与维护脚本

`add_*.tcl` 用于向已有块设计添加或修改特定模块，`rebuild_*.tcl` 用于指定模块或工程重建，`audit_*.tcl` 用于检查已有实现。这些脚本保留了工程演进用途；当前块设计已包含的模块无需重复添加。优先使用上表中的构建入口，并按实际问题选择维护脚本。
