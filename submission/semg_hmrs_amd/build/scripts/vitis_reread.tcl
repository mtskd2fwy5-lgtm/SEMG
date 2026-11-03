# Re-read the freshly exported XSA into the Vitis platform project and
# regenerate the fsbl BSP + domain.
#
# Prerequisite: build/export/design_1.xsa exported by check_design.tcl
# (write_hw_platform) from the current PL build.
#
# Usage: xsct.bat build/scripts/vitis_reread.tcl

set ws  ./build/vitis_ws
set xsa ./build/export/design_1.xsa

if {![file exists $xsa]} {
    error "XSA missing: $xsa (run the Vivado build first)"
}

setws -switch $ws
platform read $ws/platform/vitis-comp.json
platform config -updatehw $xsa
platform generate
exit

