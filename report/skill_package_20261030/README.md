# 技能包整理验收

交付入口：[skill/README.md](../../skill/README.md)。依据用户纠正，以通用 FPGA 开发为主线，重整为构建发布、流式数据验证、PS/PL 联调和设计报告四项技能；应用特定材料降为可选历史案例。另有两份核对表、24 项踩坑清单、一个案例模板及两个独立标准库脚本。每项列明场景、输入/使用/输出、观察来源、已验证效果与失效条件。

重新生成的独立交付包：[FPGA_Development_Skills_20261030.zip](FPGA_Development_Skills_20261030.zip)。新增四份可填写任务/提示词/验收模板、三份人工示例、原始证据哈希索引与标准库包自检。案例收短为观察/方法/验证/边界，文件名按 FPGA 问题命名；所有 Markdown 链接均在包内，无原工程运行依赖。

- `validation.json`：运行 `python -X utf8 report/skill_package_20261030/validate.py` 可重现；包括独立工具测试、四项官方格式校验、链接检查、源文件与证据 SHA256。
- `distribution.json`：运行 `python -X utf8 report/skill_package_20261030/build_package.py` 生成 ZIP 并核对逐文件字节、压缩完整性和清单哈希；在临时解压目录运行标准库自检与两个通用示例，另验证篡改示例后自检会拒绝。包中 `package_manifest.json` 不包含其自身哈希。
- `installation.json`：四个技能安装到本机个人 Codex skills 目录；记录安装副本与仓库源文件逐项哈希比对及已安装入口的格式校验。
- `validation_project_specific_v1.json` / `installation_project_specific_v1.json`：上一版项目专用技能的历史验收快照，路径/哈希对应当时目录，不代表本次通用版；旧本机技能先核对哈希再移至个人技能目录之外的备份区。
- `installation_generic_v1.json`：通用版首次安装的历史快照；本次新增模板和案例更名后再次核对既有副本、归档并安装，当前一致性以 `installation.json` 为准。
- `real_csv_smoke.json`：真实录制 processed CSV 前 10,000 行的格式与连续性检查；无缺号、重复或倒退。不重做全程质量分析，也不作为模型验证。

本轮没有运行新的 FPGA 构建或实板测试，未改变固件。历史结果按各自报告引用；本轮验证技能结构、工具行为、引用和安装一致性。两个脚本另外复制到临时目录、从非工程工作目录运行，验证不依赖当前仓库。该测试不等于陌生队伍/新代理端到端复用或跨板卡验证。案例明确为整理摘要，不能替代完整协作原文。

仅在本地整理与安装，没有暂存、提交或推送 Git；交付目录中的未跟踪文件仍需随最终作品包纳入。
