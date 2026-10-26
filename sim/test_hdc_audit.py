import sys
import unittest
from pathlib import Path

import numpy as np

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / 'tools'))
from audit_hdc import guided_split, fit_proto, frozen_predict, memories, resources


class HdcAuditTests(unittest.TestCase):
    def test_disjoint_bouts_and_future_only_test(self):
        y = np.repeat(np.tile(np.arange(5), 3), 50)
        b = np.repeat(np.arange(15), 50)
        fit, test, first = guided_split(y, b)
        self.assertEqual(len(fit), 200)
        self.assertTrue(fit.max() < test.min())
        self.assertFalse(set(b[fit]) & set(b[test]))
        self.assertTrue(np.all(b[test] > max(first)))

    def test_missing_calibration_or_later_class_rejected(self):
        with self.assertRaises(ValueError):
            guided_split(np.repeat(np.arange(4), 50), np.repeat(np.arange(4), 50))
        with self.assertRaises(ValueError):
            guided_split(np.repeat(np.arange(5), 50), np.repeat(np.arange(5), 50))

    def test_signed_saturation_applies_each_add(self):
        q = np.ones((300, 32), np.int8)
        y = np.zeros(300, int)
        p, sat = fit_proto(q, y, bits=8)
        self.assertTrue(np.all(p[0] == 127))
        self.assertEqual(sat, (300-127)*32)

    def test_predict_does_not_mutate_or_require_labels(self):
        q = np.array([[1, -1], [-1, 1]], np.int8)
        p, _ = fit_proto(q, np.array([0, 1]))
        before = p.copy()
        np.testing.assert_array_equal(frozen_predict(q, p), [0, 1])
        np.testing.assert_array_equal(p, before)

    def test_encoding_repeatable_and_ordered_levels_correlated(self):
        c, v = memories(2048, 16, 7, True)
        c2, v2 = memories(2048, 16, 7, True)
        np.testing.assert_array_equal(c, c2)
        np.testing.assert_array_equal(v, v2)
        self.assertEqual(np.count_nonzero(v[0] != v[-1]), 1024)
        self.assertLess(np.count_nonzero(v[0] != v[1]), 70)

    def test_integer_prototype_storage(self):
        r = resources(5, 16)
        self.assertEqual(r['active_prototype_bytes'], 20480)
        self.assertEqual(r['ideal_bram36_lower_bound'], 6)
        self.assertEqual(r['ideal_with_one_backup_lower_bound'], 11)


if __name__ == '__main__':
    unittest.main()
