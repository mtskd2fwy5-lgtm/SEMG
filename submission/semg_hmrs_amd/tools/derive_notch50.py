#!/usr/bin/env python3
"""Derive a PL-compatible notch50 capture from one raw CSV.

The board UART currently streams one source at a time.  This utility keeps a
single raw capture as the source of truth and writes a timestamp-aligned
notch50 companion using the exact integer filter used by the PL reference.
"""

import argparse
import csv
import json
import os
import sys
import time

from emg_reference import Notch50, NotchComb, ProcessedSignal, line_filter_metadata


ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
CHANNELS = 8
FILTER_META = {
    "id": Notch50.FILTER_ID,
    "frequency_hz": 50,
    "q": 10,
    "sample_rate_hz": 4000,
    "location": "derived_from_raw",
}


def metadata_path(path):
    """Use a repository-relative path when possible, absolute otherwise."""
    try:
        value = os.path.relpath(path, ROOT)
    except ValueError:
        value = os.path.abspath(path)
    return value.replace("\\", "/")


def sidecar_path(csv_path):
    return os.path.splitext(csv_path)[0] + ".json"


def default_output_paths(input_csv, signal="notch50"):
    """Return non-overwriting companion CSV/JSON paths."""
    stem, ext = os.path.splitext(input_csv)
    base = stem + "_" + signal
    candidate = base
    serial_no = 0
    while any(os.path.exists(candidate + suffix) for suffix in (ext, ".json")):
        serial_no += 1
        candidate = "%s_%s_%d" % (
            base,
            time.strftime("%Y%m%d_%H%M%S"),
            serial_no,
        )
    return candidate + ext, candidate + ".json"


def _load_meta(meta_path):
    if not meta_path or not os.path.exists(meta_path):
        return {}
    with open(meta_path, encoding="utf-8") as fh:
        meta = json.load(fh)
    if not isinstance(meta, dict):
        raise ValueError("metadata must be a JSON object: %s" % meta_path)
    return meta


def _validate_header(header, input_csv):
    required = ["timestamp_us"] + ["channel_%d" % c for c in range(CHANNELS)]
    missing = [name for name in required if name not in header]
    if missing:
        raise ValueError("%s is missing columns: %s" %
                         (input_csv, ", ".join(missing)))
    indexes = [header.index(name) for name in required]
    return indexes


def derive_capture(input_csv, output_csv=None, input_meta=None,
                   output_meta=None, expected_fs=4000, signal="notch50"):
    """Derive a notch50 companion and return its counts and gap resets.

    Rows retain their original timestamps and all non-channel columns.  A
    missing timestamp interval cannot be reconstructed from a UART capture,
    so each channel filter state is reset at that boundary instead of
    pretending that the remaining samples are contiguous.
    """
    if signal not in ("notch50", "notchcomb", "processed"):
        raise ValueError("unsupported output signal: " + signal)
    output_signal = signal
    model = {"notchcomb":NotchComb, "notch50":Notch50, "processed":ProcessedSignal}[signal]
    input_csv = os.path.abspath(input_csv)
    if output_csv is None:
        output_csv, default_meta = default_output_paths(input_csv, output_signal)
    else:
        default_meta = sidecar_path(output_csv)
    if output_meta is None:
        output_meta = default_meta
    output_csv = os.path.abspath(output_csv)
    output_meta = os.path.abspath(output_meta)
    if os.path.normcase(input_csv) == os.path.normcase(output_csv):
        raise ValueError("output CSV must differ from input CSV")
    if input_meta is None:
        input_meta = sidecar_path(input_csv)
    source_meta = _load_meta(input_meta)
    signal = source_meta.get("signal")
    if signal in ("notch50", "notchcomb", "processed"):
        raise ValueError("input is already marked notch50; refusing to filter twice")
    if signal not in (None, "raw"):
        raise ValueError("input signal must be raw or unspecified, got %r" % signal)
    if source_meta.get("filter") not in (None, {}):
        raise ValueError("input metadata already contains a filter; refusing to filter twice")
    fs = int(source_meta.get("sample_rate_hz", expected_fs))
    if expected_fs != 4000:
        raise ValueError("the PL notch50 reference requires expected_fs=4000")
    if fs != expected_fs:
        raise ValueError("notch50 requires %d Hz input, got %d Hz" %
                         (expected_fs, fs))
    period_us = 1000000 // expected_fs
    filters = [model() for _ in range(CHANNELS)]
    rows_read = 0
    rows_written = 0
    gap_resets = 0
    previous_timestamp = None

    os.makedirs(os.path.dirname(output_csv), exist_ok=True)
    with open(input_csv, newline="", encoding="utf-8") as src, \
            open(output_csv, "x", newline="", encoding="utf-8") as dst:
        reader = csv.reader(src)
        writer = csv.writer(dst, lineterminator="\n")
        try:
            header = next(reader)
        except StopIteration:
            raise ValueError("input CSV is empty: %s" % input_csv)
        indexes = _validate_header(header, input_csv)
        channel_indexes = indexes[1:]
        timestamp_index = indexes[0]
        writer.writerow(header)
        for line_no, row in enumerate(reader, start=2):
            if not row or all(not value.strip() for value in row):
                continue
            if len(row) != len(header):
                raise ValueError("%s line %d has %d columns, expected %d" %
                                 (input_csv, line_no, len(row), len(header)))
            try:
                timestamp = int(row[timestamp_index])
                values = [int(row[index]) for index in channel_indexes]
            except ValueError as exc:
                raise ValueError("%s line %d has a non-integer sample" %
                                 (input_csv, line_no)) from exc
            if (previous_timestamp is not None and
                    timestamp != previous_timestamp + period_us):
                filters = [model() for _ in range(CHANNELS)]
                gap_resets += 1
            filtered = [filters[ch].step(values[ch]) for ch in range(CHANNELS)]
            for index, value in zip(channel_indexes, filtered):
                row[index] = str(value)
            writer.writerow(row)
            previous_timestamp = timestamp
            rows_read += 1
            rows_written += 1

    meta = dict(source_meta)
    meta.update({
        "file": metadata_path(output_csv),
        "source": "derived from raw CSV with exact PL " + output_signal + " reference",
        "signal": output_signal,
        "filter": line_filter_metadata(output_signal, "derived_from_raw"),
        "wire_sync_hex": None,
        "units": "ADC counts, int24 signed (" + output_signal + ")",
        "frames_captured": rows_read,
        "frames_written": rows_written,
        "derived_from": metadata_path(input_csv),
        "derived_filter_id": model.FILTER_ID,
        "filter_state_resets_at_timestamp_gaps": gap_resets,
        "timestamp_alignment": "copied from raw input; no resampling",
        "filter_initial_state": "zero at first captured row and each timestamp gap",
        "hardware_alignment_note": "PL may be warm at capture start; equal coefficients do not imply equal initial transients",
    })
    os.makedirs(os.path.dirname(output_meta), exist_ok=True)
    with open(output_meta, "x", encoding="utf-8") as fh:
        json.dump(meta, fh, indent=2)
        fh.write("\n")
    return rows_read, gap_resets, output_csv, output_meta


def main(argv=None):
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument("--input", required=True,
                    help="raw capture CSV")
    ap.add_argument("--signal", choices=["notch50", "notchcomb", "processed"], default="processed")
    ap.add_argument("--output", help="filtered CSV; default appends selected signal name")
    ap.add_argument("--input-meta", help="raw sidecar JSON; default next to CSV")
    ap.add_argument("--output-meta", help="filtered sidecar JSON; default next to output")
    args = ap.parse_args(argv)
    try:
        rows, resets, output_csv, output_meta = derive_capture(
            args.input, args.output, args.input_meta, args.output_meta, signal=args.signal)
    except (OSError, ValueError, json.JSONDecodeError) as exc:
        ap.error(str(exc))
    print("derived %d rows -> %s" % (rows, metadata_path(output_csv)))
    print("meta -> %s" % metadata_path(output_meta))
    if resets:
        print("WARNING: reset notch50 state at %d timestamp gap(s); "
              "missing UART samples cannot be reconstructed" % resets)
    return 0


if __name__ == "__main__":
    sys.exit(main())

