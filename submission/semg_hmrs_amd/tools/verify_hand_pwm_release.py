"""V20: inverted optocoupler interface, unchanged V19 model/PS algorithms."""
from pathlib import Path
import hashlib,json,re,zipfile
ROOT=Path(__file__).resolve().parents[1]
REPORT=ROOT/'report/hand_pwm_inverted_20261029'
TAG='20261029_HAND_CONTROL_HDC_DYNAMIC_PWM_OPTO_V20'
CHANGED={'src/rtl/hand_control.v','sim/hand_control_tb.sv','board/constraints/hz_zynq_hand.xdc',
 'sw/ps_uart_print/main.c','README.md','tools/verify_control_boot.py','build/boot/build_pl_control_boot.ps1'}
NEW={'tools/verify_hand_pwm_release.py','build/scripts/run_hand_pwm_polarity_test.ps1',
 'build/scripts/export_hand_pwm_netlist.tcl','build/scripts/audit_hand_pwm_routed.tcl',
 'sim/hand_pwm_polarity_tb.sv'}
def digest(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def textfile(p):
 b=p.read_bytes();return b.decode('utf-16' if b.startswith((b'\xff\xfe',b'\xfe\xff')) else 'utf-8',errors='replace')
def verify(xsa):
 baseline=json.loads((REPORT/'baseline/manifest.json').read_text())
 for name,h in baseline.items():assert digest(REPORT/'baseline'/name)==h,'Altered V19 baseline: '+name
 old=json.loads((ROOT/'report/hdc_model_sd_20261029/regression_sources.json').read_text())
 old_artifacts=json.loads((ROOT/'report/hdc_model_sd_20261029/artifacts.json').read_text())
 checked=set()
 def inherited(name,h):
  if name in CHANGED:
   assert baseline.get(name)==h,'Wrong V19 baseline: '+name
  else:assert digest(ROOT/name)==h,'Unexpected V20 change: '+name
  checked.add(name)
 for name,h in old.items():inherited(name,h)
 for entry in old_artifacts['artifacts']:
  name=entry['path'].replace(chr(92),'/');p=Path(name)
  if name.startswith(('src/rtl/','board/constraints/','sw/ps_uart_print/')) and p.suffix.lower() in ('.v','.sv','.vh','.xdc','.c','.h','.ld','.s'):
   inherited(name,entry['sha256'])
 # V19 compact artifact list inherited V17's complete IMU and model sources.
 previous=json.loads((ROOT/'report/imu_pl_20261028/regression_sources.json').read_text())
 for name,h in previous.items():
  if name.startswith(('src/rtl/','board/constraints/')):inherited(name,h)
 main=(ROOT/'sw/ps_uart_print/main.c').read_bytes().replace(TAG.encode(),b'20261029_HAND_CONTROL_HDC_DYNAMIC_MODEL_SD_V19')
 assert hashlib.sha256(main).hexdigest()==baseline['sw/ps_uart_print/main.c'],'V20 PS changed beyond version tag'
 before=(REPORT/'baseline/src/rtl/hand_control.v').read_text()
 after=(ROOT/'src/rtl/hand_control.v').read_text()
 first=before.index('    assign pwm=enabled?');last=before.index('\n',first)
 begin=after.index('    // Board interface uses');end=after.index('\n',after.index('    assign pwm=~servo_pwm;',begin))
 assert before[:first]+before[last:]==after[:begin]+after[end:],'Control logic changed beyond output inversion'
 reference=(REPORT/'hand_control_reference.v').read_text().replace('module hand_control_active_high_reference #(','module hand_control #(')
 assert reference==before,'Reference differs from accepted active-high control'
 assert len(checked)>=100,'Incomplete V19 inheritance'
 proof=json.loads((REPORT/'regression_sources.json').read_text())
 assert CHANGED|NEW<=proof.keys()
 for name,h in proof.items():assert digest(ROOT/name)==h,'Stale V20 regression: '+name
 for name,marker in {
  'polarity_rtl.log':'TEST_PASS inverted PWM cycle-equivalence:',
  'pin_rtl.log':'TEST_PASS pin polarity:', 'pin_netlist.log':'TEST_PASS pin polarity:',
  'hand_test.log':'TEST_PASS hand firmware:',
  'hardware_build.log':'PIPELINE RESULT: ALL GATES PASS',
  'routed_audit.log':'TEST_PASS hand PWM routed six pins and full-system audit exported'}.items():
  data=textfile(REPORT/name);assert marker in data,'Missing V20 evidence: '+name
  assert not re.search(r'(?im)^(Fatal:|ERROR:|Assertion failed:)',data),'Failure in '+name
 assert 'All user specified timing constraints are met' in textfile(REPORT/'timing_routed.rpt')
 skew=textfile(REPORT/'bus_skew.rpt')
 slacks=re.findall(r'Slack \(MET\)\s*:\s*([-\d.]+)ns',skew)
 assert slacks and all(float(s)>=0 for s in slacks) and 'VIOLATED' not in skew,'Routed bus skew failed'
 assert not re.search(r'(?m)^\|\s*[^|]+\|\s*Error\s*\|',textfile(REPORT/'drc.rpt')),'Routed DRC error'
 with zipfile.ZipFile(xsa) as new,zipfile.ZipFile(REPORT/'baseline/build/export/design_1.xsa') as old_xsa:
  for name in old_xsa.namelist():
   if name.endswith(('ps7_init.c','ps7_init.h')):assert old_xsa.read(name)==new.read(name),'PS init changed'
 assert digest(ROOT/'build/vitis_ws/platform/export/platform/sw/boot/fsbl.elf')==next(e['sha256'] for e in old_artifacts['artifacts'] if e['path'].replace(chr(92),'/').endswith('sw/boot/fsbl.elf'))
 print(f'TEST_PASS V20 optocoupler release inherited_inputs={len(checked)} pin_RTL_and_netlist_verified')
if __name__=='__main__':verify(ROOT/'build/export/design_1.xsa')

