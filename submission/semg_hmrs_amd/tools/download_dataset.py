#!/usr/bin/env python3
"""Download the baseline sEMG dataset for model training (Phase 3).

Dataset choice: NinaPro DB5, "double Myo armband" variant
    https://zenodo.org/records/1000116  (DOI 10.5281/zenodo.1000138 sibling
    of the Pizzolato et al., PLoS ONE 2017 six-setup comparison study)

Why this one (over NinaPro DB1-DB4 / Hyser / CapgMyo):
  - emg columns 1-8 are the evenly spaced electrode ring on the forearm,
    a natural match for the project's 8-channel ADS1299 chain;
  - 200 Hz sampling, 10 subjects, 52 labelled movements (basic finger
    motions, wrist flexion/extension, hand open/close, grasps) plus rest
    -> covers the README baseline classes rest/open_hand/fist/
    wrist_flex/wrist_extend with room to grow;
  - corrected labels (restimulus/rerepetition) included;
  - ~20 MB per subject, direct HTTP download, no registration, official
    md5 checksums. Hyser (256 ch @ 2048 Hz, GBs per subject) is kept as
    a future extension, not the baseline.

Each subject archive unpacks to three .mat files (one per exercise; the
zip contains a nested s{n}/ folder, which is flattened on unpack):
    S{n}_E1_A1.mat / S{n}_E2_A1.mat / S{n}_E3_A1.mat
with variables: emg (N x 16), restimulus, rerepetition, stimulus, ...

Usage:
  python tools/download_dataset.py                  # download subjects 1-3
  python tools/download_dataset.py --subjects 1 2 3 4 5
  python tools/download_dataset.py --list           # show remote files only
  python tools/download_dataset.py --keep-zip       # keep archives after unpack

Output layout (follows data/README.md):
  data/raw/ninapro_db5/s{n}/S{n}_A1_E{1..3}.mat
"""

import argparse
import hashlib
import http.client
import json
import os
import socket
import ssl
import sys
import time
import urllib.parse
import urllib.request
import zipfile

RECORD_ID = "1000116"
RECORD_API = "https://zenodo.org/api/records/" + RECORD_ID
OUT_DIR = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))),
                       "data", "raw", "ninapro_db5")

CHUNK = 1 << 16
RETRIES = 4
BACKOFF_S = 3
UA = "semg-hmrs-dataset/1.0"

# Encrypted-DNS mirrors used when the local resolver is polluted (observed on
# this network: zenodo.org -> 0.0.0.0 via plain DNS, real answer via DoH).
DOH_MIRRORS = (
    "https://dns.alidns.com/resolve?name=%s&type=A",
    "https://doh.pub/dns-query?name=%s&type=A",
)


def resolve_ip(host, timeout=10):
    """IPv4 address for `host`: system DNS first, then encrypted DoH.

    Returns (ip, via). Plain DNS is tried first so the script stays correct
    on unfiltered networks; if the resolver returns the pollution signature
    (0.0.0.0 / loopback) or fails, fall back to DoH over HTTPS, which the
    local resolver cannot tamper with.
    """
    try:
        for info in socket.getaddrinfo(host, 443, socket.AF_INET, socket.SOCK_STREAM):
            ip = info[4][0]
            if ip not in ("0.0.0.0", "127.0.0.1"):
                return ip, "system dns"
    except OSError:
        pass
    errs = []
    for tpl in DOH_MIRRORS:
        try:
            req = urllib.request.Request(tpl % host,
                                         headers={"accept": "application/dns-json",
                                                  "User-Agent": UA})
            with urllib.request.urlopen(req, timeout=timeout) as r:
                ans = json.loads(r.read()).get("Answer") or []
            ips = [a["data"] for a in ans if a.get("type") == 1]
            if ips:
                return ips[0], "doh"
        except Exception as e:  # noqa: BLE001
            errs.append(str(e)[:80])
    raise RuntimeError("cannot resolve %s (system DNS and DoH failed): %s"
                       % (host, "; ".join(errs)))


def open_stream(url, headers=None, timeout=60):
    """GET `url` pinned to a freshly resolved IP with correct TLS SNI/Host.

    The IP is resolved per request (system DNS, then DoH fallback) and the
    TLS handshake still validates the real hostname, so a polluted resolver
    cannot redirect us anywhere. Redirects are followed, each hop
    re-resolved. Returns the response; caller must read it fully or close it.
    """
    for _hop in range(5):
        p = urllib.parse.urlsplit(url)
        host = p.hostname
        ip, _via = resolve_ip(host, timeout=timeout)
        req_headers = {"Host": host, "User-Agent": UA, "Accept-Encoding": "identity"}
        if headers:
            req_headers.update(headers)
        sock = socket.create_connection((ip, 443), timeout=timeout)
        tls = ssl.create_default_context().wrap_socket(sock, server_hostname=host)
        conn = http.client.HTTPSConnection(host, 443, timeout=timeout)
        conn.sock = tls
        conn.request("GET", p.path + (("?" + p.query) if p.query else ""),
                     headers=req_headers)
        r = conn.getresponse()
        if r.status in (301, 302, 303, 307, 308):
            url = urllib.parse.urljoin(url, r.headers["Location"])
            r.read()
            conn.close()
            continue
        return r
    raise RuntimeError("too many redirects: %s" % url)


def http_get(url, timeout=60):
    last = None
    for attempt in range(1, RETRIES + 1):
        try:
            with open_stream(url, timeout=timeout) as r:
                return r.read()
        except Exception as e:  # noqa: BLE001 - report and retry any network error
            last = e
            if attempt < RETRIES:
                time.sleep(BACKOFF_S * attempt)
    raise RuntimeError("GET %s failed after %d tries: %s" % (url, RETRIES, last))


def zenodo_files():
    """Return [(key, url, size, md5hex)] for the Zenodo record."""
    doc = json.loads(http_get(RECORD_API))
    files = doc.get("files", [])
    out = []
    for f in files:
        md5 = f.get("checksum", "")
        if md5.lower().startswith("md5:"):
            md5 = md5[4:]
        out.append((f["key"], f["links"]["self"], int(f["size"]), md5))
    return out


def md5_of(path):
    h = hashlib.md5()
    with open(path, "rb") as fh:
        for chunk in iter(lambda: fh.read(1 << 20), b""):
            h.update(chunk)
    return h.hexdigest()


def download(url, dest, md5hex):
    """Download with resume support; re-download once if checksum mismatches."""
    part = dest + ".part"
    for attempt in range(2):
        if os.path.exists(part) and attempt == 0:
            offset = os.path.getsize(part)
            headers = {"Range": "bytes=%d-" % offset}
            mode = "ab"
            print("    resuming from %d bytes" % offset)
        else:
            headers = {}
            mode = "wb"
        try:
            r = open_stream(url, headers=headers, timeout=60)
            if mode == "ab" and r.status != 206:
                # server ignored the Range request; restart from scratch
                mode = "wb"
            total = int(r.headers.get("Content-Range", "0/0").rpartition("/")[2]
                        or r.headers.get("Content-Length", "0"))
            done = os.path.getsize(part) if mode == "ab" else 0
            t0 = time.time()
            with open(part, mode) as fh:
                while True:
                    chunk = r.read(CHUNK)
                    if not chunk:
                        break
                    fh.write(chunk)
                    done += len(chunk)
                    if total and time.time() - t0 > 5:
                        print("    %d/%d MB (%.0f%%)" % (done >> 20, total >> 20, 100.0 * done / total))
                        t0 = time.time()
            r.close()
        except Exception as e:  # noqa: BLE001
            print("    network error (%s), will retry" % e)
            continue
        if md5_of(part) == md5hex:
            os.replace(part, dest)
            return
        print("    md5 mismatch, retrying from scratch")
        try:
            os.remove(part)
        except OSError:
            pass
    raise RuntimeError("download failed checksum: %s" % dest)


def main():
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument("--subjects", type=int, nargs="+", default=[1, 2, 3],
                    help="subject numbers to download (default: 1 2 3)")
    ap.add_argument("--list", action="store_true", help="list remote files and exit")
    ap.add_argument("--keep-zip", action="store_true",
                    help="keep the archives after unpacking")
    args = ap.parse_args()

    ip, via = resolve_ip("zenodo.org")
    print("zenodo.org -> %s (via %s)" % (ip, via))
    print("querying Zenodo record %s ..." % RECORD_ID)
    files = zenodo_files()
    if args.list:
        for key, _url, size, md5hex in files:
            print("%-10s %8.1f MB  md5:%s" % (key, size / 1048576.0, md5hex))
        return

    os.makedirs(OUT_DIR, exist_ok=True)
    wanted = {"s%d.zip" % n for n in args.subjects}
    by_key = {key: (url, size, md5hex) for key, url, size, md5hex in files}

    for key in sorted(wanted):
        if key not in by_key:
            print("%s: not in record, skipped" % key)
            continue
        url, size, md5hex = by_key[key]
        dest = os.path.join(OUT_DIR, key)
        subj = key[:-4]                        # "s3" from "s3.zip"
        subj_dir = os.path.join(OUT_DIR, subj)
        mats = ([f for f in os.listdir(subj_dir) if f.endswith(".mat")]
                if os.path.isdir(subj_dir) else [])
        if os.path.exists(dest) and md5_of(dest) == md5hex and mats:
            print("%s: already downloaded and unpacked" % key)
            continue
        print("%s: downloading (%.1f MB)" % (key, size / 1048576.0))
        download(url, dest, md5hex)
        print("    unpacking -> %s/" % subj_dir)
        os.makedirs(subj_dir, exist_ok=True)
        with zipfile.ZipFile(dest) as z:
            z.extractall(subj_dir)
        # the archive wraps everything in a nested s{n}/ folder; flatten it
        inner = os.path.join(subj_dir, subj)
        if os.path.isdir(inner):
            for name in os.listdir(inner):
                os.replace(os.path.join(inner, name), os.path.join(subj_dir, name))
            os.rmdir(inner)
        if not args.keep_zip:
            os.remove(dest)
        names = sorted(os.listdir(subj_dir))
        for n in names:
            print("    %s" % n)

    print("done. data root: %s" % OUT_DIR)
    print("next: preprocessing script converts these .mat files to the")
    print("data/README.md contract CSV (rest/open_hand/fist/wrist_flex/wrist_extend).")


if __name__ == "__main__":
    sys.exit(main())

