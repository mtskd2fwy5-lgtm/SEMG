"""Compact, print-size architecture: 16.5 cm wide, approximately 10.2 cm high.

Current deployment only: PL has MPU acquisition/basic tilt; PS performs the
quaternion attitude used by the virtual hand and palm-rotation targets.
"""
from pathlib import Path
import json
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
from matplotlib import font_manager
from matplotlib.patches import FancyBboxPatch, FancyArrowPatch

ROOT=Path(__file__).resolve().parents[1]
OUT=ROOT/'report/system_block_20261028/compact'
OUT.mkdir(parents=True,exist_ok=True)
W,H=1640,1010
NORMAL=font_manager.FontProperties(fname='C:/Windows/Fonts/msyh.ttc',family='Microsoft YaHei')
BOLD=font_manager.FontProperties(fname='C:/Windows/Fonts/msyhbd.ttc',family='Microsoft YaHei',weight='bold')
plt.rcParams.update({'svg.fonttype':'none','pdf.fonttype':42})
fig=plt.figure(figsize=(16.5/2.54,16.5/2.54*H/W),dpi=200,facecolor='white')
ax=fig.add_axes([0,0,1,1]);ax.set_xlim(0,W);ax.set_ylim(H,0);ax.axis('off')
INK='#213442';EDGE='#526572';PL='#EAF0F5';PS='#EDF3F0'
texts=[]

def box(x,y,w,h,fill='white',lw=.65):
    ax.add_patch(FancyBboxPatch((x,y),w,h,boxstyle='round,pad=0,rounding_size=6',
                 facecolor=fill,edgecolor=EDGE,linewidth=lw,zorder=2))
    return (x,y,x+w,y+h)

def text(x,y,s,size=8.2,bold=False,rect=None):
    t=ax.text(x,y,s,fontproperties=BOLD if bold else NORMAL,fontsize=size,
              ha='center',va='center',color=INK,zorder=6)
    texts.append((t,rect,s))
    return t

def arrow(points,both=False,dashed=False):
    style=(0,(3,2)) if dashed else '-'
    for a,b in zip(points[:-2],points[1:-1]):
        ax.plot([a[0],b[0]],[a[1],b[1]],color=EDGE,lw=.75,linestyle=style,zorder=3)
    ax.add_patch(FancyArrowPatch(points[-2],points[-1],arrowstyle='-|>',
        color=EDGE,linewidth=.75,mutation_scale=8,linestyle=style,zorder=3))
    if both:
        ax.add_patch(FancyArrowPatch(points[1],points[0],arrowstyle='-|>',
            color=EDGE,linewidth=.75,mutation_scale=8,linestyle=style,zorder=3))

def label(x,y,s,size=7):
    t=text(x,y,s,size)
    t.set_bbox(dict(facecolor='white',edgecolor='none',pad=1))

def module(x,y,w,title,rows,h=130):
    r=box(x,y,w,h)
    text(x+w/2,y+28,title,9.1,True,r)
    for i,s in enumerate(rows):text(x+w/2,y+(63 if h==120 else 69)+i*32,s,8.0,rect=r)

pl=box(310,20,755,780,PL,.95)
ps=box(1150,20,440,570,PS,.95)
text(687.5,60,'PL  实时处理与执行',11.4,True,pl)
text(1370,60,'PS  流程管理与交互',10.8,True,ps)
text(1370,102,'ARM Cortex-A9',8.2,rect=ps)

module(335,115,330,'采集与预处理',['SPI / 陷波＋梳状＋带通','八通道肌电实时处理'])
module(710,115,330,'频谱与疲劳分析',['2048 点 FFT / 中值频率','能量与疲劳趋势'])
module(335,305,330,'滑窗特征（40 维）',['MAV·WL·能量·ZC·SSC','100 ms 窗 / 25 ms 更新'])
module(710,305,330,'HDC 在线学习',['高维编码 / 原型更新','推理与自定义手势'])
module(335,495,330,'基础动作解码',['INT8 MLP · 五类动作','门控 / 置信度 / 稳定判决'])
module(710,495,330,'NMF 肌肉协同',['固定基矩阵系数求解','8 通道 → 3 路协同'])
module(335,665,330,'传感与显示接口',['MPU 采集 / 基础倾角','RGB / GT911'],120)
module(710,665,330,'六路 PWM 与保护',['五指与掌部 / 同步复位','限幅 / 限速 / 超时'],120)

arrow([(500,245),(500,305)])
arrow([(665,180),(710,180)])
arrow([(500,435),(500,495)])
arrow([(665,370),(710,370)])
arrow([(665,410),(688,410),(688,560),(710,560)])

adc=box(15,135,230,165)
text(130,170,'八对差分电极',9.4,True,adc)
text(130,215,'ADS1299 / 24 bit',7.6,rect=adc)
text(130,258,'4 kSPS / 通道',8.3,rect=adc)
arrow([(245,180),(310,180)]);label(277,150,'SPI')
mpu=box(15,395,230,120)
text(130,430,'MPU6050',9.5,True,mpu)
text(130,477,'前臂运动 / 100 Hz',7.4,rect=mpu)
arrow([(245,455),(310,455)]);label(277,423,'I²C')
hand=box(15,680,230,165)
text(130,715,'隔离与机械手',8.9,True,hand)
text(130,760,'五指＋掌部旋转',7.8,rect=hand)
text(130,805,'双电池 / 光耦',7.8,rect=hand)
arrow([(310,735),(245,735)]);label(277,702,'PWM')

for i,rows in enumerate([
    ['静息校准 / 佩戴适配 / 通道评分'],
    ['自学习流程 / 验证与映射管理'],
    ['MPU 四元数姿态解算'],
    ['虚拟手绘制 / 机械手目标生成'],
    ['康复任务 / 协同用力与训练评估'],
    ['LCD 交互 / SD 记录与动作标注'],
]):
    text(1370,167+i*66,rows[0],8.1,rect=ps)
text(1370,551,'隔离串口 / PC 离线分析',8.1,rect=ps)

arrow([(1065,520),(1150,520)],both=True,dashed=True)
label(1107,458,'AXI')
label(1107,490,'控制',6.8)

lcd=box(1150,680,440,120)
text(1370,715,'800 × 480 触控 RGB LCD',9.7,True,lcd)
text(1370,764,'虚拟手 / 波形频谱 / 学习与训练',8.4,rect=lcd)
arrow([(1065,740),(1150,740)],both=True)
label(1107,694,'RGB',6.8);label(1107,720,'GT911',6.5)

ddr=box(310,890,1280,100,PL,.8)
text(950,921,'DDR 共享数据、帧缓存与学习模型',9.7,True,ddr)
text(950,961,'HP0：采集 DMA / 显示 VDMA    HP1：学习数据 / 原型 / 结果',8.3,rect=ddr)
arrow([(687,800),(687,890)],both=True)
arrow([(1590,550),(1620,550),(1620,940),(1590,940)],both=True)

fig.canvas.draw();renderer=fig.canvas.get_renderer();inv=ax.transData.inverted()
issues=[];bounds=[]
for t,r,s in texts:
    b=t.get_window_extent(renderer)
    (x0,y1),(x1,y0)=inv.transform([[b.x0,b.y0],[b.x1,b.y1]])
    if r and min(x0-r[0],r[2]-x1,y0-r[1],r[3]-y1)<3:
        issues.append({'text':s,'type':'overflow'})
    bounds.append((s,(x0,y0,x1,y1)))
for i,(s,a) in enumerate(bounds):
    for u,b in bounds[i+1:]:
        if min(a[2],b[2])-max(a[0],b[0])>1 and min(a[3],b[3])-max(a[1],b[1])>1:
            issues.append({'type':'overlap','a':s,'b':u})
(OUT/'layout_check.json').write_text(json.dumps({'print_width_cm':16.5,'print_height_cm':16.5*H/W,
    'checked_labels':len(texts),'issues':issues},ensure_ascii=False,indent=2),encoding='utf-8')
if issues:raise RuntimeError(issues)
for ext in ('png','svg','pdf'):fig.savefig(OUT/f'system_block_compact.{ext}',dpi=600,facecolor='white')
fig.savefig(OUT/'preview.png',dpi=200,facecolor='white')
print('COMPACT_LAYOUT_PASS',len(texts),OUT)
