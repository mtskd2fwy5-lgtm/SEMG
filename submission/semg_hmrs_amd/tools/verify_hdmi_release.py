"""Check HDMI-specific evidence without weakening existing DSP/BOOT gates."""
from pathlib import Path
import hashlib
import json
import re
import zipfile

ROOT=Path(__file__).resolve().parents[1]

def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()

def read_log(path):
    data=path.read_bytes()
    return data.decode('utf-16' if data.startswith((b'\xff\xfe',b'\xfe\xff')) else 'utf-8-sig',errors='replace')

def verify(report,xsa):
    baseline=json.loads((report/'baseline_sources.json').read_text(encoding='utf-8'))
    allowed={'src/rtl/touch_gt911.v','sw/ps_uart_print/main.c','board/constraints/hz_zynq_lcd.xdc'}
    unchanged=0
    for name,expected in baseline.items():
        if name not in allowed:
            assert hashlib.sha256((ROOT/name).read_bytes().replace(b'\r\n',b'\n')).hexdigest()==expected, 'Unexpected inherited source change: '+name
            unchanged+=1
    assert unchanged>70,'Incomplete inherited-source inventory'
    proof=json.loads((report/'regression_sources.json').read_text(encoding='utf-8'))
    required={'src/rtl/hdmi_scaler.v','src/rtl/hdmi_output.v','src/rtl/hdmi_serializer.v',
        'src/rtl/hdmi_tmds_encoder.v','board/constraints/hz_zynq_hdmi.xdc',
        'sw/ps_uart_print/hdmi_mirror.h','sw/ps_uart_print/main.c','sim/lcd_firmware_test.c',
        'build/scripts/add_hdmi_mirror.tcl','build/scripts/rebuild_hdmi_mirror.tcl',
        'build/scripts/run_hdmi_test.ps1','tools/verify_hdmi_release.py',
        'board/constraints/hz_zynq_hdmi_timing.xdc','build/update_project.tcl',
        'build/scripts/audit_hdmi_routed.tcl','build/scripts/run_hdmi_pipeline_test.ps1',
        'sim/hdmi_video_pipeline_tb.sv', 'sim/hdmi_support/timing_serializer_stub.v'}
    assert required<=proof.keys(),'Incomplete HDMI source binding'
    for name,expected in proof.items():
        assert digest(ROOT/name)==expected,'Stale HDMI evidence: '+name
    markers={
        'hdmi_scaler_test.log':['TEST_PASS HDMI scaler 800x480: 2764800 exact pixels',
            'TEST_PASS HDMI scaler 1024x600: 2764800 exact pixels','TEST_PASS HDMI scaler complete'],
        'hdmi_tmds_test.log':['TEST_PASS HDMI TMDS: 100000 symbols'],
        'serializer_check.log':['TEST_PASS HDMI OSERDES:'],
        'output_test.log':['TEST_PASS HDMI output:'],
        'scaler_netlist_test.log':['TEST_PASS HDMI scaler complete'],
        'scaler_synthesis_console.log':['TEST_PASS HDMI scaler synthesis: exactly two block RAMs'],
        'pipeline_test.log':['TEST_PASS HDMI video pipeline:'],
        'bd_contract_test.log':['TEST_PASS HDMI BD:'],
        'routed_audit_console.log':['TEST_PASS HDMI routed audit:'],
        'platform_build.log':['PL_LEARNING_PLATFORM_BUILD_FINISHED'],
        'lcd_test.log':['TEST_PASS HDMI firmware:','TEST_PASS LCD:',
            'TEST_PASS HDC continuous UI:','TEST_PASS HDC MODEL LIBRARY:',
            'TEST_PASS NAV LIFECYCLE: 144 routes'],
        'hand_test.log':['TEST_PASS HDC continuous link:','TEST_PASS hand firmware:'],
        'model_test.log':['TEST_PASS'], 'sd_test.log':['TEST_PASS'], 'uart_test.log':['TEST_PASS'],
        'learning_workflow_test.log':['TEST_PASS PL backend failures invalidate model and NMF without software fallback'],
        'hardware_console.log':['TEST_PASS HDMI full-system routed build complete']}
    for name,terms in markers.items():
        content=read_log(report/name)
        assert all(s in content for s in terms),'Missing HDMI evidence: '+name
        assert not re.search(r'(?im)^(Fatal:|ERROR:|Assertion failed:|FAIL line)',content),'Failed evidence: '+name
    assert 'All user specified timing constraints are met' in read_log(report/'timing_routed.rpt')
    assert 'Critical Warning' not in read_log(report/'methodology_routed.rpt'), 'Unresolved critical methodology warning'
    from check_hdmi_bd import verify as verify_bd
    verify_bd(report/'baseline_bd_contract.json')
    with zipfile.ZipFile(xsa) as z:
        hwh='\n'.join(z.read(n).decode() for n in z.namelist() if n.endswith('.hwh'))
        for token in ('axi_vdma_hdmi','0x43010000','gpio_hdmi','0x41280000',
                      'hdmi_scaler','hdmi_output','hdmi_data_p','hdmi_clk_p',
                      'mpu_attitude','0x41270000','emg_learning_accel'):
            assert token in hwh,'Missing HDMI/inherited hardware: '+token
    print(f'TEST_PASS HDMI release: {unchanged} inherited sources, exact scaling/TMDS/OSERDES, dual-reader firmware, routed system')

