# AMD 选题指南提交核对

本文件记录当前整合包对 AMD FPGA 自主选题赛道提交要求的对应关系。历史阶段性核对保留在旧日期目录中，不作为当前包状态的唯一依据。

| 指南要求 | 当前提交位置 | 核对结果 |
| --- | --- | --- |
| 完整工程源码 | `src/`、`sw/ps_uart_print/`、`board/`、`build/` | 已收录 PL RTL、PS 固件、约束、规范化 BD/IP 输入和构建入口 |
| 仿真与参考对比 | `sim/`、`tools/`、`report/submission_evidence/` | 已收录 RTL/主机回归、HDMI 测试、定点与资源比较工具及选定证据 |
| 综合实现和板级证据 | `report/submission_evidence/` | 已收录布线时序、资源、DRC/CDC、方法学、平台与固件回归日志；物理 HDMI 和人体采集隔离仍按 README 标注为板级验收项 |
| 可复现构建 | `build/recreate_project.tcl`、`build/build_all.ps1`、`build/scripts/` | 使用包根相对路径；Vivado/Vitis/bootgen 通过 `AMD_VIVADO_ROOT` 或 PATH 定位 |
| 大模型协作记录 | `report/ai_collaboration_20261023/`、本目录 | 保留原始记录索引与整理说明；不把摘要冒充逐字交互，不包含系统指令、内部推理或凭据 |
| 可复用技能包 | `skill/` | 提交通用 FPGA 构建发布、流式验证、PS/PL 联调和设计报告四项技能，附模板、案例、脚本、验证和失效条件 |
| 设计报告 | `report/design_report/design_report.docx` | 与提交包源码和证据一并收录 |
| 开源与第三方许可 | 根目录 `LICENSE`、`NOTICE`、`THIRD_PARTY_NOTICES.md` | 原创内容采用 Apache-2.0；AMD 工具/IP、字体和其他第三方内容沿用其许可 |

## 复现边界

`python skill/validate_package.py` 和 `python skill/test_portable_tools.py` 在无厂商工具环境下验证包结构、链接、Python 语法和通用工具行为。Vivado/Vitis 构建需安装匹配版本并设置 `AMD_VIVADO_ROOT`；实物显示、SD 写入、人体采集隔离和舵机接线不能由主机仿真替代。

整合包由 `tools/assemble_submission.ps1` 生成到 `submission/semg_hmrs_amd/`，同时提供带 SHA256 的压缩包。包内排除原始人体数据、临时波形、工具缓存、编译输出、位流、BOOT 和开发机绝对路径。
