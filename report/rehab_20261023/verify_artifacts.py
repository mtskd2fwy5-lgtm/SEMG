"""Record hashes and verify the packaged rehabilitation application byte for byte."""
import hashlib
import json
from pathlib import Path
import struct

ROOT = Path(__file__).resolve().parents[2]
OUT = Path(__file__).resolve().parent
TAG = "20261023_REHAB_V1"
boot = (ROOT / "build/boot/BOOT.BIN").read_bytes()
elf = (ROOT / "sw/ps_uart_print/ps_uart_print.elf").read_bytes()
assert elf[:6] == b"\x7fELF\x01\x01", "Expected little-endian ELF32"
assert TAG.encode() in boot, "BOOT lacks rehabilitation build tag"
assert "PIPELINE RESULT: ALL GATES PASS" in (OUT / "build_gates.log").read_text(encoding="utf-8-sig"), "Build gates did not pass"
phoff = struct.unpack_from("<I", elf, 28)[0]
phsize, phnum = struct.unpack_from("<HH", elf, 42)
segments = []
for index in range(phnum):
    kind, offset, address, physical, size, memory, flags, alignment = struct.unpack_from("<8I", elf, phoff + index * phsize)
    if kind != 1 or not size:
        continue
    payload = elf[offset:offset + size]
    assert len(payload) == size
    location = boot.find(payload)
    assert location >= 0, f"ELF load segment {index} differs from BOOT"
    segments.append({"index": index, "address": hex(address), "bytes": size, "boot_offset": hex(location)})
assert segments, "ELF has no file-backed load segments"
paths = [
    "build/boot/BOOT.BIN",
    "sw/ps_uart_print/ps_uart_print.elf",
    "sw/ps_uart_print/main.c",
    "sw/ps_uart_print/rehab_training.h",
    "sw/ps_uart_print/lcd_rehab.h",
    "sw/ps_uart_print/sd_record.c",
    "sw/ps_uart_print/sd_record.h",
    "sw/ps_uart_print/lcd_font_zh.h",
    "sw/ps_uart_print/nn_confidence.h",
    "sw/ps_uart_print/pose_contract.h",
    "data/models/nn_int8_board_multiwear/quant_params.json",
    "data/models/nn_int8_board_multiwear/nn_int8_weights.mem",
    "build/vivado/hand_motion_reconstruction.runs/impl_1/design_1.bit",
]
files = {}
for name in paths:
    content = (ROOT / name).read_bytes()
    files[name] = {"size": len(content), "sha256": hashlib.sha256(content).hexdigest()}
previous = json.loads((ROOT / "report/pose_stability_artifacts_20261022.json").read_text(encoding="utf-8-sig"))
unchanged = [name for name in paths if name in previous["files"] and name not in ("build/boot/BOOT.BIN", "sw/ps_uart_print/ps_uart_print.elf")]
for name in unchanged:
    assert files[name]["sha256"] == previous["files"][name]["sha256"], f"Unexpected change: {name}"
manifest = {"tag": TAG, "all_build_gates": "PASS", "elf_load_segments_byte_exact": segments,
            "verified_unchanged_from_pose_stable_v2": unchanged, "files": files,
            "hardware_trial": "not performed; SD card not written"}
(OUT / "artifacts.json").write_text(json.dumps(manifest, indent=2) + "\n", encoding="utf-8")
print(json.dumps({"tag": TAG, "application_segments": segments, "BOOT": files[paths[0]], "result": "PASS"}, indent=2))
