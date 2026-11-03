"""Report-facing functional architecture; exports checked PNG/SVG/vector PDF.

Run from any directory. The diagram reflects the V17 PL-attitude deployment.
It is a functional block diagram, not a board wiring or isolation certification.
"""
from pathlib import Path
import json
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
from matplotlib.patches import FancyBboxPatch, FancyArrowPatch
from matplotlib import font_manager

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / 'report/system_block_20261028'
OUT.mkdir(parents=True, exist_ok=True)
W, H = 2000, 1360
FONT = font_manager.FontProperties(fname='C:/Windows/Fonts/msyh.ttc')
BOLD = font_manager.FontProperties(fname='C:/Windows/Fonts/msyhbd.ttc')
FONT.set_family('Microsoft YaHei')
BOLD.set_family('Microsoft YaHei')
BOLD.set_weight('bold')
plt.rcParams.update({'pdf.fonttype': 42, 'svg.fonttype': 'none',
                     'font.family': 'Microsoft YaHei', 'axes.unicode_minus': False})
fig = plt.figure(figsize=(16, 10.88), dpi=125, facecolor='white')
ax = fig.add_axes([0, 0, 1, 1])
ax.set_xlim(0, W); ax.set_ylim(H, 0); ax.axis('off')
INK, MUTED = '#183246', '#526778'
BLUE, TEAL, ORANGE = '#246799', '#167B78', '#A86824'
CHECKS, BOXES, LINES = [], [], []


def box(name, x, y, w, h, edge='#B7C5CE', fill='white', lw=1.25, radius=12):
    ax.add_patch(FancyBboxPatch((x, y), w, h,
        boxstyle=f'round,pad=0,rounding_size={radius}',
        facecolor=fill, edgecolor=edge, linewidth=lw, zorder=2))
    rect = (x, y, x+w, y+h)
    BOXES.append((name, rect))
    return rect


def text(x, y, value, size=12, color=INK, bold=False, ha='center', rect=None):
    artist = ax.text(x, y, value, fontproperties=BOLD if bold else FONT,
        fontsize=size, color=color, ha=ha, va='center', zorder=8,
        linespacing=1.5)
    if rect:
        CHECKS.append((artist, rect, value))
    return artist


def module(name, x, y, w, h, title, rows, accent=BLUE):
    rect = box(name, x, y, w, h)
    ax.plot([x+20, x+20], [y+20, y+h-20], color=accent, linewidth=3, zorder=3)
    text(x+w/2+5, y+32, title, 14, accent, True, rect=rect)
    for i, row in enumerate(rows):
        text(x+w/2+5, y+70+i*32, row, 11.8, rect=rect)
    return rect


def wire(points, color=BLUE, both=False, dashed=False, name=''):
    # Straight orthogonal segments with a single deliberate arrow at each end.
    style = (0, (4, 3)) if dashed else '-'
    for a, b in zip(points[:-2], points[1:-1]):
        ax.plot([a[0],b[0]], [a[1],b[1]], color=color, lw=1.6,
                linestyle=style, zorder=4)
    ax.add_patch(FancyArrowPatch(points[-2], points[-1], arrowstyle='-|>',
        mutation_scale=16, linewidth=1.6, color=color, linestyle=style, zorder=4))
    if both:
        ax.add_patch(FancyArrowPatch(points[1], points[0], arrowstyle='-|>',
            mutation_scale=16, linewidth=1.6, color=color, linestyle=style, zorder=4))
    LINES.append({'name':name, 'points':points, 'dashed':dashed})


def tag(x, y, value, color=MUTED, size=10.5):
    artist = text(x, y, value, size, color)
    artist.set_bbox(dict(facecolor='white', edgecolor='none', pad=2.5))
    return artist


# Title; no development version or experimental file names in the artwork.
text(40, 52, '自学习肌电意图解码康复训练系统', 24, bold=True, ha='left')
text(40, 103, '系统总体结构  /  AMD Zynq XC7Z020', 12, MUTED, ha='left')

# Separate hardware acceleration from the ARM application responsibilities.
pl = box('PL', 400, 160, 920, 880, BLUE, '#F3F7FB', 1.9, 16)
ps = box('PS', 1430, 480, 530, 560, TEAL, '#F0F8F6', 1.9, 16)
text(860, 194, 'PL  实时处理、边缘解码与执行', 19, BLUE, True, rect=pl)
text(1695, 516, 'PS  ARM Cortex-A9', 19, TEAL, True, rect=ps)
text(1695, 562, '训练管理、结果分析与交互', 12, MUTED, rect=ps)

module('acquisition', 440, 245, 380, 135, '采集与预处理',
       ['ADS1299 SPI 驱动', '50 Hz 陷波＋梳状＋带通'])
module('frequency', 900, 245, 380, 135, '频谱与疲劳分析',
       ['2048 点 FFT · 中值频率', '能量统计 · 分级疲劳趋势'])
module('features', 440, 440, 380, 135, '滑窗特征提取',
       ['MAV / WL / 能量 / ZC / SSC', '40 维 · 100 ms 窗 / 25 ms 更新'])
module('hdc', 900, 440, 380, 150, 'HDC 个体化在线学习',
       ['高维编码 · 类别原型更新', '相似度推理 · 自定义手势'])
module('mlp', 440, 640, 380, 150, '基础动作解码',
       ['INT8 MLP  40→64→32→5', '活动门控 · 置信度与稳定判决'])
module('nmf', 900, 640, 380, 150, 'NMF 肌肉协同求解',
       ['8 通道 → 3 路协同系数', '固定基矩阵 · 共享乘除运算'])
module('io', 440, 865, 380, 130, '显示与传感接口',
       ['RGB 扫描 · GT911 触摸', 'MPU 采集 / 四元数姿态融合'])
module('pwm', 900, 865, 380, 130, '六路 PWM 与执行保护',
       ['同帧原子更新 · 限幅 / 限速', '停止 / 超时保护 · 同步复位'])

# The frequency branch uses the processed sample stream; learning and NMF
# consume feature-window MAVs. These are parallel branches, not a chain.
wire([(630,380),(630,440)],name='processed samples to sliding features')
wire([(820,310),(900,310)],name='processed samples to FFT')
wire([(630,575),(630,640)],name='40D features to MLP')
wire([(820,505),(900,505)],name='window MAVs to HDC')
wire([(820,540),(860,540),(860,710),(900,710)],name='window MAVs to NMF')
tag(860, 615, 'MAV', size=9.3)
text(860, 1020, '采集与特征域 25 MHz  ·  学习加速与 AXI 100 MHz', 10.8, MUTED, rect=pl)

# Physical input and execution endpoints.
adc = box('ADC', 40, 245, 290, 170)
text(185, 282, '八对差分电极', 15, bold=True, rect=adc)
text(185, 326, 'ADS1299 · 8 通道 / 24 bit', 11.8, rect=adc)
text(185, 369, '4 kSPS / 通道 · 增益 8', 11.8, rect=adc)
mpu = box('MPU', 40, 515, 290, 125)
text(185, 549, 'MPU6050', 16, bold=True, rect=mpu)
text(185, 599, '前臂运动采集 · 100 Hz', 11.8, rect=mpu)
isolator = box('isolation', 40, 800, 290, 135, '#D3BA99', '#FEFBF5')
text(185, 834, '隔离与执行侧供电', 14, ORANGE, True, rect=isolator)
text(185, 875, '六路 PWM 光耦隔离', 11.8, rect=isolator)
text(185, 911, '主体 / 执行侧独立电池', 11.1, rect=isolator)
hand = box('hand', 40, 1010, 290, 120, '#D3BA99')
text(185, 1045, '实体机械手', 16, ORANGE, True, rect=hand)
text(185, 1092, '五指屈伸＋掌部旋转', 11.8, rect=hand)
wire([(330,310),(400,310)],name='SPI input')
tag(363, 286, 'SPI')
wire([(330,578),(400,578)],name='MPU acquisition interface')
tag(363, 552, 'I²C')
wire([(400,865),(330,865)],color=ORANGE,name='PL PWM to isolation')
tag(364, 840, 'PWM',ORANGE,size=9.8)
wire([(185,935),(185,1010)],color=ORANGE,name='isolated servo drive')
tag(185, 971, '隔离驱动',ORANGE)

# LCD is physically connected to the PL; the ARM constructs its framebuffer.
lcd = box('LCD', 1430, 220, 530, 170)
text(1695, 255, '800 × 480 触控 RGB LCD', 17, bold=True, rect=lcd)
text(1695, 303, '虚拟三维手 · 波形 / 频谱 · 通道评分', 12, rect=lcd)
text(1695, 348, '肌肉协同 / 疲劳趋势 · 学习与训练交互', 12, rect=lcd)
wire([(1320,282),(1430,282)],name='PL RGB to panel')
tag(1374,258,'RGB',size=10)
wire([(1430,345),(1320,345)],name='GT911 touch to PL')
tag(1374,367,'GT911',size=10)

# The bidirectional control plane represents existing AXI-Lite GPIO mailboxes.
wire([(1320,690),(1430,690)],color=TEAL,both=True,dashed=True,name='AXI control mailboxes')
tag(1375,633,'AXI',TEAL)
tag(1375,658,'配置 / 状态',TEAL,size=9.5)
ps_sections = [
    ('准备与个体化管理', ['静息校准 · 佩戴适配 · 通道评分', '学习采样 / 验证 · 类别与映射管理']),
    ('训练与过程评估', ['单动作 / 组合任务 · 保持与休息', '协同相对用力 · 完成率 / 响应统计']),
    ('姿态与虚实交互', ['姿态结果接收 · 虚拟三维手绘制', 'HDC 稳定确认 · 机械手目标生成']),
    ('显示与数据管理', ['LCD 画面 / 帧缓存 · SD 记录与标注', 'PL 任务调度 · 波形与训练结果分析']),
]
for i,(title,rows) in enumerate(ps_sections):
    y=606+i*112
    text(1460,y,title,12.5,TEAL,True,'left',ps)
    for j,row in enumerate(rows):
        text(1460,y+37+j*35,row,11,INK,False,'left',ps)
    if i<3:
        ax.plot([1460,1930],[y+94,y+94],color='#D6E5E1',lw=.8,zorder=3)

# Shared-memory data plane: HP0 for acquisition DMA / VDMA; HP1 for learner.
# No misleading direct DMA-to-ARM or framebuffer-to-LCD hardware connection.
ddr = box('DDR', 600, 1160, 660, 135, BLUE, '#F3F7FB')
text(930,1196,'DDR  共享数据、帧缓存与学习模型',15,BLUE,True,rect=ddr)
text(930,1246,'波形 / 特征 / 结果 · HDC 原型与学习任务',12,rect=ddr)
wire([(720,1040),(720,1160)],both=True,name='HP0 DMA VDMA')
tag(720,1087,'HP0',BLUE)
tag(720,1120,'采集 DMA / 显示 VDMA',size=10)
wire([(1110,1040),(1110,1160)],both=True,name='HP1 accelerator DDR')
tag(1110,1087,'HP1',BLUE)
tag(1110,1120,'学习数据 / 原型 / 结果',size=10)
wire([(1430,1000),(1365,1000),(1365,1226),(1260,1226)],color=TEAL,both=True,name='PS accesses DDR')
tag(1365,1100,'PS 访存',TEAL,size=10)
sd = box('storage',1430,1160,530,135)
text(1695,1196,'SD 卡与隔离串口 / PC',15,bold=True,rect=sd)
text(1695,1246,'波形与动作标注 · 训练日志 · 离线分析',11.8,rect=sd)
wire([(1695,1040),(1695,1160)],color=TEAL,both=True,name='PS peripheral storage and serial')
tag(1695,1100,'PS 外设',TEAL)

# Small legend explains functional rather than cycle-by-cycle wiring.
wire([(48,1230),(112,1230)],name='legend data')
text(126,1230,'数据 / 执行',10.5,MUTED,ha='left')
wire([(48,1270),(112,1270)],color=TEAL,dashed=True,both=True,name='legend control')
text(126,1270,'配置 / 状态',10.5,MUTED,ha='left')

# Check every block label against its box and every pair of text boxes for
# overlap before exporting. The border margin is part of the check.
fig.canvas.draw()
renderer=fig.canvas.get_renderer()
inverse=ax.transData.inverted()
issues=[]; labels=[]
for artist,rect,value in CHECKS:
    bbox=artist.get_window_extent(renderer=renderer)
    (x0,y1),(x1,y0)=inverse.transform([[bbox.x0,bbox.y0],[bbox.x1,bbox.y1]])
    bx0,by0,bx1,by1=rect
    if min(x0-bx0,bx1-x1,y0-by0,by1-y1)<5:
        issues.append({'type':'text outside safe margin','text':value,'box':rect,'bounds':[x0,y0,x1,y1]})
    labels.append((value,(x0,y0,x1,y1)))
for i,(a,aa) in enumerate(labels):
    for b,bb in labels[i+1:]:
        if min(aa[2],bb[2])-max(aa[0],bb[0])>1 and min(aa[3],bb[3])-max(aa[1],bb[1])>1:
            issues.append({'type':'text overlap','a':a,'b':b})
(OUT/'layout_check.json').write_text(json.dumps({'text_labels':len(CHECKS),'issues':issues,'connections':LINES},ensure_ascii=False,indent=2),encoding='utf-8')
if issues:
    raise RuntimeError(f'Layout validation failed: {len(issues)}; see layout_check.json')
for ext in ('svg','pdf','png'):
    fig.savefig(OUT/f'system_block.{ext}',dpi=300,facecolor='white')
fig.savefig(OUT/'preview.png',dpi=125,facecolor='white')
plt.close(fig)
print(f'LAYOUT_PASS labels={len(CHECKS)}; SVG/PDF/PNG exported to {OUT}')

