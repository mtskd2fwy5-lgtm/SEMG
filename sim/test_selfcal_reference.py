"""Check ring remapping candidates against the board INT8 reference model."""
from pathlib import Path
import json
import sys

import numpy as np

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "tools"))
from export_int8 import Int8MLP


def remap_ring(features, shift):
    ring = (3, 0, 1, 2, 4, 5)  # CH4, CH1, CH2, CH3, CH5, CH6
    out = np.asarray(features).reshape(-1, 5, 8).copy()
    source = out.copy()
    for pos, destination in enumerate(ring):
        out[:, :, destination] = source[:, :, ring[(pos + shift) % len(ring)]]
    return out.reshape(-1, 40)


def main():
    qp = json.loads((ROOT / "data/models/nn_int8_board_multiwear/quant_params.json")
                    .read_text(encoding="utf-8"))
    net = Int8MLP(qp)
    rng = np.random.default_rng(20261023)
    samples = rng.integers(0, 2_000_000, size=(17, 40), dtype=np.int64)
    samples[:, 16:24] = rng.integers(0, 2_000_000, size=(17, 8))
    for shift in range(6):
        mapped = remap_ring(samples, shift)
        assert net.forward(mapped).shape == (17, 5)
        assert np.array_equal(mapped.reshape(-1, 5, 8)[:, :, 6:],
                              samples.reshape(-1, 5, 8)[:, :, 6:])
    assert np.array_equal(remap_ring(samples, 0), samples)
    assert np.array_equal(remap_ring(samples, 6), samples)
    one = remap_ring(samples, 1).reshape(-1, 5, 8)
    original = samples.reshape(-1, 5, 8)
    ring = (3, 0, 1, 2, 4, 5)
    for pos, destination in enumerate(ring):
        assert np.array_equal(one[:, :, destination],
                              original[:, :, ring[(pos + 1) % len(ring)]])
    print("selfcal reference: 6 shifts, fixed CH7/CH8, 17 windows OK")


if __name__ == "__main__":
    main()
