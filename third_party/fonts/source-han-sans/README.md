# 思源黑体

本项目 LCD 中文使用 Adobe 思源黑体简体中文常规体（Source Han Sans CN Regular），
采用 SIL Open Font License 1.1。分发字体及其生成字模时保留本目录的 LICENSE.txt。
OFL 允许商用、嵌入和分发；使用此字体不会要求设备软件本身开源。

来源：https://github.com/adobe-fonts/source-han-sans

固定版本：a4f7cf94edfb9d7ffbdfc4841de276358bd7e0f2

原始文件：SubsetOTF/CN/SourceHanSansCN-Regular.otf

生成：安装 Pillow 后运行 `python tools/gen_hz_glyphs.py`，或原 PowerShell 入口。
固件仅包含当前界面所需字符的 16、20、24、32 像素四种字号、4 位灰度字模，
无需把完整字体加载到板端。生成器不会使用或回退到微软雅黑。

中英文与数字在同一字号下使用同一字体和基线，字模保留原始纵向偏移，
不再逐字居中或单独缩小英文字体。行框高度包含下伸笔画；
当前 16/20/24/32 像素字模的行框高度分别为 19/24/28/37 像素。
控件按完整行框居中；不同字号的同行字段使用明确的共同基线。
字体生成验证：`python sim/test_lcd_font.py`。
