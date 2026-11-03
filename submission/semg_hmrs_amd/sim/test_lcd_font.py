"""Check common-baseline glyphs against the source font, including descenders."""
import sys
import unittest
from pathlib import Path
from PIL import Image, ImageDraw, ImageFont

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / 'tools'))
from gen_hz_glyphs import FONT, SIZES, font_metrics, render_glyph


class FontBaselineTest(unittest.TestCase):
    def test_source_bearings_and_unclipped_descenders(self):
        # Glyphs with different top bearings expose per-character centering;
        # lower-case descenders expose the old short square bitmap clipping.
        chars = '中手设置通道置信度0123456789ADCWMHzmsgpqy[]|±%/.,-'
        for size in SIZES:
            font = ImageFont.truetype(str(FONT), size)
            baseline, height = font_metrics(font, chars)
            bottoms = {}
            for char in chars:
                with self.subTest(size=size, char=char):
                    actual = render_glyph(char, font, size, baseline, height)
                    reference = Image.new('L', (128, 128))
                    ImageDraw.Draw(reference).text((32, 64), char, font=font,
                                                   fill=255, anchor='ls')
                    expected_box = reference.point(lambda p: 255 if p >= 9 else 0).getbbox()
                    actual_box = actual.point(lambda p: 255 if p >= 9 else 0).getbbox()
                    self.assertIsNotNone(actual_box)
                    self.assertLessEqual(abs(actual_box[1]-baseline-(expected_box[1]-64)), 1)
                    self.assertLessEqual(abs(actual_box[3]-baseline-(expected_box[3]-64)), 1)
                    bottoms[char] = actual_box[3]
            self.assertEqual(bottoms['H'], bottoms['0'])
            self.assertEqual(bottoms['z'], bottoms['0'])
            for char in 'gpqy':
                self.assertGreater(bottoms[char], bottoms['0'])


if __name__ == '__main__':
    unittest.main()

