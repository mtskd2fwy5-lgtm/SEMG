$ErrorActionPreference='Stop'
$root=(Resolve-Path (Join-Path $PSScriptRoot '../..')).Path
$out=Join-Path $root 'sim/results_v15_fatigue'
$bin='<amd-tools>/Vivado/bin'
New-Item -ItemType Directory -Force $out | Out-Null
$source=Get-Content -LiteralPath "$root/report/resource_optimization_v15_20261027/baseline/src/rtl/emg_fatigue.v" -Raw
$source=$source.Replace('emg_fatigue_state','emg_fatigue_state_v14')
$source=[regex]::Replace($source,'\bemg_fatigue\b','emg_fatigue_v14')
[IO.File]::WriteAllText("$out/emg_fatigue_v14.v",$source)
$tb=Get-Content -LiteralPath "$root/sim/tb_emg_fatigue.v" -Raw
$extra=@'
    wire ref_valid;wire[3:0]ref_id;wire[31:0]ref_data;wire[15:0]ref_seq;
    emg_fatigue_v14 reference_dut(.clk(clk),.rst_n(rst_n),
        .activity_valid(1'b1),.muscle_active(activity[3]),.activity_class(activity[2:0]),
        .sample_valid(sample_valid),.sample_channel(sample_channel),.sample_data(sample_data),
        .out_valid(ref_valid),.out_ready(out_ready),.out_id(ref_id),.out_data(ref_data),.out_sequence(ref_seq));
    integer cycles=0,first_sample_cycle=0,window_done_cycle=0;
    always @(posedge clk)begin
        #1;cycles=cycles+1;
        if({out_valid,out_id,out_data,out_sequence} !== {ref_valid,ref_id,ref_data,ref_seq})
            $fatal(1,"V15 fatigue cycle mismatch cycle=%0d got=%h ref=%h",cycles,{out_valid,out_id,out_data,out_sequence},{ref_valid,ref_id,ref_data,ref_seq});
        if(dut.state!==reference_dut.state)$fatal(1,"V15 fatigue state/latency mismatch");
        if(out_valid && out_ready && out_id==8)
            $display("FATIGUE_V15_RESULT_CYCLE sequence=%0d cycle=%0d",out_sequence,cycles);
    end
'@
$tb=$tb.Replace('    integer fi, ch;', $extra+"`n    integer fi, ch;")
$tb=$tb.Replace('TEST_PASS fatigue FFT %0d words incl backpressure and activity/saturation','TEST_PASS V15 fatigue cycle-exact %0d words incl backpressure and activity/saturation')
[IO.File]::WriteAllText("$out/tb_v15_fatigue.sv",$tb)
Push-Location $out
try {
 & "$bin/xvlog.bat" -sv "$root/src/rtl/emg_fatigue.v" emg_fatigue_v14.v tb_v15_fatigue.sv
 if($LASTEXITCODE -ne 0){throw 'V15 fatigue equivalence compile failed'}
 & "$bin/xelab.bat" tb_emg_fatigue -s v15_fatigue -debug typical
 if($LASTEXITCODE -ne 0){throw 'V15 fatigue equivalence elaboration failed'}
 & "$bin/xsim.bat" v15_fatigue -runall -log v15_fatigue.log
 if($LASTEXITCODE -ne 0 -or !(Select-String -Path v15_fatigue.log -SimpleMatch 'TEST_PASS V15 fatigue cycle-exact 576 words')){throw 'V15 fatigue equivalence failed'}
} finally {Pop-Location}

