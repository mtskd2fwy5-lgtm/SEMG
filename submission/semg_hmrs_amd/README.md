# Self-learning sEMG Intent Decoding and Rehabilitation Training System

This is the curated submission package for the AMD 2026 FPGA autonomous-track
entry. It follows the guide's recommended structure while keeping the original
project's PL/PS split and adding HDMI as a second display path.

## Guide mapping

| Guide requirement | Package location |
| --- | --- |
| Project overview and reproduction steps | `README.md`, `report/competition_checklist.md` |
| RTL, PS software and configuration | `src/`, `sw/ps_uart_print/`, `build/` |
| Simulation and reference comparison | `sim/`, `tools/`, `report/submission_evidence/` |
| Board project and bring-up information | `board/`, `build/vivado/.../design_1/` |
| Data and model inputs | `data/` (metrics and bounded model assets only) |
| Reusable skills | `skill/` |
| Design report and AI collaboration record | `report/design_report/`, `report/ai_collaboration_20261103/` |

All package directory and file names are ASCII and use lower-case, digits,
underscores or hyphens. Raw human recordings, temporary wave exports, tool
caches, generated binaries and local machine paths are excluded.

## Architecture

The PL implements ADS1299 SPI acquisition, line-frequency and harmonic
suppression, filtering, windowed features, FFT/fatigue processing, MLP/HDC/NMF
accelerators, PL MPU attitude processing and protected six-channel PWM. The PS
manages calibration, model and SD lifecycles, LCD touch UI, data analysis,
rehabilitation tasks and validated result routing. LCD remains the touch input;
HDMI mirrors the rendered frame at 1280x720p60 through an independent DDR
reader and two-line BRAM scaler.

## Reproduction

Use Vivado/Vitis 2025.2 with an XC7Z020CLG400-2 device. Set
`AMD_VIVADO_ROOT` to the AMD unified software installation directory (the
directory containing `Vivado/` and `Vitis/`), or put the required executables
on `PATH`. From the package root:

```powershell
vivado -mode batch -source build/recreate_project.tcl
powershell -ExecutionPolicy Bypass -File build/scripts/run_hdmi_test.ps1
powershell -ExecutionPolicy Bypass -File build/scripts/run_hdmi_pipeline_test.ps1
powershell -ExecutionPolicy Bypass -File build/build_all.ps1 -SkipBuild -SkipBoot
powershell -ExecutionPolicy Bypass -File build/boot/build_pl_control_boot.ps1
```

The last command requires the local Vitis platform workspace generated from the
matching XSA. It produces the BOOT image; the package does not include a boot
binary. Use the evidence under `report/submission_evidence/` to distinguish
RTL simulation, generated-netlist simulation, routed implementation and
application regression. A physical board test is a separate acceptance step.

## License boundary

Original project material is Apache-2.0. AMD tools, generated vendor IP,
board/device documentation and font assets retain their upstream licenses;
see `THIRD_PARTY_NOTICES.md`.








