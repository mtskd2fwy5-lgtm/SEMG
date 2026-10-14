# fix-20 判决脚本：只读 VDMA MM2S 寄存器（CR/SR/FRMSTORE/PARKPTR/几何）
# 判据：SR bit7 FSIZEERR / bit11 FSIZE_MORE_OR_SOF_LATE => fsize 自毁路径实锤
#       SR bit4/5/6 (IntErr/SlvErr/DecErr) => AXI 错误路径
# 注意：mrd -force 绕过 2025.2 PL AXI 地址封锁；输出无 0x 前缀
set base 0x43000000

proc rd {name addr} {
    set raw [mrd -force $addr 1]
    if {[regexp {[0-9A-Fa-f]+:\s+([0-9A-Fa-f]+)} $raw -> val]} {
        set v "0x$val"
        puts [format "%-10s @0x%08X = 0x%08X (%d)" $name $addr $v [expr $v]]
        return $v
    } else {
        puts "$name @0x[format %X $addr] = NA ($raw)"
        return 0
    }
}

connect -url tcp:127.0.0.1:3121
targets -set -filter {name =~ "ARM Cortex-A9 MPCore #0"}
puts "=== target: [targets] ==="

set cr   [rd CR        [expr {$base + 0x00}]]
set sr   [rd SR        [expr {$base + 0x04}]]
set fs   [rd FRMSTORE  [expr {$base + 0x18}]]
set pp   [rd PARKPTR   [expr {$base + 0x28}]]
set vs   [rd VSIZE     [expr {$base + 0x50}]]
set hs   [rd HSIZE     [expr {$base + 0x54}]]
set st   [rd STRIDE    [expr {$base + 0x58}]]

puts "--- CR 分解 ---"
puts [format "CR  RS=%d TailEn=%d RESET=%d FrmCntEn=%d Thresh=0x%02X" \
    [expr {$cr & 0x1}] [expr {($cr >> 1) & 0x1}] [expr {($cr >> 2) & 0x1}] \
    [expr {($cr >> 4) & 0x1}] [expr {($cr >> 16) & 0xFF}]]

puts "--- SR 分解（判决区） ---"
puts [format "SR  HALTED=%d IDLE=%d" [expr {$sr & 0x1}] [expr {($sr >> 1) & 0x1}]]
puts [format "ERR=%d IntErr=%d SlvErr=%d DecErr=%d" \
    [expr {($sr >> 3) & 0x1}] [expr {($sr >> 4) & 0x1}] [expr {($sr >> 5) & 0x1}] [expr {($sr >> 6) & 0x1}]]
puts [format ">>> FSIZEERR(bit7)=%d  LSIZEERR(bit8)=%d  FSIZE_MORE_OR_SOF_LATE(bit11)=%d  LSIZE_MORE(bit15)=%d" \
    [expr {($sr >> 7) & 0x1}] [expr {($sr >> 8) & 0x1}] [expr {($sr >> 11) & 0x1}] [expr {($sr >> 15) & 0x1}]]
puts [format "IRQ: IOC=%d DLY=%d ERRIRQ=%d FrameCount=0x%02X Delay=0x%02X" \
    [expr {($sr >> 12) & 0x1}] [expr {($sr >> 13) & 0x1}] [expr {($sr >> 14) & 0x1}] \
    [expr {($sr >> 16) & 0xFF}] [expr {($sr >> 24) & 0xFF}]]
puts [format "PARKPTR raw=0x%08X  MM2S_FRMPTR[4:0]=%d  MM2S_FRMSTR[20:16]=%d" \
    $pp [expr {$pp & 0x1F}] [expr {($pp >> 16) & 0x1F}]
puts [format "几何: VSIZE=%d HSIZE=%d STRIDE=%d FRMSTORE=%d" $vs $hs $st $fs]
puts "=== DONE ==="
exit 0
