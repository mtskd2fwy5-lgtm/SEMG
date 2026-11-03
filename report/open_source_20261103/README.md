# Open-source checkpoint

The owner authorized Apache-2.0 for original project material on 2026-11-03.
`LICENSE`, `NOTICE`, and `THIRD_PARTY_NOTICES.md` define the scope and preserve
third-party terms. The existing private Git history is retained; no history
rewrite or forced push is part of this checkpoint.

This checkpoint includes the current RTL, firmware, testbenches, generators,
model assets, four FPGA development skills, selected release evidence, and
the authored report at `report/design_report/design_report.docx`.
Local reference documents, expanded wave exports, compiler outputs, FPGA
build caches, and new boot binaries are not added.

## Verification performed for this checkpoint

- HDC model storage, SD recording, UART framing, PL backend workflow and
  production hand-control firmware: `run_hdc_model_test.ps1`, with logs here.
- LCD firmware: same run, including both panel sizes, navigation lifecycle,
  stable HDC result sharing, continuous hand following, and model switching.
- PL learning accelerator: `run_learning_test.ps1`; NMF bit-exact windows,
  Q16/Q32 learning and inference, AXI faults, timeout and retry passed.
- PL hand controller: `run_hand_control_test.ps1`; atomic homing/targets,
  source isolation, watchdogs, STOP and emergency stop passed.
- Channel quality and UI scheduling: `run_quality_button_test.ps1`; C versus
  NumPy/SciPy comparison and bounded background work passed.
- Portable skills: `skill/validate_package.py` and
  `skill/test_portable_tools.py` passed.
- The existing V30 release consistency verifier passed before README/license
  metadata edits. Historical release manifests remain historical snapshots;
  their recorded README hash is not silently rewritten to this revision.
- High-confidence credential patterns were scanned in reachable Git history
  and the staged tree. The scan is not a general security audit.

The HDMI mirror release includes a new routed implementation, XSA/platform
refresh and matched BOOT verification. Physical HDMI display, SD-card write,
DDR contention during live acquisition and electrical isolation remain separate
board acceptance steps. Local tool paths must still be configured for another
PC; this checkpoint does not certify a clean-machine end-to-end reproduction.
