# 白屏第二阶段取证：dump 帧缓冲内容 + 寄存器
set base 0x43000000
proc rd {name addr} {
    set raw [mrd -force $addr 1]
    if {[regexp {[0-9A-Fa-f]+:\s+([0-9A-Fa-f]+)} $raw -> val]} {
        puts [format "%-8s @0x%08X = 0x%08X" $name $addr 0x$val]
        return "0x$val"
    }
}
proc dump {label addr words} {
    puts "--- $label @0x[format %X $addr] ---"
    set raw [mrd -force $addr $words]
    set i 0
    foreach line [split $raw "\n"] {
        if {[regexp {([0-9A-Fa-f]+):\s+((?:[0-9A-Fa-f]{8}\s*)+)} $line -> a data]} {
            puts "  0x$a: $data"
        }
    }
}
connect -url tcp:127.0.0.1:3121
targets -set -filter {name =~ "ARM Cortex-A9 MPCore #0"}
rd CR  [expr {$base + 0x00}]
rd SR  [expr {$base + 0x04}]
rd PP  [expr {$base + 0x28}]
# 三帧缓冲头 64 字（每帧 2400*480=1152000B=0x119400）
dump "FB0 head" 0x18000000 8
dump "FB0 mid"  0x1805CA00 8
dump "FB1 head" 0x18119400 8
dump "FB2 head" 0x18232800 8
# 全白检查样本：FB0 若干位置
dump "FB0 row100" 0x1801D4C00 8
puts "=== DONE ==="
exit 0
