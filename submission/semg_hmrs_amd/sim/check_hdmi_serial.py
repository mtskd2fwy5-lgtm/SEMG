"""Check real UNISIM OSERDESE2 bit output against source symbols, LSB first."""
from pathlib import Path
words=Path('serializer_words.txt').read_text().splitlines()
expected=''.join(word[::-1] for word in words)
actual=Path('serializer_bits.txt').read_text().strip()
# Vendor primitive startup latency may span two pixel words; find the one
# fixed bit latency, then require every subsequent bit to match exactly.
matches=[]
for offset in range(-30,61):
    lo=max(100,-offset)
    hi=min(len(expected)-30,len(actual)-offset)
    if hi-lo>4000 and expected[lo:hi]==actual[lo+offset:hi+offset]:
        matches.append((offset,hi-lo))
assert len(matches)==1, f'OSERDES ordering/latency mismatch: {matches}'
print(f'TEST_PASS HDMI OSERDES: {matches[0][1]} exact bits, LSB-first master/slave cascade, fixed {matches[0][0]}-bit latency')

