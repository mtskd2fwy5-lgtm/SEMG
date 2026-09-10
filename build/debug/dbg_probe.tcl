# Probe current target state (read-only).
connect
targets
puts "------"
set tgts [targets]
if {[string match "*Cortex-A9*#0*" $tgts]} {
    targets -set -filter {name =~ "*Cortex-A9*#0"}
    puts "A9-0 STATE: [state]"
}
disconnect
exit
