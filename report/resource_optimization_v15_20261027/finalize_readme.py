"""Update release references only after the matched V15 BOOT is verified."""
from pathlib import Path
import hashlib,json,re

HERE=Path(__file__).resolve().parent
ROOT=HERE.parents[1]
TAG='20261027_HAND_CONTROL_HDC_DYNAMIC_V15'
evidence=json.loads((HERE/'artifacts.json').read_text(encoding='utf-8'))
assert evidence['tag']==TAG
boot=ROOT/f'build/boot/BOOT_{TAG}.BIN'
digest=hashlib.sha256(boot.read_bytes()).hexdigest()
assert any(e['path'].replace('\\','/')==str(boot.relative_to(ROOT)).replace('\\','/') and e['sha256']==digest for e in evidence['artifacts'])
path=ROOT/'README.md'
text=path.read_text(encoding='utf-8')
text=text.replace('20261027_HAND_CONTROL_HDC_DYNAMIC_V14',TAG)
old='V14 完成八通道特征与带通的共享运算、LUTRAM 状态和结果缓存优化。相对 V13，整机 Routed LUT 从 36,417 降至 25,737，FF 从 40,463 降至 27,047，DSP 从 111 降至 55，Slice 占用从 97.80% 降至 75.13%；BRAM 保持 45.5。采样率、滤波数值、100 ms 窗口、25 ms 更新和保护行为保留，没有新增流水延迟。资源、性能及验证证据见 [V14 PL 结构优化](report/resource_optimization_full_20261027/README.md)。'
new='V15 在八通道特征与带通共享运算的基础上，进一步优化 MLP 激活缓存、FFT 频带状态和 PWM 计数。相对 V13，整机 Routed LUT 从 36,417 降至 23,793，FF 从 40,463 降至 24,622，DSP 从 111 降至 49，分别降低 34.67%、39.15%、55.86%；Slice 占用从 97.80% 降至 69.80%，BRAM 保持 45.5。采样率、滤波数值、100 ms 窗口、25 ms 更新和保护行为保留，没有新增流水延迟。资源、性能及验证证据见 [V15 PL 存储与执行通路优化](report/resource_optimization_v15_20261027/README.md)。'
assert old in text or new in text
text=text.replace(old,new).replace('V14 继承 V13','V15 继承 V13')
text=re.sub(r'(?m)^- SHA256：`[0-9a-f]{64}`$',f'- SHA256：`{digest}`',text)
text=re.sub(r'(?m)^- 大小：[\d,]+ 字节$',f'- 大小：{boot.stat().st_size:,} 字节',text)
text=text.replace('V14 使用本轮重新综合','V15 使用本轮重新综合')
text=text.replace('证据集中在 `report/resource_optimization_full_20261027/`','证据集中在 `report/resource_optimization_v15_20261027/`')
text=text.replace('V14 尚未进行实板运行','V15 尚未进行实板运行')
text=text.replace('`report/resource_optimization_full_20261027/`：当前 V14 资源、性能、验证和镜像记录。','`report/resource_optimization_v15_20261027/`：当前 V15 资源、性能、验证和镜像记录。\n- `report/resource_optimization_full_20261027/`：V14 共享滤波与特征优化的继承证据。')
path.write_text(text,encoding='utf-8')
print('V15_README_RELEASE_UPDATED')
