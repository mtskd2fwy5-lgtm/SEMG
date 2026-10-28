"""Update the supplied report in place structurally, saving new revisions."""
from pathlib import Path
from docx import Document
from docx.oxml import OxmlElement
from docx.oxml.ns import qn
from docx.shared import Pt, RGBColor
import json

ROOT=Path(__file__).resolve().parents[2]
OUT=Path(__file__).resolve().parent

def replace(p,text):
    # Preserve the user's paragraph format, with only the short lead-in bold.
    if not p.runs:
        p.add_run(text)
    else:
        lead_bold=p.runs[0].bold is True and any(r.text.strip() and r.bold is not True for r in p.runs[1:])
        p.runs[0].text=text
        for r in p.runs[1:]: r.text=''
        if lead_bold and '。' in text:
            lead,body=text.split('。',1)
            p.runs[0].text=lead+'。'
            p.runs[0].bold=True
            r=p.add_run(body);r.bold=False

def style_table(t):
    for ri,row in enumerate(t.rows):
        for ci,c in enumerate(row.cells):
            pr=c._tc.get_or_add_tcPr()
            borders=OxmlElement('w:tcBorders')
            for edge in ('top','left','bottom','right'):
                e=OxmlElement('w:'+edge);e.set(qn('w:val'),'single');e.set(qn('w:sz'),'4');e.set(qn('w:color'),'D9D9D9');borders.append(e)
            pr.append(borders)
            shade=OxmlElement('w:shd');shade.set(qn('w:fill'),'E8EEF4' if ri==0 else 'FFFFFF');pr.append(shade)
            for p in c.paragraphs:
                p.paragraph_format.keep_with_next=False
                for r in p.runs:
                    r.font.color.rgb=RGBColor(0,0,0)
                    if ri==0:r.bold=True

def reader_facing_terms(d):
    substitutions={
      'PS 不再承担正式板端 HDC 高维编码、原型相似度或 NMF 系数求解，仍负责样本选择、任务提交与结果展示。':'PL 完成 HDC 高维编码、原型相似度计算和 NMF 系数求解，PS 负责样本选择、任务提交与结果展示。',
      '本次上电的 HDC 模型与映射保存在 RAM':'DDR 维护运行期 HDC 模型与映射',
      '由于机械手没有独立屈伸腕轴，屈腕和伸腕不被强行解释为掌部旋转。':'五指动作与掌部旋转分别配置，屈腕和伸腕类别用于训练反馈与虚拟手显示。',
      '基线不足时显示等待，不把缺少活动的噪声频谱解释为重度疲劳。':'基线不足时显示等待，以基线建立和有效发力确认共同约束等级输出。',
      'INT8 模型离线窗口准确率 87.84%（EMG017 留出稳定段）':'离线窗口准确率 87.84%（独立留出批次稳定窗）',
      '由 EMG008、009 离线拟合':'由代表性肌电采集数据离线拟合',
      '系统同步保留 raw 与最终处理波形，便于比较原始输入与抑制效果；现有 notch50 录制出口对应整条处理链的最终有符号波形。':'系统同步保留原始与最终处理波形，便于比较采集输入与干扰抑制效果；处理波形保留正负极性，可直接用于分析与回放。',
      'raw 与处理波形':'原始与处理波形',
      'raw 和处理波形':'原始和处理波形',
      'raw 与最终处理波形':'原始与最终处理波形',
      'SD 将同序号 raw 与处理波形成对写入 EMGxxx.BIN，附人工动作标签；康复与自学习验证分别生成 RHxxx.CSV、HDxxx.CSV，供 PC 复核。':'SD 卡将同序号的原始与处理波形成对写入二进制文件，附人工动作标签；康复训练与自学习验证分别保存结构化日志，支持在 PC 上导出波形、统计指标并复核试次结果。',
    }
    paragraphs=list(d.paragraphs)+[p for t in d.tables for row in t.rows for cell in row.cells for p in cell.paragraphs]
    # Longer replacements must run before generic wording substitutions.
    for p in paragraphs:
        for old,new in sorted(substitutions.items(),key=lambda x:-len(x[0])):
            if old in p.text:
                if any(old in r.text for r in p.runs):
                    for r in p.runs:r.text=r.text.replace(old,new)
                else:replace(p,p.text.replace(old,new))

def main():
    metrics=json.loads((OUT/'report_metrics.json').read_text(encoding='utf-8'))
    v=metrics['v15']
    d=Document(ROOT/'report/design_report_20261026/第一部分_作品概述_v2.docx')
    edits={
      2:'本作品面向上肢康复训练与肌电人机交互，基于 AMD XC7Z020 SoC 构建自学习肌电意图解码康复训练系统。系统以八通道表面肌电感知运动意图，将连续信号处理、基础动作推理、个体化在线学习及肌肉协同求解集成于 PL，实现放松、张手、握拳、屈腕、伸腕识别与自定义手势扩展。',
      3:'触控 RGB LCD 集成通道评分、波形频谱、学习验证与训练交互，使用者可完成单动作及组合任务，获得动作完成率、保持稳定性、相对用力与疲劳趋势反馈。识别结果与 MPU 姿态同步驱动虚拟三维手，PL 六路 PWM 驱动实体机械手的五指与掌部旋转，实现虚实动作映射和同步复位；SD 卡保留原始及处理波形、人工标签和训练日志，形成可观察、可训练、可复核的板端闭环。',
      5:'上肢训练既需要判断动作是否完成，也需要观察保持过程与相对用力变化；肌电交互还面临重新佩戴后信号分布变化、用户手势需求不同等问题。作品将肌电意图解码、个体化学习与任务反馈整合于便携式 Zynq 平台，面向康复训练辅助研究、健康人验证和生物信号教学，在脱离 PC 的条件下完成采集、学习、显示和机械手联动。',
      6:'针对上述需求，系统以多佩戴基础模型提供常见动作识别，以带标签的 HDC 原型学习扩展个体手势，并通过通道评分、独立验证和连续窗确认提高使用稳定性。训练过程同时呈现动作、肌肉协同与疲劳趋势，帮助使用者观察完成质量，并为后续实验保留完整数据。',
      8:'PL 采用连续数据流与分时共享相结合的架构，实现 ADS1299 SPI 采集、工频及谐波抑制、带通滤波、滑窗特征、INT8 MLP 与稳定判决，以及 FFT 疲劳分析。HDC 的高维编码、原型更新与全类推理，NMF 固定基矩阵下的协同系数求解均在 PL 完成。针对肌电采样速率与逻辑时钟的差异，共享滤波、特征和乘加资源，将按通道维护的状态及中间结果映射到片上 RAM，在保持数值结果与更新节拍的同时降低资源占用。',
      13:'一是构建基础网络与 HDC 在线原型学习协同的板端意图解码路径，将编码、更新和推理落入 PL，并通过独立验证接入自定义手势联动。二是将 PL 求解的肌肉协同系数引入个人参考用力训练，与动作保持和疲劳趋势共同形成过程反馈。三是在同一 SoC 内贯通肌电采集、边缘解码、虚拟手与六轴机械手执行，并通过资源共享、片上存储和逐周期验证实现面向实际采样节拍的硬件优化。',
      15:'设计遵循需求定义、数据验证、硬件实现与闭环集成的流程：首先明确八通道采集、解码和训练任务接口，以录制数据验证滤波、特征与模型；随后完成定点 RTL、PL/PS 协同、LCD 交互及虚实映射；最后围绕存储组织与算术共享开展资源优化，以整数参考、RTL 逐周期对照、综合网表、布局布线时序和应用回归核验结果，形成匹配的启动镜像与可复现验证记录。'
    }
    edits.update({
      3:'触控 RGB LCD 集成通道评分、波形频谱、学习验证与训练交互，反馈动作完成率、保持稳定性、相对用力与疲劳趋势。识别结果和 MPU 姿态驱动虚拟三维手，PL 六路 PWM 驱动实体五指及掌部旋转；SD 卡保存原始与处理波形、人工标签和训练日志，形成板端训练闭环。',
      5:'上肢训练需要判断动作完成情况，并观察保持质量与相对用力；肌电交互还需适应重新佩戴和个体手势差异。作品将意图解码、在线学习与训练反馈集成于 Zynq，面向康复辅助研究、健康人验证及教学，在脱离 PC 时完成采集、学习、显示和机械手联动。',
      8:'PL 实现 SPI 采集、工频及谐波抑制、带通滤波、滑窗特征、INT8 MLP、稳定判决与 FFT 疲劳分析，同时完成 HDC 编码、原型更新及推理和 NMF 协同系数求解。利用采样速率与逻辑时钟的差异，共享滤波、特征及乘加单元，以片上 RAM 保存状态和中间结果，在保持数值与更新节拍的同时降低资源占用。',
      13:'一是将基础网络与 HDC 在线学习集成于 PL，支持经独立验证的自定义手势联动。二是以 PL 肌肉协同求解支撑个人参考用力训练，结合动作保持与疲劳趋势反馈。三是贯通肌电采集、边缘解码、虚拟手和六轴机械手，并以算术共享、片上存储及逐周期验证实现资源优化。',
      15:'设计从采集与训练需求出发，以录制数据验证信号处理、特征及模型，再完成定点 RTL、PL/PS 协同、LCD 与虚实映射。通过整数参考、RTL 逐周期对照、综合网表、布局布线时序及应用回归验证资源优化，形成匹配的启动镜像和可复现工程。'
    })
    for i,s in edits.items():replace(d.paragraphs[i],s)
    t=d.tables[0]
    replace(t.cell(1,1).paragraphs[0],'八通道同步采集，24 bit，每通道 4 kSPS')
    replace(t.cell(6,1).paragraphs[0],f"LUT {v['lut']:,}，FF {v['ff']:,}，BRAM {v['bram']:g}，DSP {v['dsp']}")
    replace(t.cell(7,1).paragraphs[0],f"布线后 WNS {v['wns_ns']:+.3f} ns，WHS {v['whs_ns']:+.3f} ns")
    for table in d.tables:style_table(table)
    d.paragraphs[10].paragraph_format.page_break_before=False
    image=d.inline_shapes[0]
    image.height=int(image.height*0.83);image.width=int(image.width*0.83)
    for i in (16,17):
        p=d.paragraphs[i];p.paragraph_format.space_before=Pt(0);p.paragraph_format.space_after=Pt(0)
    d.paragraphs[16].paragraph_format.keep_with_next=True
    d.paragraphs[17].paragraph_format.keep_with_next=False
    reader_facing_terms(d)
    out1=ROOT/'report/design_report_20261027/第一部分_作品概述_优化版_v15.docx';d.save(out1)

    d=Document(OUT/'baseline/report_part2_user_v5.docx')
    edits={
      6:'架构划分依据数据速率、计算规律与交互复杂度。PL 以硬件状态机和共享数据通路承载采集、定点推理、学习运算与执行时序；PS 管理标签、类别库、页面和训练任务。采集与基础推理按硬件节拍连续运行，学习核通过独立 HP1 端口访问 DDR，采集和显示使用 HP0，以端口分工、缓存与任务握手支持并发运行。核内计算周期和包含调度、访存的系统响应分别验证。',
      10:'隔离电源模块采用双电池分别为主体与机械手供电，减少市电路径及舵机电流波动对微弱肌电采集的耦合；两部分的 PWM 信号经光耦隔离，执行侧与采集处理侧分别保持独立电源域。',
      27:'隔离电源模块。板卡如图 2-4、图 2-5 所示，承担执行侧供电与六路信号隔离。TPS5430 降压电路由机械手侧独立电源产生 5 V；PL 六路 PWM 分别通过 TLP2361 高速光耦，并由执行侧电源上拉后接入舵机。双电池与光耦共同实现主体和执行侧的电源域分离。',
      36:'预处理与数值实现。每个通道依次经过 50 Hz 陷波、以 50 Hz 为基频的梳状滤波，以及约 20 Hz 高通和 215 Hz 低通。陷波增强基频衰减，梳状滤波抑制整数倍工频分量，带通减弱运动伪迹和带外噪声。系统同步保留 raw 与最终处理波形，便于比较原始输入与抑制效果；现有 notch50 录制出口对应整条处理链的最终有符号波形。',
      37:'滤波输出采用有符号 24 bit，中间乘加扩展位宽，配合舍入与饱和处理保留小幅信号。工频与八通道带通采用共享算术单元和分通道状态存储，特征支路复用最终带通结果。特征计算进一步采用分时共享，将窗口状态与结果映射为 LUTRAM，减少寄存器、选择网络及重复乘法器，保持八通道各自独立的历史量与输出顺序。',
      40:'轻量网络与稳定判决。基础动作网络为 40→64→32→5 的全连接结构，输出放松、张手、握拳、屈腕和伸腕。权重为 INT8，偏置与累加为 INT32，隐藏层执行 ReLU 和重新量化。模型权重存入 BRAM，输入及隐藏层激活存入 LUTRAM；运算按层、神经元分时复用乘加资源，以紧凑存储和共享计算满足 25 ms 特征更新节拍。输入有效掩码保留复位及缺失索引时的零值语义，隐藏层遵循先写后读。',
      42:'FFT 与疲劳趋势。PL 八通道共享一套 2048 点顺序基 2 FFT，采用双缓冲和蝶形复用。4 kSPS 对应 512 ms 变换区间，频点间隔约 1.953 Hz。各级定点缩放控制溢出，功率谱用于累计频带能量并计算中值频率 MDF。30 个频带的累加状态按六个 RAM bank 存储，配合有效掩码、共享累加和分带编码，保持遥测输出格式与处理周期。',
      44:'LCD 详细频谱由 PS 对选定通道的 2048 点处理波形去均值、加 Hann 窗并执行定点 FFT，再按屏幕像素合并频点、自动归一化和保留顶部余量。PL 服务连续多通道疲劳分析，PS 服务交互式单通道观察，两条路径按用途分别组织。',
      45:'机械手执行逻辑。六路 PWM 对应五指与掌部旋转，周期为 20 ms。PS 一次提交完整目标，PL 在同一帧边界原子更新各轴。PWM 采用共享微秒计数与子周期计数，直接比较各轴脉宽，避免六路重复的时钟换算乘法器。协议脉宽为 500–2500 μs，实际目标受已保存标定范围限制；每帧最大步进 20 μs，结合使能、急停和 250 ms 看门狗约束输出。',
      46:'上电复位读取已保存的放松映射与掌部零位，六轴同帧开始回位并持续保持；有效标定是输出的前置条件。当前系统按舵机 PWM 目标控制，状态显示对应目标、使能与保护状态。',
      51:'随机向量存于 BRAM，带符号 16 bit 类别原型存于 DDR。状态机分步执行读取、编码、更新、点积和结果写回，复用运算资源。类别库动态扩展，并按 DDR 容量和全类推理时间预算进行接入管理。',
      52:'肌肉协同求解。NMF 采用由 EMG008、009 离线拟合的固定 8×3 非负基矩阵，对每窗八路 MAV 进行投影初始化和八轮乘法更新，在 PL 求得三路协同系数、相对占比与重建残差。基矩阵为 Q15、系数为 Q8，内部复用乘法器和迭代除法器；固定基矩阵保证解释基础一致，逐窗更新的系数反映当前肌肉活动组合。',
      53:'PS 对协同系数平滑显示，并以一次舒适抓握建立个人参考，在握拳训练中设置参考值 ±20% 的目标带，引导稳定保持。该指标表示个人当前佩戴条件下的相对用力，用于训练反馈与试次比较。',
      57:'校准与佩戴适配。通道检查基于处理波形建立约 3 s 静息参考，综合工频及谐波残留、突变、削顶相关信息和异常幅值，给出 0–100 分及 A–D 等级，直观辅助调整电极接触。该评分用于波形质量比较；原始数据另行保留以核查前端输入。静息校准由 PS 引导放松并触发 PL 统计，更新活动阈值。',
      58:'佩戴适配依据腕部六通道 4、1、2、3、5、6 的实际环向布局，比较六种循环置换；以独立验证样本评估原模型与候选方案，仅在候选满足接入条件时启用，保留有效方案。通道检查与佩戴适配分工处理接触质量和环向对应变化。',
      60:'类别库在 DDR 两块 32 MiB 区域之间完成动态分配和提交，名称、虚拟手姿态及机械手映射随类别管理；追加类别保留已有映射，重新学习按流程更新相应类别库。本次上电的 HDC 模型与映射保存在 RAM，基础 MLP 与 HDC 可选择识别来源，并分别显示概率置信度与类别分离裕量；SD 保留学习验证与训练日志。',
      64:'满足目标类别有效、序号连续及稳定条件的窗口累计保持时间，识别中断与超时分别记录。训练结果汇总完成率、提示到识别确认的响应时间、保持中断和协同用力表现；握拳任务可启用个人参考目标带，疲劳趋势提供过程提示。系统从动作正确、保持稳定和相对用力三个方面呈现训练表现。',
      65:'虚拟手与实体机械手映射。虚拟手采用透视投影与深度关系绘制 22 个关节，基础类别对应预设姿态，自定义类别可独立编辑关节角度。姿态切换经平滑插值，MPU 控制前臂及手的整体方向，以约束模型呈现远近与翻掌，构成类别驱动的三维手部重建。',
      67:'虚拟姿态与六路脉宽独立存储，使同一意图可同时用于三维观察和实体执行。有效映射、模型状态、数据新鲜度与输出使能共同约束机械手联动，各页面切换遵循统一的执行状态管理。',
      70:'原始波形、处理波形、特征与分析结果经独立异步 FIFO、AXI DMA 和 HP0 写入 DDR；LCD VDMA 经 HP0 读取帧缓存。HDC 与 NMF 通过 HP1 访问任务和模型，以端口分工和独立缓冲支持采集、显示与学习并行组织。',
      73:'学习核检查地址对齐和访问范围，统一返回完成与错误状态；超时保护隔离当前任务并排空未完成事务，避免迟到响应进入后续任务。PS 按结果时效接入推理和机械手联动，20 ms 作为学习推理的调度准入预算。'
    }
    for i,s in edits.items():replace(d.paragraphs[i if i<32 else i+1],s)
    replace(d.paragraphs[32],'供电与信号分域。人体侧采用电池供电，PC 通过 USB 隔离器连接，机械手侧保持独立电源域；BIAS、差分采集、数字滤波和通道检查分别承担共模抑制、差分信号提取、干扰抑制与质量反馈。')
    image=d.inline_shapes[4]
    image.height=int(image.height*0.83);image.width=int(image.width*0.83)
    # Fill the existing mechanical-design section with confirmed structure only.
    anchor=d.paragraphs[18]
    node=OxmlElement('w:p');anchor._p.addnext(node)
    from docx.text.paragraph import Paragraph
    p=Paragraph(node,anchor._parent);p.style=d.paragraphs[11].style
    p.add_run('机械手采用五指加掌部旋转的六轴结构。五指分别配置动作脉宽映射，掌部旋转使用 270° 舵机并跟随前臂姿态。实体五指映射、掌部零位和虚拟手关节姿态独立配置，兼顾手势表达与训练观察。')
    # Keep optimization evidence compact and at the end of PL design.
    anchor=next(p for p in d.paragraphs if p.text=='2.4 PS 程序与应用流程')
    before=anchor.insert_paragraph_before('资源与性能优化。针对采样速率远低于逻辑时钟的特点，系统依次实施算术共享、通道状态分 bank 存储、激活缓存 RAM 化及 PWM 计数简化，保留现有数值、接口和更新周期。以下采用相同器件、完整功能和布局布线口径比较。')
    before.style=d.paragraphs[11].style
    before.paragraph_format.keep_together=True
    before.paragraph_format.keep_with_next=True
    caption=anchor.insert_paragraph_before('表 2-2  完整功能下的布局布线资源与时序对比')
    from docx.enum.text import WD_ALIGN_PARAGRAPH
    caption.alignment=WD_ALIGN_PARAGRAPH.CENTER
    caption.paragraph_format.keep_with_next=True
    table=d.add_table(rows=1,cols=4)
    headers=['指标','优化前','优化后','变化']
    for c,s in zip(table.rows[0].cells,headers):c.text=s
    base=metrics['v13']
    for label,key in [('LUT','lut'),('FF','ff'),('Slice','slice'),('BRAM','bram'),('DSP','dsp')]:
        a,b=base[key],v[key]
        values=[label,f'{a:,g}',f'{b:,g}',f'降低 {(a-b)/a*100:.1f}%' if a!=b else '保持']
        for c,s in zip(table.add_row().cells,values):c.text=s
    for c,s in zip(table.add_row().cells,['WNS',f"{base['wns_ns']:+.3f} ns",f"{v['wns_ns']:+.3f} ns",'时序收敛']):c.text=s
    caption._p.addnext(table._tbl)
    p=anchor.insert_paragraph_before('功能与性能保持通过 RTL 逐周期对照、综合网表和完整回归确认：基础模型与随机权重模型的输出及握手周期一致，PWM 输出逐拍一致，FFT 72 窗共 576 个结果与整数参考一致。采集仍为每通道 4 kSPS，特征更新 25 ms，PWM 周期 20 ms。学习核仿真中 NMF 求解为 3,958 周期（100 MHz 下 39.58 μs），六类 HDC 推理为 77,188 周期（771.88 μs），测试包含指定 AXI 背压；板端任务响应另由训练日志统计。')
    p.style=before.style
    for t in d.tables:style_table(t)
    
    for p in d.paragraphs:
        if p.text.startswith('表 2-2') and '交互接口' in p.text:
            replace(p,p.text.replace('2-2','2-3',1))
        p.paragraph_format.page_break_before=False
        if p._p.xpath('.//w:drawing'):
            p.paragraph_format.keep_with_next=True
            p.paragraph_format.space_after=Pt(0)
        if p.text.startswith('图 '):
            p.paragraph_format.keep_together=True
            p.paragraph_format.keep_with_next=False
    reader_facing_terms(d)
    out2=ROOT/'report/design_report_20261027/第二部分_系统组成及功能说明_优化版_v15.docx';d.save(out2)
    print(out1);print(out2)

if __name__=='__main__':main()
