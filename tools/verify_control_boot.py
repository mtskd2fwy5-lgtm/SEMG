"""Check the matched PL-control XSA/bitstream/ELF/BOOT and write evidence."""
from pathlib import Path
import argparse
import hashlib
import json
import struct
import zipfile
from verify_boot_partition import find_partition

ROOT = Path(__file__).resolve().parents[1]
TAG = '20261023_GRIP_FEEDBACK_V1'


def main():
    ap=argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--hardware-only',action='store_true')
    ap.add_argument('--application-only',action='store_true')
    ap.add_argument('--tag',default=TAG)
    ap.add_argument('--report-dir',default='report/grip_feedback_20261023')
    args=ap.parse_args()
    tag=args.tag
    assert tag and all(c.isalnum() or c=='_' for c in tag), 'invalid build tag'
    bit_path = ROOT/'build/vivado/hand_motion_reconstruction.runs/impl_1/design_1.bit'
    elf_path = ROOT/'sw/ps_uart_print/ps_uart_print_pl_control.elf'
    boot_path = ROOT/f'build/boot/BOOT_{tag}.BIN'
    xsa_path = ROOT/'build/export/design_1.xsa'
    bit=bit_path.read_bytes()
    with zipfile.ZipFile(xsa_path) as z:
        names=z.namelist()
        bit_names=[n for n in names if n.endswith('.bit')]
        assert len(bit_names)==1 and z.read(bit_names[0])==bit, 'XSA hardware differs'
        hwh='\n'.join(z.read(n).decode() for n in names if n.endswith('.hwh'))
        assert 'emg_pl_control' in hwh and 'axi_gpio_4' in hwh and '0x41240000' in hwh, 'XSA lacks control mailbox'
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
    paths=[bit_path,elf_path,boot_path,xsa_path]
    paths += [ROOT/p for p in ('src/rtl/emg_control_policy.v','src/rtl/emg_control_inference.v',
        'src/rtl/emg_control_constants.vh','src/rtl/emg_pl_control.v','src/rtl/emg_pl_export.v',
        'src/rtl/hand_servo_pwm.v','sw/ps_uart_print/main.c','sw/ps_uart_print/pl_control.h',
        'sw/ps_uart_print/synergy_feedback.h','sw/ps_uart_print/lcd_rehab.h','sw/ps_uart_print/rehab_training.h',
        'sw/ps_uart_print/synergy_nmf.h','sw/ps_uart_print/synergy_nmf_model.h','sw/ps_uart_print/lcd_font_zh.h')]
    evidence={'date':'2026-10-23','tag':tag,'hardware_verified':False,'pwm_connected':False,
        'pl_partition':{'transform':transform,'header':header,'offset':offset,'bytes':length},
        'application_load_checks':checks,'artifacts':[{'path':str(p.relative_to(ROOT)),
        'bytes':p.stat().st_size,'sha256':hashlib.sha256(p.read_bytes()).hexdigest()} for p in paths]}
    out=ROOT/args.report_dir;out.mkdir(parents=True,exist_ok=True)
    (out/'artifacts.json').write_text(json.dumps(evidence,indent=2))
    print(f'TEST_PASS matched control BOOT: XSA hardware + full bitstream + {len(checks)} application PT_LOAD segments')


if __name__=='__main__':main()
