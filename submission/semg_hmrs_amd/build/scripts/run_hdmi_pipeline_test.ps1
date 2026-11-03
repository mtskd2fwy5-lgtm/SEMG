# SPDX-License-Identifier: Apache-2.0
$ErrorActionPreference='Stop'
$root=Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
if (-not $env:AMD_VIVADO_ROOT) { throw 'Set AMD_VIVADO_ROOT to the AMD unified software installation root.' }
$bin=Join-Path $env:AMD_VIVADO_ROOT 'Vivado/bin'
$out=Join-Path $root 'report/hdmi_mirror_20261103/pipeline_sim'
New-Item -ItemType Directory -Force $out | Out-Null
Push-Location $out
try {
 & "$bin/xvlog.bat" --sv "$root/src/rtl/hdmi_scaler.v" "$root/src/rtl/hdmi_output.v" "$root/src/rtl/hdmi_tmds_encoder.v" "$root/sim/hdmi_support/timing_serializer_stub.v" "$root/sim/hdmi_video_pipeline_tb.sv" "$root/build/vivado/hand_motion_reconstruction.gen/sources_1/bd/design_1/ip/design_1_video_out_hdmi_0/sim/design_1_video_out_hdmi_0.v" "$bin/../data/verilog/src/glbl.v" *> compile.log
 if($LASTEXITCODE -ne 0){throw 'Video pipeline compile failed'}
 & "$bin/xelab.bat" hdmi_video_pipeline_tb glbl -L unisims_ver -L secureip -L xpm -L v_axi4s_vid_out_v4_0_20 -s video_pipeline *> elaborate.log
 if($LASTEXITCODE -ne 0){throw 'Video pipeline elaborate failed'}
 & "$bin/xsim.bat" video_pipeline -runall *> ../pipeline_test.log
 if($LASTEXITCODE -ne 0 -or !(Select-String ../pipeline_test.log -Pattern 'TEST_PASS HDMI video pipeline:')){throw 'Actual Video Out pipeline verification failed'}
 Get-Content ../pipeline_test.log | Select-String 'TEST_PASS'
}finally{Pop-Location}

