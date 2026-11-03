"""Deterministic alternate model for arithmetic-sharing equivalence only."""
from pathlib import Path
import random
import sys
rng=random.Random(20261027)
words=[rng.getrandbits(32) for _ in range(2048)]
for i in range(40):
    words[i]=rng.randint(1,131071)
    words[0x28+i]=rng.randrange(0,55)
for addr in (0x310,0x532):
    words[addr]=131071
    words[addr+1]=18
Path(sys.argv[1]).write_text(''.join(f'{w:08x}\n' for w in words),encoding='ascii')

