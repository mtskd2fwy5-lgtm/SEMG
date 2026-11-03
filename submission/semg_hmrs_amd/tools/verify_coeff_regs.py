import re
import sys
import os
import glob
import argparse
from collections import defaultdict

# Post-build netlist gate: decode the Q16/Q15 bandpass coefficient
# registers directly from the FF INIT attributes of the OOC sim netlist.
#
# Why this exists (2026-10-08 MAV saturation incident): the Vivado 2025.2
# module_ref OOC top wrapper wrote POSITIVE sized signed parameter values
# as quoted strings; elaboration truncated the ASCII bytes to the
# parameter width and corrupted the filter (64096 -> 14646, 62688 ->
# -116680, 9392 -> 14642), pushing the IIR poles outside the unit circle.
# RTL and behavioral simulation were perfectly correct - only the netlist
# was wrong. This gate catches that failure class before a bitstream
# ships. The dont_touch coefficient registers in emg_bandpass.v are the
# decode anchor - do not remove them.
#
# Usage: python tools/verify_coeff_regs.py [netlist.v] [--expect REG=VAL ...]
#   Without netlist argument the newest *emg_pl_export* OOC sim netlist
#   under build/vivado is used (the IP generation index may change after
#   upgrade_ip, so never hardcode _0_4).
#   --expect REG=VAL overrides the expected value of coefficient register
#   REG (repeatable). build_all.ps1 passes the values extracted from the
#   RTL parameter declarations, keeping the RTL as the single source of
#   truth. Without --expect the emg_pl_export defaults below apply.
#   Bit widths are netlist-decoding knowledge and stay defined here.
# Exit code 0 iff every bandpass instance decodes to the expected values.

EXPECT_WIDTH = {'b0_r': 18, 'b1_r': 18, 'b2_r': 18, 'a1_r': 18, 'a2_r': 18, 'alpha_r': 16}
EXPECT_DEFAULT = {'b0_r': 64096, 'b1_r': -128192, 'b2_r': 64096,
                  'a1_r': -128161, 'a2_r': 62688, 'alpha_r': 9392}


def default_netlist():
    root = os.path.normpath(os.path.join(os.path.dirname(os.path.abspath(__file__)), '..'))
    pat = os.path.join(root, 'build', 'vivado', '*.gen', 'sources_1', 'bd',
                       'design_1', 'ip', '*emg_pl_export*', '*_sim_netlist.v')
    cands = sorted(glob.glob(pat), key=os.path.getmtime)
    return cands[-1] if cands else None


def parse_args():
    ap = argparse.ArgumentParser(
        description='Decode Q16/Q15 bandpass coefficient registers from the OOC sim netlist.')
    ap.add_argument('netlist', nargs='?',
                    help='sim netlist (default: newest *emg_pl_export* netlist under build/vivado)')
    ap.add_argument('--expect', action='append', default=[], metavar='REG=VAL',
                    help='override expected value of coefficient register REG (repeatable)')
    return ap.parse_args()


def build_expect(overrides):
    expect = {reg: (EXPECT_DEFAULT[reg], width) for reg, width in EXPECT_WIDTH.items()}
    for ov in overrides:
        reg, sep, val = ov.partition('=')
        if reg not in EXPECT_WIDTH or not sep:
            print('RESULT: FAIL - bad --expect entry %r (want REG=%s, REG in %s)'
                  % (ov, '|'.join(EXPECT_WIDTH), ', '.join(EXPECT_WIDTH)))
            sys.exit(1)
        try:
            expect[reg] = (int(val, 0), EXPECT_WIDTH[reg])
        except ValueError:
            print('RESULT: FAIL - non-numeric value in --expect %r' % ov)
            sys.exit(1)
    return expect


def decode(bits, width):
    v = 0
    for i, b in bits.items():
        if b == '1':
            v |= (1 << i)
    return v - (1 << width) if v >= (1 << (width - 1)) else v


def main():
    args = parse_args()
    net = args.netlist or default_netlist()
    expect = build_expect(args.expect)
    if not net or not os.path.isfile(net):
        print('RESULT: FAIL - emg_pl_export sim netlist not found')
        return 1
    print('netlist:', net)
    txt = open(net, encoding='utf-8', errors='replace').read()

    bodies = []
    for m in re.finditer(r'^module (\S+)', txt, re.M):
        if 'bandpass' in m.group(1):
            end = txt.find('endmodule', m.start())
            bodies.append((m.group(1), txt[m.start():end]))
    print('bandpass modules found: %d' % len(bodies))
    if not bodies:
        print('RESULT: FAIL - no bandpass modules in netlist')
        return 1

    ok_all = True
    for modname, body in bodies:
        regs = defaultdict(dict)
        # FDRE/FDSE/FDCE/FDPE, optional #(...) params, escaped \name[bit] or plain
        for m in re.finditer(r'\b(FDRE|FDSE|FDCE|FDPE)\s*(?:#\((.*?)\))?\s*([^\s(]+)\s*\(', body, re.S):
            fftype, params, name = m.group(1), m.group(2) or '', m.group(3)
            bm = re.match(r'\\?(.*)\[(\d+)\]$', name)
            if not bm:
                continue
            base, bit = bm.group(1), int(bm.group(2))
            im = re.search(r"\.INIT\(1'b([01])\)", params)
            val = im.group(1) if im else ('0' if fftype in ('FDRE', 'FDCE') else '1')
            regs[base][bit] = val
        found = {}
        for base, bits in regs.items():
            for cname, (cval, cwidth) in expect.items():
                if base.endswith(cname) or base.endswith(cname + '_reg'):
                    found[cname] = (len(bits), decode(bits, cwidth) if len(bits) == cwidth else None)
        line = [modname.split('_emg_bandpass')[-1] or modname]
        for cname, (cval, cwidth) in expect.items():
            if cname not in found:
                line.append('%s:MISSING' % cname)
                ok_all = False
            else:
                n, val = found[cname]
                if val == cval:
                    line.append('%s=%d(OK)' % (cname, val))
                else:
                    line.append('%s=%s(BAD,n=%d)' % (cname, val, n))
                    ok_all = False
        print('  ' + ' '.join(line))

    print('RESULT:', 'ALL COEFFICIENT REGISTERS CORRECT' if ok_all else 'FAIL - MISMATCH/MISSING DETECTED')
    return 0 if ok_all else 1


if __name__ == '__main__':
    sys.exit(main())

