import sys
import os

# Verify that the BOOT.BIN bitstream partition is a byte-exact transform
# of design_1.bit. bootgen stores the bitstream payload with each 32-bit
# word byte-reversed (wordrev) after stripping the .bit file header.
#
# The header length VARIES PER BUILD (observed 101 -> 104 -> 128 bytes
# across this project's builds), so it is auto-probed instead of
# hardcoded - a stale hardcoded length once made every comparison fail
# while the image was actually fine.
#
# Usage: python tools/verify_boot_partition.py [design_1.bit] [BOOT.BIN]
# Exit 0 iff the full payload matches byte-for-byte at some offset.

PROBE_LEN = 4096
HEADER_RANGE = range(0, 264)


def wordrev(data):
    out = bytearray(len(data))
    n4 = len(data) & ~3
    for i in range(0, n4, 4):
        out[i] = data[i + 3]
        out[i + 1] = data[i + 2]
        out[i + 2] = data[i + 1]
        out[i + 3] = data[i]
    for i in range(n4, len(data)):
        out[i] = data[i]
    return bytes(out)


def byterev16(data):
    out = bytearray(len(data))
    n2 = len(data) & ~1
    for i in range(0, n2, 2):
        out[i] = data[i + 1]
        out[i + 1] = data[i]
    for i in range(n2, len(data)):
        out[i] = data[i]
    return bytes(out)


def find_partition(bit, boot):
    for tname, tf in (('wordrev', wordrev),
                      ('identity', lambda d: d),
                      ('byterev16', byterev16)):
        for hdr in HEADER_RANGE:
            payload = bit[hdr:]
            if len(payload) < PROBE_LEN:
                break
            if boot.find(tf(payload[:PROBE_LEN])) < 0:
                continue
            full = tf(payload)
            pos = boot.find(full)
            if pos >= 0 and boot[pos:pos + len(full)] == full:
                return tname, hdr, pos, len(full)
    return None, None, -1, 0


def main():
    root = os.path.normpath(os.path.join(os.path.dirname(os.path.abspath(__file__)), '..'))
    bit_path = sys.argv[1] if len(sys.argv) > 1 else os.path.join(
        root, 'build', 'vivado', 'hand_motion_reconstruction.runs', 'impl_1', 'design_1.bit')
    boot_path = sys.argv[2] if len(sys.argv) > 2 else os.path.join(
        root, 'build', 'boot', 'BOOT.BIN')

    for p in (bit_path, boot_path):
        if not os.path.isfile(p):
            print('RESULT: FAIL - file not found: %s' % p)
            return 1

    bit = open(bit_path, 'rb').read()
    boot = open(boot_path, 'rb').read()
    print('bit %d bytes, BOOT.BIN %d bytes' % (len(bit), len(boot)))

    tname, hdr, pos, n = find_partition(bit, boot)
    if tname is None:
        print('RESULT: FAIL - no transform/header combination matches')
        return 1
    print('partition: transform=%s header=%d bytes, at 0x%X, full %d-byte match'
          % (tname, hdr, pos, n))
    print('RESULT: OK - BOOT.BIN bitstream partition == %s(design_1.bit[%d:])'
          % (tname, hdr))
    return 0


if __name__ == '__main__':
    sys.exit(main())
