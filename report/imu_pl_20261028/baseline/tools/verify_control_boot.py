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
TAG = '20261027_HAND_CONTROL_HDC_DYNAMIC_V16'


def main():
    ap=argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--hardware-only',action='store_true')
    ap.add_argument('--application-only',action='store_true')
    ap.add_argument('--tag',default=TAG)
    ap.add_argument('--report-dir',default='report/hdc_stability_20261027')
    args=ap.parse_args()
    tag=args.tag
    virtual_v13=tag == '20261026_HAND_CONTROL_HDC_DYNAMIC_V13'
    stability_v16=tag == '20261027_HAND_CONTROL_HDC_DYNAMIC_V16'
    resource_v15=tag == '20261027_HAND_CONTROL_HDC_DYNAMIC_V15'
    resource_v14=resource_v15 or tag == '20261027_HAND_CONTROL_HDC_DYNAMIC_V14'
    learning_v12=stability_v16 or virtual_v13 or resource_v14 or tag == '20261026_HAND_CONTROL_HDC_DYNAMIC_V12'
    assert tag and all(c.isalnum() or c=='_' for c in tag), 'invalid build tag'
    bit_path = ROOT/'build/vivado/hand_motion_reconstruction.runs/impl_1/design_1.bit'
    elf_path = ROOT/'sw/ps_uart_print/ps_uart_print_pl_control.elf'
    boot_path = ROOT/f'build/boot/BOOT_{tag}.BIN'
    xsa_path = ROOT/'build/export/design_1.xsa'
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
    paths=list(dict.fromkeys(paths))
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
