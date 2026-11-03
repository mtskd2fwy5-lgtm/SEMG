"""Check the matched PL-control XSA/bitstream/ELF/BOOT and write evidence."""
from pathlib import Path
import argparse
import hashlib
import json
import struct
import zipfile
import re
from verify_boot_partition import find_partition

ROOT = Path(__file__).resolve().parents[1]
TAG = '20261103_HAND_CONTROL_HDMI_MIRROR_V31'


def read_log(path):
    b = Path(path).read_bytes()
    return b.decode('utf-16' if b.startswith((b'\xff\xfe', b'\xfe\xff')) else 'utf-8-sig', errors='replace')


def main():
    ap=argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--hardware-only',action='store_true')
    ap.add_argument('--application-only',action='store_true')
    ap.add_argument('--tag',default=TAG)
    ap.add_argument('--report-dir',default='report/hdmi_mirror_20261103')
    args=ap.parse_args()
    tag=args.tag
    hdmi_v31=tag == '20261103_HAND_CONTROL_HDMI_MIRROR_V31'
    continuous_v30=tag == '20261102_HAND_CONTROL_HDC_DYNAMIC_CONTINUOUS_V30'
    resolution_v29=tag == '20261102_HAND_CONTROL_HDC_DYNAMIC_RESOLUTION_V29'
    custom_bridge_v28=tag == '20261101_HAND_CONTROL_HDC_DYNAMIC_CUSTOM_BRIDGE_V28'
    custom_only_v27=tag == '20261101_HAND_CONTROL_HDC_DYNAMIC_CUSTOM_ONLY_V27'
    ui_title_v26=tag == '20261101_HAND_CONTROL_HDC_DYNAMIC_SYSTEM_NAME_V26'
    button_v25=tag == '20261101_HAND_CONTROL_HDC_DYNAMIC_QUALITY_BUTTON_V25'
    button_v24=tag == '20261101_HAND_CONTROL_HDC_DYNAMIC_QUALITY_BUTTON_V24'
    zero_v23=tag == '20261031_HAND_CONTROL_HDC_DYNAMIC_IMU_ZERO_V23'
    grip_v22=tag == '20261031_HAND_CONTROL_HDC_DYNAMIC_SYNERGY_GRIP_V22'
    virtual_v13=tag == '20261026_HAND_CONTROL_HDC_DYNAMIC_V13'
    stability_v16=tag == '20261027_HAND_CONTROL_HDC_DYNAMIC_V16'
    opto_v20=tag == '20261029_HAND_CONTROL_HDC_DYNAMIC_PWM_OPTO_V20'
    ui_v21=tag == '20261030_HAND_CONTROL_HDC_DYNAMIC_UI_BUDGET_V21'
    model_v19=tag == '20261029_HAND_CONTROL_HDC_DYNAMIC_MODEL_SD_V19'
    quality_v18=tag == '20261029_HAND_CONTROL_HDC_DYNAMIC_QUALITY_V18'
    imu_v17=tag == '20261028_HAND_CONTROL_HDC_DYNAMIC_IMU_PL_V17'
    resource_v15=tag == '20261027_HAND_CONTROL_HDC_DYNAMIC_V15'
    resource_v14=resource_v15 or tag == '20261027_HAND_CONTROL_HDC_DYNAMIC_V14'
    learning_v12=hdmi_v31 or continuous_v30 or resolution_v29 or custom_bridge_v28 or custom_only_v27 or ui_title_v26 or button_v25 or button_v24 or zero_v23 or grip_v22 or ui_v21 or opto_v20 or model_v19 or quality_v18 or imu_v17 or stability_v16 or virtual_v13 or resource_v14 or tag == '20261026_HAND_CONTROL_HDC_DYNAMIC_V12'
    assert tag and all(c.isalnum() or c=='_' for c in tag), 'invalid build tag'
    bit_path = ROOT/'build/vivado/hand_motion_reconstruction.runs/impl_1/design_1.bit'
    elf_path = ROOT/'sw/ps_uart_print/ps_uart_print_pl_control.elf'
    boot_path = ROOT/f'build/boot/BOOT_{tag}.BIN'
    xsa_path = ROOT/'build/export/design_1.xsa'
    if hdmi_v31:
        from verify_hdmi_release import verify
        verify(ROOT/args.report_dir,xsa_path)
    if continuous_v30:
        from verify_hdc_continuous_release import verify
        verify(ROOT/args.report_dir)
    if resolution_v29:
        from verify_hdc_resolution_release import verify
        verify(xsa_path)
    if zero_v23:
        from verify_imu_zero_release import verify
        verify(xsa_path)
    if grip_v22:
        from verify_grip_release import verify
        verify(xsa_path)
    if button_v24:
        # One-button full-channel quality check: eight channels capture the
        # same window, the worker runs only while a check is active, and the
        # eight scores commit together from a single press.
        report=ROOT/args.report_dir
        for name,markers in {
            'quality_test.log':('button-triggered full check with synchronized capture and single commit',),
            'budget_test.log':('idle-between-checks, press-triggered 2.5ms quota',),
            'lcd_test.log':('TEST_PASS quality LCD: press-triggered 8-channel check',),
            'imu_test.log':('TEST_PASS quality LCD: press-triggered 8-channel check',),
            'hand_test.log':('TEST_PASS hand firmware:',),
            'learning_workflow_test.log':('TEST_PASS PL backend failures invalidate model and NMF without software fallback',),
        }.items():
            text=read_log(report/name)
            assert all(m in text for m in markers), 'V24 evidence missing: '+name
            assert not re.search(r'(?im)^(Fatal:|ERROR:|Assertion failed:)', text), 'Failed V24 test: '+name
        proof=json.loads((report/'regression_sources.json').read_text())
        for name,digest in proof.items():
            assert hashlib.sha256((ROOT/name).read_bytes()).hexdigest()==digest, 'Stale V24 source: '+name
    if button_v25:
        # Board fix for the one-button check: results latch per channel so a
        # sequence gap after a channel committed cannot erase it, one idle
        # opportunity drains a budget-bounded burst of worker chunks so all
        # eight windows finish inside the check, and the timeout constant
        # stays inside the u32 tick range.
        report=ROOT/args.report_dir
        for name,markers in {
            'quality_test.log':('button-triggered full check with synchronized capture, gap-tolerant latched results and single commit',),
            'budget_test.log':('budget-bounded burst draining, single commit, eight-channel burst completion',),
            'numeric_validation.log':('TEST_PASS baseline-free quality C/NumPy/SciPy numerical validation',),
            'lcd_test.log':('TEST_PASS quality LCD: press-triggered 8-channel check',),
            'imu_test.log':('TEST_PASS quality LCD: press-triggered 8-channel check',),
            'hand_test.log':('TEST_PASS hand firmware:',),
            'learning_workflow_test.log':('TEST_PASS PL backend failures invalidate model and NMF without software fallback',),
        }.items():
            text=read_log(report/name)
            assert all(m in text for m in markers), 'V25 evidence missing: '+name
            assert not re.search(r'(?im)^(Fatal:|ERROR:|Assertion failed:)', text), 'Failed V25 test: '+name
        proof=json.loads((report/'regression_sources.json').read_text())
        for name,digest in proof.items():
            assert hashlib.sha256((ROOT/name).read_bytes()).hexdigest()==digest, 'Stale V25 source: '+name
    if custom_bridge_v28:
        # A one-class custom library has no rival class: the PL accelerator
        # reports margin 0 for it, so the live hand/virtual bridge can never
        # reach a confident decision and used to wait forever. It is now
        # refused explicitly (>= 2 learned gestures required, with UI hints),
        # the relax-class 6-of-8 vote asymmetry is gone, and stability is
        # relaxed: qualified margin 2% -> 1%, 3-of-5 -> 3-of-6 votes,
        # hold expiry 8 windows/200 ms -> 10 windows/250 ms.
        report=ROOT/args.report_dir
        for name,markers in {
            'quality_test.log':('button-triggered full check with synchronized capture, gap-tolerant latched results and single commit',),
            'budget_test.log':('budget-bounded burst draining, single commit, eight-channel burst completion',),
            'numeric_validation.log':('TEST_PASS baseline-free quality C/NumPy/SciPy numerical validation',),
            'lcd_test.log':('TEST_PASS HDC LCD: real parser, eight custom classes, independent validation, frozen custom6/7/8 live hand bridge',),
            'imu_test.log':('TEST_PASS HDC LCD: real parser, eight custom classes, independent validation, frozen custom6/7/8 live hand bridge',),
            'hand_test.log':('TEST_PASS hand bridge: one-class library refused, uniform 3-of-6 stability for every custom class',
                             'TEST_PASS HDC stability: isolated error/abstention, rival hysteresis, 75ms clean transition, 250ms ambiguity STOP, uniform custom-class debounce',),
            'learning_workflow_test.log':('TEST_PASS PL backend failures invalidate model and NMF without software fallback',),
            'hdc_learning_test.log':('custom-only classes from empty library',),
            'model_test.log':('8-class exact samples/prototypes/centroids',),
        }.items():
            text=read_log(report/name)
            assert all(m in text for m in markers), 'V28 evidence missing: '+name
            assert not re.search(r'(?im)^(Fatal:|ERROR:|Assertion failed:)', text), 'Failed V28 test: '+name
        proof=json.loads((report/'regression_sources.json').read_text())
        for name,digest in proof.items():
            assert hashlib.sha256((ROOT/name).read_bytes()).hexdigest()==digest, 'Stale V28 source: '+name
        assert {'sw/ps_uart_print/hdc_learning.h','sw/ps_uart_print/hdc_model_store.h',
                'sw/ps_uart_print/lcd_hdc.h','sw/ps_uart_print/lcd_hand.h',
                'sw/ps_uart_print/hand_control.h','sw/ps_uart_print/lcd_virtual.h',
                'sw/ps_uart_print/lcd_hdc_models.h','sw/ps_uart_print/main.c',
                'sim/hdc_learning_test.c','sim/hdc_model_store_test.c',
                'sim/hand_firmware_test.c'}<=proof.keys()
    if custom_only_v27:
        # HDC on-board learning is fully custom: hdc_begin() takes the custom
        # class count directly (no +5 fixed base classes), the 5x5 base-gesture
        # MLP reference table and its statistics are gone, the SD model
        # contract moves to 0x07105004, hand-control rows are the three PL
        # base poses plus custom class c at row c+3 (no wrist hold-over), and
        # virtual-joint rows start at class 0.
        report=ROOT/args.report_dir
        for name,markers in {
            'quality_test.log':('button-triggered full check with synchronized capture, gap-tolerant latched results and single commit',),
            'budget_test.log':('budget-bounded burst draining, single commit, eight-channel burst completion',),
            'numeric_validation.log':('TEST_PASS baseline-free quality C/NumPy/SciPy numerical validation',),
            'lcd_test.log':('TEST_PASS HDC LCD: real parser, eight custom classes, independent validation, frozen custom6/7/8 live hand bridge',),
            'imu_test.log':('TEST_PASS HDC LCD: real parser, eight custom classes, independent validation, frozen custom6/7/8 live hand bridge',),
            'hand_test.log':('TEST_PASS hand firmware:',),
            'learning_workflow_test.log':('TEST_PASS PL backend failures invalidate model and NMF without software fallback',),
            'hdc_learning_test.log':('custom-only classes from empty library',),
            'model_test.log':('8-class exact samples/prototypes/centroids',),
        }.items():
            text=read_log(report/name)
            assert all(m in text for m in markers), 'V27 evidence missing: '+name
            assert not re.search(r'(?im)^(Fatal:|ERROR:|Assertion failed:)', text), 'Failed V27 test: '+name
        proof=json.loads((report/'regression_sources.json').read_text())
        for name,digest in proof.items():
            assert hashlib.sha256((ROOT/name).read_bytes()).hexdigest()==digest, 'Stale V27 source: '+name
        assert {'sw/ps_uart_print/hdc_learning.h','sw/ps_uart_print/hdc_model_store.h',
                'sw/ps_uart_print/lcd_hdc.h','sw/ps_uart_print/lcd_hand.h',
                'sw/ps_uart_print/hand_control.h','sw/ps_uart_print/lcd_virtual.h',
                'sw/ps_uart_print/lcd_hdc_models.h','sw/ps_uart_print/main.c',
                'sim/hdc_learning_test.c','sim/hdc_model_store_test.c'}<=proof.keys()
    if ui_title_v26:
        # Display rename only: every page header shows the confirmed system
        # name "自学习肌电意图解码康复训练系统" at full size. The header
        # navigation buttons shift right to make room; the settings button
        # keeps its established touch rectangle. The LCD font regains the
        # five previously missing glyphs with unchanged metrics.
        report=ROOT/args.report_dir
        for name,markers in {
            'quality_test.log':('button-triggered full check with synchronized capture, gap-tolerant latched results and single commit',),
            'budget_test.log':('budget-bounded burst draining, single commit, eight-channel burst completion',),
            'numeric_validation.log':('TEST_PASS baseline-free quality C/NumPy/SciPy numerical validation',),
            'lcd_test.log':('TEST_PASS quality LCD: press-triggered 8-channel check',),
            'imu_test.log':('TEST_PASS quality LCD: press-triggered 8-channel check',),
            'lcd_test.log:feedback':('system title fit',),
            'imu_test.log:feedback':('system title fit',),
            'hand_test.log':('TEST_PASS hand firmware:',),
            'learning_workflow_test.log':('TEST_PASS PL backend failures invalidate model and NMF without software fallback',),
        }.items():
            log=name.split(':')[0]
            text=read_log(report/log)
            assert all(m in text for m in markers), 'V26 evidence missing: '+name
            assert not re.search(r'(?im)^(Fatal:|ERROR:|Assertion failed:)', text), 'Failed V26 test: '+name
        proof=json.loads((report/'regression_sources.json').read_text())
        for name,digest in proof.items():
            assert hashlib.sha256((ROOT/name).read_bytes()).hexdigest()==digest, 'Stale V26 source: '+name
    if ui_v21:
        from verify_ui_budget_release import verify
        verify(xsa_path)
    if opto_v20:
        from verify_hand_pwm_release import verify
        verify(xsa_path)
    if model_v19:
        from verify_hdc_model_release import verify
        verify(xsa_path)
    if quality_v18:
        from verify_quality_release import verify
        verify(xsa_path)
    if imu_v17:
        from verify_imu_release import verify
        verify(xsa_path)
    bit=bit_path.read_bytes()
    reused=[]
    inherited=[]
    reused_v15=[]
    if stability_v16:
        previous=json.loads((ROOT/'report/resource_optimization_v15_20261027/artifacts.json').read_text())
        changed={'sw/ps_uart_print/hand_control.h','sw/ps_uart_print/lcd_hdc.h'}
        for entry in previous['artifacts']:
            path=Path(entry['path']);name=path.as_posix()
            payload=(ROOT/path).read_bytes()
            if name.startswith('sw/ps_uart_print/') and path.suffix.lower() in ('.c','.h','.ld','.s'):
                if name in changed:
                    baseline=ROOT/'report/hdc_stability_20261027/baseline'/path
                    assert hashlib.sha256(baseline.read_bytes()).hexdigest()==entry['sha256'], f'V15 baseline mismatch: {path}'
                    continue
                if path.name=='main.c':
                    payload=payload.replace(tag.encode(),b'20261027_HAND_CONTROL_HDC_DYNAMIC_V15')
                assert hashlib.sha256(payload).hexdigest()==entry['sha256'], f'Unexpected V16 application change: {path}'
                inherited.append(name)
            if (path.suffix in ('.bit','.xsa','.xdc','.mem') or name.startswith('src/rtl/') or
                name.endswith('sw/boot/fsbl.elf') or path.name=='ps7_init.c'):
                assert hashlib.sha256(payload).hexdigest()==entry['sha256'], f'V15 hardware changed: {path}'
                reused_v15.append(entry)
        assert len(inherited)>=26 and len(reused_v15)>=20, 'incomplete V15 inheritance checks'
        report=ROOT/args.report_dir
        proof=json.loads((report/'regression_sources.json').read_text())
        for name,digest in proof.items():
            assert hashlib.sha256((ROOT/name).read_bytes()).hexdigest()==digest, f'Stale regression: {name}'
        assert {'sw/ps_uart_print/hand_control.h','sw/ps_uart_print/lcd_hdc.h',
                'sw/ps_uart_print/main.c','sim/hand_firmware_test.c','sim/lcd_firmware_test.c'}<=proof.keys()
        for name,terminal in (
            ('lcd_test.log','TEST_PASS HDC STABILITY UI:'),
            ('lcd_test.log','TEST_PASS VIRTUAL MAPPING:'),
            ('lcd_test.log','TEST_PASS NAV LIFECYCLE: 144 routes'),
            ('hand_test.log','TEST_PASS HDC stability:'),
            ('hand_test.log','TEST_PASS hand firmware:'),
            ('learning_workflow_test.log','TEST_PASS PL backend failures invalidate model and NMF without software fallback')):
            assert terminal in (report/name).read_text(encoding='utf-8',errors='replace'), f'V16 regression missing: {name} {terminal}'
    if resource_v14:
        # New PL arithmetic must preserve PS interfaces and all V13 behavior.
        # V13-only hardware reuse checks below remain unchanged for that tag.
        previous=json.loads((ROOT/'report/virtual_mapping_20261026/artifacts.json').read_text())
        for entry in previous['artifacts']:
            path=Path(entry['path'])
            if path.as_posix().startswith('sw/ps_uart_print/') and path.suffix.lower() in ('.c','.h','.ld','.s'):
                payload=(ROOT/path).read_bytes()
                if path.name=='main.c':
                    payload=payload.replace(tag.encode(),b'20261026_HAND_CONTROL_HDC_DYNAMIC_V13')
                assert hashlib.sha256(payload).hexdigest()==entry['sha256'], f'V13 application behavior changed: {path}'
                inherited.append(str(path))
        # ELF is rebuilt with the new version tag; its loaded bytes are
        # checked separately against the newly generated BOOT below.
        assert len(inherited)>=28, 'incomplete inherited PS source checks'
        with zipfile.ZipFile(ROOT/'report/resource_optimization_20261027/baseline/design_1.xsa') as old, zipfile.ZipFile(xsa_path) as new:
            for name in old.namelist():
                if name.endswith(('.hwh','ps7_init.c','ps7_init.h')):
                    a,b=old.read(name),new.read(name)
                    if name.endswith('.hwh'):
                        a=re.sub(rb' TIMESTAMP="[^"]*"',b'',a)
                        b=re.sub(rb' TIMESTAMP="[^"]*"',b'',b)
                    assert a==b, f'Unexpected PS/platform interface change: {name}'
    if virtual_v13:
        # UI-only release reuses the accepted V12 implementation and its FSBL.
        # Pin actual files to that release instead of skipping PL checks.
        baseline=json.loads((ROOT/'report/pl_learning_nmf_20261026/artifacts.json').read_text())
        for entry in baseline['artifacts']:
            p=Path(entry['path'])
            if p.suffix in ('.bit','.xsa') or str(p).replace('\\','/').startswith('src/rtl/') or p.as_posix().endswith('sw/boot/fsbl.elf') or p.name=='ps7_init.c':
                assert hashlib.sha256((ROOT/p).read_bytes()).hexdigest()==entry['sha256'], f'V12 hardware changed: {p}'
                reused.append(entry)
        assert len(reused)>=15, 'incomplete V12 hardware reuse checks'
    with zipfile.ZipFile(xsa_path) as z:
        names=z.namelist()
        bit_names=[n for n in names if n.endswith('.bit')]
        assert len(bit_names)==1 and z.read(bit_names[0])==bit, 'XSA hardware differs'
        hwh='\n'.join(z.read(n).decode() for n in names if n.endswith('.hwh'))
        assert 'emg_pl_control' in hwh and 'axi_gpio_4' in hwh and '0x41240000' in hwh, 'XSA lacks control mailbox'
        if 'HAND_CONTROL' in tag:
            assert 'axi_gpio_5' in hwh and '0x41250000' in hwh and 'hand_pwm' in hwh, 'XSA lacks six-axis hand interface'
        if learning_v12:
            assert 'emg_learning_accel' in hwh and 'axi_gpio_6' in hwh and '0x41260000' in hwh, 'XSA lacks PL NMF/HDC accelerator'
            assert 'S_AXI_HP1' in hwh, 'XSA lacks accelerator DDR interface'
            logs=list((ROOT/'build/vivado/hand_motion_reconstruction.runs').glob('*emg_learning*_synth_1/runme.log'))
            assert logs, 'learning synthesis evidence missing'
            synth=max(logs,key=lambda p:p.stat().st_mtime).read_text(errors='replace')
            assert re.search(r'Parameter WATCHDOG bound to\s*:\s*10000000\s*- type: integer',synth), 'learning watchdog parameter is not the integer default'
            assert 'hdc_memory.mem' in synth and 'is read successfully' in synth, 'HDC ROM did not load during synthesis'
    if args.hardware_only:
        print('TEST_PASS PL-control XSA interface and bitstream match')
        return
    elf=elf_path.read_bytes()
    assert elf[:5] == b'\x7fELF\x01' and elf[5] == 1, 'expected ELF32 little endian'
    assert tag.encode() in elf, 'application has wrong build tag'
    if args.application_only:
        print('TEST_PASS application build tag matches requested BOOT tag')
        return
    boot=boot_path.read_bytes()
    transform,header,offset,length = find_partition(bit,boot)
    assert transform == 'wordrev', 'BOOT hardware does not match current .bit'
    phoff=struct.unpack_from('<I',elf,28)[0]
    phsize,phcount=struct.unpack_from('<HH',elf,42)
    checks=[]
    for n in range(phcount):
        kind,pos,vaddr,paddr,filesz,memsz,flags,align=struct.unpack_from('<8I',elf,phoff+n*phsize)
        if kind!=1 or not filesz:continue
        payload=elf[pos:pos+filesz];found=boot.find(payload)
        assert found>=0, f'ELF PT_LOAD {paddr:#x} not present in BOOT'
        checks.append({'load_address':hex(paddr),'elf_file_bytes':filesz,'boot_offset':hex(found),'match':True})
    assert checks, 'no loaded application bytes checked'
    fsbl_checks=[]
    if learning_v12:
        fsbl_path=ROOT/'build/vitis_ws/platform/export/platform/sw/boot/fsbl.elf'
        init_path=ROOT/'build/vitis_ws/platform/zynq_fsbl/ps7_init.c'
        with zipfile.ZipFile(xsa_path) as z:
            init_names=[n for n in z.namelist() if n.endswith('/ps7_init.c') or n=='ps7_init.c']
            assert len(init_names)==1, 'XSA ps7_init source missing/ambiguous'
            assert z.read(init_names[0]).decode().replace('\r\n','\n')==init_path.read_text(), 'FSBL PS init differs from matching HP1 XSA'
        fsbl=fsbl_path.read_bytes()
        assert fsbl[:6]==b'\x7fELF\x01\x01', 'FSBL must be ELF32 little endian'
        fo=struct.unpack_from('<I',fsbl,28)[0];fs,fc=struct.unpack_from('<HH',fsbl,42)
        for n in range(fc):
            kind,pos,va,pa,size,ms,flags,align=struct.unpack_from('<8I',fsbl,fo+n*fs)
            if kind!=1 or not size:continue
            found=boot.find(fsbl[pos:pos+size])
            assert found>=0, f'FSBL PT_LOAD {pa:#x} not present in BOOT'
            fsbl_checks.append({'load_address':hex(pa),'elf_file_bytes':size,'boot_offset':hex(found),'match':True})
        assert fsbl_checks, 'no FSBL load bytes checked'
    paths=[bit_path,elf_path,boot_path,xsa_path]
    if hdmi_v31:
        proof=json.loads((ROOT/args.report_dir/'regression_sources.json').read_text())
        paths += [ROOT/p for p in proof]
        paths += [ROOT/args.report_dir/p for p in ('README.md','regression_sources.json',
            'baseline_sources.json','hardware_console.log','timing_routed.rpt',
            'utilization_routed.rpt','drc_routed.rpt','cdc.rpt','comparison.json',
            'hdmi_scaler_test.log','hdmi_tmds_test.log','serializer_check.log',
            'baseline_bd_contract.json','bd_contract_test.log','output_test.log',
            'scaler_synthesis_console.log','scaler_netlist_test.log','pipeline_test.log',
            'routed_audit_console.log','dma_configuration.txt','output_pins.txt',
            'clocks.rpt','exceptions.rpt','methodology_routed.rpt','clock_interaction.rpt',
            'platform_build.log','cdc_detailed.rpt','hardware_gates.log',
            'lcd_test.log','model_test.log','sd_test.log','hand_test.log',
            'uart_test.log','learning_workflow_test.log')]
    paths += [ROOT/p for p in ('board/constraints/hz_zynq_lcd.xdc',
        'board/constraints/hz_zynq_lcd_timing.xdc','build/update_project.tcl',
        'build/check_design.tcl','build/open_project.tcl')]
    paths += [ROOT/p for p in ('src/rtl/emg_control_policy.v','src/rtl/emg_control_inference.v',
        'src/rtl/emg_control_constants.vh','src/rtl/emg_pl_control.v','src/rtl/emg_pl_export.v',
        'src/rtl/hand_servo_pwm.v','sw/ps_uart_print/main.c','sw/ps_uart_print/pl_control.h',
        'sw/ps_uart_print/synergy_feedback.h','sw/ps_uart_print/lcd_rehab.h','sw/ps_uart_print/rehab_training.h',
        'sw/ps_uart_print/synergy_nmf.h','sw/ps_uart_print/synergy_nmf_model.h','sw/ps_uart_print/lcd_font_zh.h')]
    paths += [ROOT/p for p in ('sw/ps_uart_print/capture_actions.h','sw/ps_uart_print/sd_record.c',
        'sw/ps_uart_print/sd_record.h','tools/capture_actions.py','tools/record_uart.py',
        'tools/train_gesture_model.py')]
    paths += [ROOT/p for p in ('sw/ps_uart_print/hdc_learning.h','sw/ps_uart_print/hdc_memory.h',
        'sw/ps_uart_print/lcd_hdc.h','sw/ps_uart_print/lcd_settings.h','tools/gen_hdc_memory.py',
        'sim/hdc_learning_test.c','sim/test_hdc_learning.py','sim/lcd_firmware_test.c',
        'sim/pl_control_firmware_test.c','sim/sd_record_test.c')]
    paths += [ROOT/p for p in ('sw/ps_uart_print/lcd_home.h','sw/ps_uart_print/lcd_waveform.h',
        'sw/ps_uart_print/lcd_channel_quality.h','sim/rehab_training_test.c',
        'sw/ps_uart_print/channel_quality.h','sim/channel_quality_test.c',
        'build/boot/build_pl_control_boot.ps1','tools/verify_control_boot.py')]
    paths += [ROOT/p for p in ('report/rehab_quality_20261025/README.md',)]
    if 'FATIGUE' in tag:
        paths += [ROOT/p for p in ('src/rtl/emg_fatigue.v','tools/gen_fatigue_mem.py',
            'sim/tb_emg_fatigue.v','sim/tb_emg_fatigue_state.sv',
            'sim/test_fatigue_netlist_gate.py',
            'build/scripts/run_fatigue_sim.bat','report/fatigue_20261025/README.md')]
    if 'HAND_CONTROL' in tag:
        paths += [ROOT/p for p in ('src/rtl/hand_control.v','board/constraints/hz_zynq_hand.xdc',
            'sw/ps_uart_print/hand_control.h','sw/ps_uart_print/lcd_hand.h',
            'sim/hand_control_tb.sv','sim/hand_firmware_test.c','build/scripts/add_hand_control.tcl',
            'build/scripts/run_hand_control_test.ps1','tools/scan_literal_b.py','sim/test_hand_netlist_gate.py')]
    if 'MPU_HDC' in tag or 'HDC_DYNAMIC' in tag:
        paths += [ROOT/p for p in ('sw/ps_uart_print/lcd_imu_3d.h',
            'src/rtl/emg_fatigue.v','report/hand_mpu_20261025/README.md',
            'sw/ps_uart_print/lscript.ld','sw/ps_uart_print/display_memory.S')]
    if 'HDC_DYNAMIC' in tag:
        paths += [ROOT/'report/hdc_dynamic_20261025/README.md']
    if learning_v12:
        paths += [ROOT/p for p in ('src/rtl/emg_learning_accel.v','src/rtl/learning_div64.v',
            'src/rtl/axis_async_fifo.v','data/models/hdc_memory.mem',
            'sw/ps_uart_print/pl_learning.h','sw/ps_uart_print/pl_learning_api.h',
            'build/scripts/add_pl_learning.tcl','build/scripts/run_learning_test.ps1',
            'build/scripts/run_fifo_test.ps1','sim/emg_learning_accel_tb.sv',
            'sim/axis_async_fifo_tb.sv','tools/gen_learning_vectors.py',
            'report/pl_learning_nmf_20261026/README.md',
            'sim/pl_learning_workflow_test.c','build/scripts/run_learning_netlist_test.ps1',
            'build/scripts/export_learning_netlist.tcl','build/scripts/update_learning_platform.py',
            'report/pl_learning_nmf_20261026/learning_test.log',
            'report/pl_learning_nmf_20261026/learning_netlist_test.log',
            'report/pl_learning_nmf_20261026/fifo_test.log',
            'report/pl_learning_nmf_20261026/full_build.log',
            'report/pl_learning_nmf_20261026/platform_build.log',
            'report/pl_learning_nmf_20261026/arm_build.log',
            'report/pl_learning_nmf_20261026/lcd_test.log',
            'report/pl_learning_nmf_20261026/control_test.log',
            'report/pl_learning_nmf_20261026/hand_test.log',
            'report/pl_learning_nmf_20261026/sd_test.log',
            'report/pl_learning_nmf_20261026/hdc_golden_test.log',
            'report/pl_learning_nmf_20261026/verification_summary.json',
            'report/pl_learning_nmf_20261026/ip_config.tcldict',
            'report/pl_learning_nmf_20261026/ip_parameter_sources.json',
            'report/pl_learning_nmf_20261026/timing_routed.rpt',
            'report/pl_learning_nmf_20261026/utilization_placed.rpt',
            'report/work_submission_text_20261026.md','report/system_framework_v1_20261024.md','README.md',
            'build/vitis_ws/platform/export/platform/sw/boot/fsbl.elf',
            'build/vitis_ws/platform/zynq_fsbl/ps7_init.c')]
    if tag == '20261025_HAND_CONTROL_HDC_DYNAMIC_V8':
        paths += [ROOT/'report/hand_direction_20261025/README.md']
    if tag == '20261025_HAND_CONTROL_HDC_DYNAMIC_V9':
        paths += [ROOT/p for p in ('report/hand_slider_20261025/README.md',
            'sw/ps_uart_print/lcd_ui.h','build/scripts/run_lcd_firmware_test.ps1',
            'report/hand_slider_20261025/hand_test.log',
            'report/hand_slider_20261025/lcd_test.log',
            'report/hand_slider_20261025/pl_control_test.log',
            'report/hand_slider_20261025/sd_test.log')]
    if tag == '20261025_HAND_CONTROL_HDC_DYNAMIC_V10':
        paths += [ROOT/p for p in ('report/hand_mapping_live_20261025/README.md',
            'sw/ps_uart_print/lcd_ui.h','build/scripts/run_lcd_firmware_test.ps1',
            'report/hand_mapping_live_20261025/hand_test.log',
            'report/hand_mapping_live_20261025/lcd_test.log',
            'report/hand_mapping_live_20261025/pl_control_test.log',
            'report/hand_mapping_live_20261025/sd_test.log')]
    if tag == '20261025_HAND_CONTROL_HDC_DYNAMIC_V11':
        paths += [ROOT/p for p in ('report/hand_simultaneous_home_20261025/README.md',
            'sw/ps_uart_print/lcd_ui.h','build/scripts/run_lcd_firmware_test.ps1',
            'report/hand_simultaneous_home_20261025/hand_test.log',
            'report/hand_simultaneous_home_20261025/lcd_test.log',
            'report/hand_simultaneous_home_20261025/pl_control_test.log',
            'report/hand_simultaneous_home_20261025/sd_test.log',
            'report/hand_simultaneous_home_20261025/hardware_build.log',
            'report/hand_simultaneous_home_20261025/timing_routed.rpt',
            'report/hand_simultaneous_home_20261025/utilization_placed.rpt')]
    if virtual_v13 or resource_v14:
        paths += [ROOT/p for p in ('sw/ps_uart_print/lcd_virtual.h','sw/ps_uart_print/lcd_hand_3d.h',
            'tools/gen_hz_glyphs.py','report/virtual_mapping_20261026/README.md',
            'report/virtual_mapping_20261026/lcd_test.log','report/virtual_mapping_20261026/hand_test.log',
            'report/virtual_mapping_20261026/hdc_golden_test.log',
            'report/virtual_mapping_20261026/learning_workflow_test.log',
            'report/virtual_mapping_20261026/control_test.log','report/virtual_mapping_20261026/sd_test.log',
            'report/virtual_mapping_20261026/build_boot.log','report/virtual_mapping_20261026/arm_build.log')]
    if resource_v14:
        paths += [ROOT/p for p in ('src/rtl/emg_window_features.v','src/rtl/emg_feature_bank.v',
            'src/rtl/emg_bandpass.v','src/rtl/emg_line_filter.v',
            'sim/emg_shared_equiv_tb.sv','sim/emg_shared_netlist_tb.sv','sim/emg_shared_integrated_netlist_tb.sv',
            'build/scripts/run_shared_equiv_test.ps1','build/scripts/run_shared_netlist_test.ps1',
            'report/resource_optimization_full_20261027/README.md',
            'report/resource_optimization_full_20261027/shared_equiv.log',
            'report/resource_optimization_full_20261027/shared_integrated_netlist.log',
            'report/resource_optimization_full_20261027/processed_filter.log',
            'report/resource_optimization_full_20261027/control_regression.log',
            'report/resource_optimization_full_20261027/comparison.json',
            'report/resource_optimization_full_20261027/comparison.log',
            'report/resource_optimization_full_20261027/full_build.log')]
    if resource_v15:
        extra = ('src/rtl/emg_nn_infer.v','src/rtl/emg_fatigue.v',
            'sim/test_fatigue_netlist_gate.py',
            'sim/emg_v15_equiv_tb.sv','sim/emg_v15_integrated_tb.sv',
            'tools/gen_v15_test_model.py','build/scripts/run_v15_equiv_test.ps1',
            'build/scripts/run_v15_fatigue_equiv_test.ps1',
            'build/scripts/run_v15_netlist_test.ps1','build/scripts/run_v15_integrated_test.ps1')
        paths += [ROOT/p for p in extra]
        v15_checks = {'equivalence.log':'TEST_PASS V15 MLP PWM equivalence complete',
            'fatigue_equivalence.log':'TEST_PASS V15 fatigue cycle-exact 576 words',
            'netlist_test_complete.log':'TEST_PASS V15 synthesized modules complete',
            'integrated_test.log':'TEST_PASS V15 integrated OOC MLP FFT',
            'control_regression.log':'TEST_PASS PL shell',
            'comparison.log':'V15_RESOURCE_PERFORMANCE_COMPARISON_PASS'}
        report = ROOT/'report/resource_optimization_v15_20261027'
        for filename, terminal in v15_checks.items():
            path=report/filename
            assert terminal in path.read_text(encoding='utf-8',errors='replace'), f'V15 evidence missing: {filename}'
            paths.append(path)
        paths += [report/p for p in ('README.md','comparison.json','compare_resources.py',
            'netlist_gate_regression.log','final_gates.log','fatigue_regression.log',
            'resource_table.md','performance_table.md',
            'candidate/utilization_routed.rpt','candidate/timing_routed.rpt')]
    if stability_v16:
        paths += [ROOT/p for p in ('sw/ps_uart_print/lcd_virtual.h','sw/ps_uart_print/lcd_ui.h',
            'build/scripts/run_hdc_stability_test.ps1','sim/pl_learning_workflow_test.c',
            'report/resource_optimization_v15_20261027/artifacts.json')]
        paths += [ROOT/args.report_dir/p for p in ('README.md','lcd_test.log','hand_test.log',
            'learning_workflow_test.log','regression_sources.json')]
    if imu_v17:
        paths += [ROOT/p for p in ('src/rtl/mpu_attitude.v','src/rtl/mpu_attitude_core.v',
            'src/rtl/mpu_attitude_rom.vh','src/rtl/mpu_attitude_regs.vh','tools/gen_imu_microcode.py',
            'tools/imu_fixed_model.py','tools/verify_imu_vectors.py','tools/verify_imu_release.py',
            'build/scripts/add_pl_imu.tcl','build/scripts/run_imu_test.ps1',
            'board/constraints/hz_zynq_imu_clock_groups.xdc','tools/compare_imu_resources.py',
            'build/scripts/finalize_imu_timing.tcl','build/scripts/audit_imu_routed.tcl',
            'sim/mpu_attitude_vectors_tb.sv','sim/mpu_attitude_mailbox_tb.sv','sim/imu_host_model.h')]
        paths += [ROOT/args.report_dir/p for p in ('README.md','regression_sources.json','float_comparison.json',
            'rtl_vectors.log','rtl_mailbox.log','netlist_mailbox.log','mailbox_firmware.log',
            'lcd_test.log','hand_test.log','learning_workflow_test.log','timing_routed.rpt','comparison.json',
            'utilization_routed.rpt','methodology_routed.rpt','bus_skew.rpt','cdc.rpt','resource_table.md')]
    if quality_v18:
        paths += [ROOT/p for p in ('tools/verify_quality_release.py','sw/ps_uart_print/channel_quality.h',
            'sw/ps_uart_print/channel_quality_tables.h','sw/ps_uart_print/lcd_channel_quality.h',
            'sim/channel_quality_test.c','sim/test_channel_quality_reference.py','sim/lcd_firmware_test.c')]
        paths += [ROOT/args.report_dir/p for p in ('README.md','regression_sources.json','quality_test.log',
            'numeric_validation.json','lcd_test.log','hand_test.log','learning_workflow_test.log','baseline/manifest.json')]
    if model_v19:
        paths += [ROOT/p for p in ('sw/ps_uart_print/hdc_model_store.h','sw/ps_uart_print/lcd_hdc_models.h',
            'sw/ps_uart_print/lcd_virtual.h','tools/gen_hz_glyphs.py','tools/verify_hdc_model_release.py',
            'sim/hdc_model_store_test.c','sim/hdc_model_sd_mock.h','sim/sd_record_platform_mock.h',
            'sim/control_policy_reference.c','sim/uart_record_firmware_test.c','build/scripts/run_hdc_model_test.ps1',
            'report/channel_quality_20261029/artifacts.json','report/channel_quality_20261029/regression_sources.json')]
        paths += [ROOT/args.report_dir/p for p in ('README.md','regression_sources.json','baseline/manifest.json',
            'model_test.log','sd_test.log','lcd_test.log','hand_test.log','learning_workflow_test.log','uart_test.log')]
    if opto_v20:
        paths += [ROOT/p for p in ('sw/ps_uart_print/hdc_model_store.h','sw/ps_uart_print/lcd_hdc_models.h',
            'sw/ps_uart_print/lcd_virtual.h','sw/ps_uart_print/channel_quality_tables.h',
            'tools/verify_hand_pwm_release.py','sim/hand_pwm_polarity_tb.sv',
            'build/scripts/export_hand_pwm_netlist.tcl','build/scripts/run_hand_pwm_polarity_test.ps1')]
        paths += [ROOT/args.report_dir/p for p in ('README.md','regression_sources.json','baseline/manifest.json',
            'polarity_rtl.log','pin_rtl.log','pin_netlist.log','hand_test.log','hardware_build.log',
            'timing_routed.rpt','utilization_routed.rpt','drc.rpt','output_pins.txt')]
    paths=list(dict.fromkeys(paths))
    if ui_v21:
        paths += [ROOT/p for p in ('sw/ps_uart_print/channel_quality.h',
            'tools/verify_ui_budget_release.py','sim/lcd_work_budget_test.c')]
        paths += [ROOT/args.report_dir/p for p in ('README.md','regression_sources.json',
            'baseline/manifest.json','quality_test.log','numeric_validation.json',
            'lcd_test.log','cpu_test.log')]
    if zero_v23:
        from verify_imu_zero_release import sources
        paths += [ROOT/p for p in sources()]
        paths += [ROOT/args.report_dir/p for p in ('README.md','regression_sources.json',
            'rtl_test.log','netlist_test.log','lcd_test.log','grip_test.log','feedback_test.log',
            'mailbox_firmware.log','hand_test.log','learning_workflow_test.log','float_comparison.json',
            'arm_build.log','hardware_build.log','full_gates.log','timing_routed.rpt',
            'utilization_routed.rpt','drc.rpt','methodology_routed.rpt')]
        paths=list(dict.fromkeys(paths))
    if grip_v22:
        paths += [ROOT/p for p in ('tools/verify_grip_release.py','sim/hand_grip_test.c',
            'build/scripts/run_hand_grip_test.ps1','sim/control_policy_reference.c')]
        paths += [ROOT/args.report_dir/p for p in ('README.md','regression_sources.json',
            'grip_test.log','hand_test.log','lcd_test.log','arm_build.log','font_test.log')]
    if continuous_v30:
        paths += [ROOT/'tools/verify_hdc_continuous_release.py']
        paths += [ROOT/args.report_dir/p for p in ('README.md','regression_sources.json',
            'hand_test.log','lcd_test.log','imu_test.log','model_test.log','sd_test.log',
            'uart_test.log','learning_workflow_test.log')]
    if resolution_v29:
        paths += [ROOT/p for p in ('sw/ps_uart_print/hdc_model_store.h',
            'sw/ps_uart_print/lcd_hdc_models.h','sw/ps_uart_print/lcd_virtual.h',
            'tools/verify_hdc_resolution_release.py','build/scripts/rebuild_hdc_resolution.tcl',
            'build/scripts/close_hdc_resolution_timing.tcl',
            'sim/hdc_model_store_test.c','sim/imu_reference_test.c','sim/hdc_model_sd_mock.h')]
        paths += [ROOT/args.report_dir/p for p in ('README.md','regression_sources.json',
            'baseline_sources.json','baseline_artifacts.json','netlist_inputs.json','netlist_vectors.mem',
            'learning_test.log','learning_netlist_test.log','golden_test.log','golden/replay.json',
            'lcd_test.log','imu_test.log','hand_test.log','learning_workflow_test.log',
            'model_test.log','sd_test.log','uart_test.log','arm_build.log','boot_build.log',
            'hardware_console.log','timing_close_console.log','timing_routed.rpt','utilization_routed.rpt',
            'utilization_hierarchical.rpt','methodology_routed.rpt','comparison.json','compare_results.py',
            'xsa_bit_extraction.json','drc_routed.rpt')]
    if custom_bridge_v28:
        paths += [ROOT/p for p in ('sw/ps_uart_print/hdc_model_store.h','sw/ps_uart_print/lcd_hdc_models.h',
            'sim/hdc_model_store_test.c','sim/imu_reference_test.c','sim/pl_learning_workflow_test.c',
            'sim/hand_firmware_test.c','sim/test_hdc_learning.py',
            'build/scripts/run_quality_button_test.ps1')]
        paths += [ROOT/args.report_dir/p for p in ('README.md','regression_sources.json',
            'baseline/manifest.json','quality_test.log','budget_test.log','numeric_validation.log',
            'lcd_test.log','imu_test.log','hand_test.log','learning_workflow_test.log',
            'hdc_learning_test.log','model_test.log','arm_build.log','boot_build.log')]
    if custom_only_v27:
        paths += [ROOT/p for p in ('sw/ps_uart_print/hdc_model_store.h','sw/ps_uart_print/lcd_hdc_models.h',
            'sim/hdc_model_store_test.c','sim/imu_reference_test.c','sim/pl_learning_workflow_test.c',
            'sim/hand_firmware_test.c','sim/test_hdc_learning.py',
            'build/scripts/run_quality_button_test.ps1')]
        paths += [ROOT/args.report_dir/p for p in ('README.md','regression_sources.json',
            'baseline/manifest.json','quality_test.log','budget_test.log','numeric_validation.log',
            'lcd_test.log','imu_test.log','hand_test.log','learning_workflow_test.log',
            'hdc_learning_test.log','model_test.log','arm_build.log','boot_build.log')]
    if ui_title_v26:
        paths += [ROOT/p for p in ('sw/ps_uart_print/lcd_home.h',
            'sw/ps_uart_print/lcd_font_zh.h','tools/gen_hz_glyphs.py',
            'sim/lcd_firmware_test.c','sim/imu_reference_test.c',
            'build/scripts/run_quality_button_test.ps1')]
        paths += [ROOT/args.report_dir/p for p in ('README.md','regression_sources.json',
            'baseline/manifest.json','quality_test.log','budget_test.log','numeric_validation.log',
            'lcd_test.log','imu_test.log','hand_test.log','learning_workflow_test.log','arm_build.log',
            'boot_build.log')]
    if button_v25:
        paths += [ROOT/p for p in ('sw/ps_uart_print/channel_quality.h',
            'sw/ps_uart_print/lcd_channel_quality.h','sim/channel_quality_test.c',
            'sim/lcd_work_budget_test.c','build/scripts/run_quality_button_test.ps1')]
        paths += [ROOT/args.report_dir/p for p in ('README.md','regression_sources.json',
            'baseline/manifest.json','quality_test.log','budget_test.log','numeric_validation.log',
            'lcd_test.log','imu_test.log','hand_test.log','learning_workflow_test.log','arm_build.log',
            'boot_build.log')]
    if button_v24:
        paths += [ROOT/p for p in ('sw/ps_uart_print/channel_quality.h',
            'sw/ps_uart_print/lcd_channel_quality.h','sim/channel_quality_test.c',
            'sim/lcd_work_budget_test.c')]
        paths += [ROOT/args.report_dir/p for p in ('README.md','regression_sources.json',
            'baseline/manifest.json','quality_test.log','budget_test.log','lcd_test.log',
            'imu_test.log','hand_test.log','learning_workflow_test.log','arm_build.log',
            'boot_build.log')]
    evidence={'date':f'{tag[:4]}-{tag[4:6]}-{tag[6:8]}','tag':tag,'hardware_verified':False,'pwm_connected':False,
        'pl_pwm_ports_present':'HAND_CONTROL' in tag,'physical_wiring_verified':False,
        'hardware_reused_from_v12':reused,
        'hardware_reused_from_v15':reused_v15,
        'application_inherited_from_v13':inherited if not stability_v16 else [],
        'application_inherited_from_v15':inherited if stability_v16 else [],
        'application_changes_from_v15':sorted(changed) if stability_v16 else [],
        'pl_partition':{'transform':transform,'header':header,'offset':offset,'bytes':length},
        'application_load_checks':checks,'fsbl_load_checks':fsbl_checks,'artifacts':[{'path':str(p.relative_to(ROOT)),
        'bytes':p.stat().st_size,'sha256':hashlib.sha256(p.read_bytes()).hexdigest()} for p in paths]}
    out=ROOT/args.report_dir;out.mkdir(parents=True,exist_ok=True)
    (out/'artifacts.json').write_text(json.dumps(evidence,indent=2))
    print(f'TEST_PASS matched control BOOT: XSA hardware + full bitstream + {len(checks)} application PT_LOAD segments + {len(fsbl_checks)} FSBL PT_LOAD segments')


if __name__=='__main__':main()
