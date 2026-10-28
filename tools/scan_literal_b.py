import re
import sys
import os
import glob

# Post-build netlist gate: scan every DSP48E1 in the OOC sim netlist for
# CONSTANT (literal) B ports. In a healthy build every filter multiply
# reads its coefficient from a dont_touch register (wire-B); a literal-B
# DSP means synthesis folded a constant into the datapath - the signature
# of the coefficient corruption investigated in the 2026-10-08 MAV
# saturation incident (corrupted literals 14646 / -116680 / 14642).
#
# Usage: python tools/scan_literal_b.py [netlist.v]
#   Without arguments the newest *emg_pl_export* OOC sim netlist under
#   build/vivado is used.
# Exit 0 iff zero unexpected literal-B DSPs and zero known-bad literal hits.

BAD_VALUES = ((14646, 'B0/B2 bad'), (-116680, 'A2 bad'), (14642, 'LP bad'))

# The 30-band spectrum index uses `(spec_offset * 30) / 220`. Vivado
# implements that small, non-EMG mapping multiply as one constant-B DSP
# (`p_0_out__1` in the current OOC netlist). It is not a filter coefficient
# path and must not be confused with a folded EMG coefficient. Keep the
# exception narrow and explicit so a new constant-B DSP still fails the gate.
BENIGN_LITERAL_DSP = {
    ('p_0_out__1', 30),
    ('p_0_out', 30),  # Same spectrum-index expression after V5 elaboration.
    ('spec_idx0', 30),  # V15 banked spectrum state retains spec_offset * 30.
}

# V5 relative MDF comparisons: baseline_sum * (100 - {30,20,10})
# and trimmed_sum * 400. These are not filter coefficient paths. Entries
# verified against the V5 synthesized netlist; wrong scope/leaf/value fails.
BENIGN_FATIGUE_STATE_DSP = {
    ('candidate2', 70), ('candidate3', 80), ('candidate4', 90),
    ('current_scaled', 400),
}


def benign_literal(module, instance, value):
    # Six PWM comparators convert microseconds to 25 MHz ticks. Confirmed
    # in the routed-source OOC netlist: A is the dynamic pulse width, B=25.
    # Limit the exception to the six exact servo leaves, never filter paths.
    if module.endswith('_hand_servo_pwm') and value == 25 and instance in {
        'pwm2', 'pwm2__0', 'pwm2__1', 'pwm2__2', 'pwm2__3', 'pwm2__4'
    }:
        return 'servo pulse microseconds to 25MHz ticks'
    # Policy's percentage numerator is exps[index] * 100, not an EMG
    # filter coefficient. Scope AND leaf name AND exact value must match.
    if module.endswith('_emg_control_policy') and instance == 'numerator_reg' and value == 100:
        return 'policy confidence percent numerator'
    if module.endswith('_emg_fatigue') and (instance, value) in BENIGN_LITERAL_DSP:
        return 'spectrum-index mapping'
    if module.endswith('_emg_fatigue_state') and (instance, value) in BENIGN_FATIGUE_STATE_DSP:
        return 'relative MDF percentage comparison'
    return ''


def default_netlist():
    root = os.path.normpath(os.path.join(os.path.dirname(os.path.abspath(__file__)), '..'))
    pat = os.path.join(root, 'build', 'vivado', '*.gen', 'sources_1', 'bd',
                       'design_1', 'ip', '*emg_pl_export*', '*_sim_netlist.v')
    cands = sorted(glob.glob(pat), key=os.path.getmtime)
    return cands[-1] if cands else None


def main():
    net = sys.argv[1] if len(sys.argv) > 1 else default_netlist()
    if not net or not os.path.isfile(net):
        print('RESULT: FAIL - emg_pl_export sim netlist not found')
        return 1
    print('netlist:', net)
    txt = open(net, encoding='utf-8', errors='replace').read()

    rows = []
    modules=list(re.finditer(r'^module\s+([A-Za-z_][\w$]*)',txt,re.M))
    for m in re.finditer(r'DSP48E1 #\((.*?)\)\s*\n\s*(\w+)\s*\((.*?)\)\);', txt, re.S):
        params, inst, body = m.groups()

        def port(name, body=body):
            mm = re.search(r'\.%s\((.*?)\)\s*,' % name, body, re.S)
            return mm.group(1).strip() if mm else None

        braw = port('B') or ''
        blit = None
        bits = re.findall(r"1'b([01])", braw)
        if len(bits) == 18:
            v = int(''.join(bits), 2)
            blit = v - (1 << 18) if v >= (1 << 17) else v
        else:
            mm = re.search(r"18'h([0-9a-fA-F]+)", braw)
            if mm:
                v = int(mm.group(1), 16)
                blit = v - (1 << 18) if v >= (1 << 17) else v
        line = txt.count('\n', 0, m.start()) + 1
        module=next(x.group(1) for x in reversed(modules) if x.start()<m.start())
        rows.append((line, inst, blit, ' '.join(braw.split())[:70],module))

    print('total DSP48E1 instances :', len(rows))
    lits = [r for r in rows if r[2] is not None]
    print('literal-B (constant) DSP:', len(lits))
    for r in lits:
        reason=benign_literal(r[4],r[1],r[2])
        tag=f' [benign {reason}]' if reason else ''
        print('  line %-8d inst=%-12s B=%-8d raw=%s%s' % (*r[:4], tag))
    unexpected_lits = [r for r in lits if not benign_literal(r[4],r[1],r[2])]
    print('benign literal-B DSP     :', len(lits) - len(unexpected_lits))
    print('unexpected literal-B DSP :', len(unexpected_lits))
    print('wire-B (dynamic) DSP     :', len(rows) - len(lits))

    bad_hits = 0
    for val, name in BAD_VALUES:
        pats = [str(val)]
        for w in (18, 16, 48, 45):
            v = val & ((1 << w) - 1)
            pats.append("%d'h%x" % (w, v))
            pats.append("%d'b%s" % (w, bin(v)[2:].zfill(w)))
        hits = 0
        for p in set(pats):
            hits += txt.count(p)
        print('value %-7d (%s): %d literal hits' % (val, name, hits))
        bad_hits += hits

    ok = (len(unexpected_lits) == 0) and (bad_hits == 0)
    print('RESULT:', 'OK - zero unexpected literal-B DSPs, zero bad-value hits'
          if ok else 'FAIL - literal-B DSPs or known-bad literals present')
    return 0 if ok else 1


if __name__ == '__main__':
    sys.exit(main())
