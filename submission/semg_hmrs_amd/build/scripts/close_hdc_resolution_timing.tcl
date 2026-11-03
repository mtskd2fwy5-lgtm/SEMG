# Continue physical optimization on the actual routed system; no timing exceptions.
set root [file normalize [file join [file dirname [info script]] ../..]]
set out [file join $root report/hdc_resolution_20261102]
set run_dir [file join $root build/vivado/hand_motion_reconstruction.runs/impl_1]
open_checkpoint [file join $run_dir design_1_routed.dcp]
phys_opt_design -directive AggressiveExplore
route_design -directive MoreGlobalIterations
report_timing_summary -file [file join $out timing_routed.rpt]
report_utilization -file [file join $out utilization_routed.rpt]
report_utilization -hierarchical -file [file join $out utilization_hierarchical.rpt]
report_methodology -file [file join $out methodology_routed.rpt]
report_drc -file [file join $out drc_routed.rpt]
foreach kind {max min} {
    set worst [get_timing_paths -delay_type $kind -max_paths 1]
    if {![llength $worst] || [get_property SLACK $worst] < 0} {error "HDC $kind timing failed; export refused"}
}
write_checkpoint -force [file join $run_dir design_1_routed.dcp]
report_timing_summary -file [file join $run_dir design_1_timing_summary_routed.rpt]
write_bitstream -force [file join $run_dir design_1.bit]
write_hw_platform -fixed -include_bit -force [file join $root build/export/design_1.xsa]
# Non-project XSA export regenerates the same configuration with a new .bit
# header timestamp. Package the XSA's canonical bit, after checking all bytes
# except that timestamp against the just-written routed bitstream.
exec python -c {
from pathlib import Path
import zipfile,sys,json,hashlib
root=Path(sys.argv[1])
p=root/'build/vivado/hand_motion_reconstruction.runs/impl_1/design_1.bit'
a=p.read_bytes()
with zipfile.ZipFile(root/'build/export/design_1.xsa') as z:
    names=[n for n in z.namelist() if n.endswith('.bit')]
    assert len(names)==1
    b=z.read(names[0])
marker=b'd\x00\x09'
start=a.index(marker)+len(marker)
assert a[:start]==b[:start] and a[start+9:]==b[start+9:], 'Exported XSA configuration differs'
p.write_bytes(b)
(root/'report/hdc_resolution_20261102/xsa_bit_extraction.json').write_text(json.dumps({
    'routed_sha256':hashlib.sha256(a).hexdigest(),
    'canonical_sha256':hashlib.sha256(b).hexdigest(),
    'only_bit_header_timestamp_differs':True},indent=2))
} $root
puts "TEST_PASS HDC Q32 full-system timing closure complete"

