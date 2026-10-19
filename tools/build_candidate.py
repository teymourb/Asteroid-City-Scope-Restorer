#!/usr/bin/env python3
"""Build a local review-only ZIP from the audited historical archive.

No downloads, media execution, dependency updates or GitHub publication occur.
Requires macOS bsdtar (libarchive); uses Python's standard library for ZIP output.
"""
import argparse
import hashlib
import json
from pathlib import Path
import shutil
import subprocess
import tempfile
import zipfile

ROOT = Path(__file__).resolve().parents[1]
BASELINE_SHA256 = 'f1f925a6f14f9d569e9b9054776956938a0a61abf0779e61791fa478edd2828b'
BASELINE_ROOT = 'Asteroid-City-Scope-Restorer_v1.0.1'
PACKAGE_ROOT = 'Asteroid-City-Scope-Restorer_v1.0.2'
OMIT = {
    'docs/programs/avidemux/Uninstall Avidemux VC++ 64bits.exe',
    'docs/programs/avidemux/Uninstall Avidemux VC++ 64bits.ini',
    'docs/programs/mkvtoolnix/uninst.exe',
}
OVERLAYS = {
    'Asteroid-City-Scope-Restorer.bat': 'Asteroid-City-Scope-Restorer.bat',
    'README.md': 'README.md',
    'CHANGELOG.md': 'CHANGELOG.md',
    'RELEASE-NOTES.md': 'docs/RELEASE-1.0.2.md',
    'THIRD-PARTY-NOTICES.md': 'docs/THIRD-PARTY-NOTICES.md',
    'PACKAGE-AUDIT-1.0.2.md': 'docs/PACKAGE-AUDIT-1.0.2.md',
    'docs/licenses/HandBrake-GPL-2.0.txt': 'docs/licenses/HandBrake-GPL-2.0.txt',
    'docs/licenses/FFmpeg-GPL-3.0.txt': 'docs/licenses/FFmpeg-GPL-3.0.txt',
    'docs/scripts/Validate-Assembly.ps1': 'docs/scripts/Validate-Assembly.ps1',
    'docs/scripts/assembly-inputs-unmasked.txt': 'docs/scripts/assembly-inputs-unmasked.txt',
    'docs/scripts/assembly-inputs-masked.txt': 'docs/scripts/assembly-inputs-masked.txt',
}


def sha(path):
    h = hashlib.sha256()
    with path.open('rb') as stream:
        for block in iter(lambda: stream.read(1024 * 1024), b''):
            h.update(block)
    return h.hexdigest()


def inventory(root):
    return {p.relative_to(root).as_posix(): {'bytes': p.stat().st_size, 'sha256': sha(p)}
            for p in sorted(root.rglob('*')) if p.is_file()}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('baseline', type=Path)
    parser.add_argument('output', type=Path, help='new directory outside the repository')
    args = parser.parse_args()
    baseline, output = args.baseline.resolve(), args.output.resolve()
    if output == ROOT or ROOT in output.parents:
        parser.error('output must be outside the repository')
    if output.exists():
        parser.error('output already exists; use a new directory')
    if sha(baseline) != BASELINE_SHA256:
        parser.error('historical archive checksum mismatch')
    if subprocess.check_output(['git', 'status', '--porcelain', '--untracked-files=all'], cwd=ROOT):
        parser.error('commit the source changes before packaging')
    commit = subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=ROOT, text=True).strip()
    tar = shutil.which('bsdtar')
    if not tar:
        parser.error('bsdtar is required; no tool will be installed automatically')
    with tempfile.TemporaryDirectory(prefix='asteroid-candidate-') as folder:
        scratch = Path(folder)
        subprocess.run([tar, '-xf', str(baseline), '-C', str(scratch),
                        '--no-same-owner', '--no-same-permissions'], check=True)
        root = scratch / BASELINE_ROOT
        if any(p.is_symlink() for p in scratch.rglob('*')):
            raise RuntimeError('archive contains a symlink')
        before = inventory(root)
        original = subprocess.check_output(['git', 'show', 'v1.0.1:Asteroid-City-Scope-Restorer.bat'], cwd=ROOT)
        if (root / 'Asteroid-City-Scope-Restorer.bat').read_bytes().replace(b'\r\n', b'\n') != original.replace(b'\r\n', b'\n'):
            raise RuntimeError('historical batch differs from tagged source')
        for rel in OMIT:
            (root / rel).unlink()
        for dest, src in OVERLAYS.items():
            data = (ROOT / src).read_bytes()
            if dest.endswith('.bat'):
                data = data.replace(b'\r\n', b'\n').replace(b'\n', b'\r\n')
            target = root / dest
            target.parent.mkdir(parents=True, exist_ok=True)
            target.write_bytes(data)
        after = inventory(root)
        changed = sorted(p for p in before.keys() & after.keys() if before[p] != after[p])
        added = sorted(after.keys() - before.keys())
        removed = sorted(before.keys() - after.keys())
        if changed != ['Asteroid-City-Scope-Restorer.bat', 'README.md'] or set(removed) != OMIT:
            raise RuntimeError('unexpected package delta')
        for rel in before:
            if rel.startswith('docs/programs/') and rel not in OMIT:
                if before[rel] != after[rel]:
                    raise RuntimeError('bundled tool changed: ' + rel)
        output.mkdir(parents=True)
        archive = output / 'Asteroid-City-Scope-Restorer_v1.0.2-candidate.zip'
        with zipfile.ZipFile(archive, 'w', compression=zipfile.ZIP_DEFLATED, compresslevel=9) as z:
            for rel in sorted(after):
                info = zipfile.ZipInfo(PACKAGE_ROOT + '/' + rel, date_time=(2026, 10, 18, 0, 0, 0))
                info.compress_type = zipfile.ZIP_DEFLATED
                info.create_system = 3
                info.external_attr = 0o100644 << 16
                z.writestr(info, (root / rel).read_bytes(), compress_type=zipfile.ZIP_DEFLATED, compresslevel=9)
        # Reopen every entry, checking CRC and exact decompressed file SHA-256.
        with zipfile.ZipFile(archive) as z:
            if z.testzip() is not None:
                raise RuntimeError('ZIP CRC verification failed')
            for entry in z.infolist():
                rel = entry.filename[len(PACKAGE_ROOT) + 1:]
                if hashlib.sha256(z.read(entry)).hexdigest() != after[rel]['sha256']:
                    raise RuntimeError('ZIP payload verification failed')
        manifest = {
            'status': 'review-only; publication gates remain open',
            'source_commit': commit,
            'baseline_archive_sha256': BASELINE_SHA256,
            'candidate_archive_sha256': sha(archive),
            'candidate_archive_bytes': archive.stat().st_size,
            'changed': changed, 'added': added, 'removed': removed,
            'original_files': before, 'candidate_files': after,
            'limits': ['No full-film processing or Windows desktop UI qualification',
                       'License/source correspondence and public logo redistribution remain unresolved',
                       'ZIP structural verification does not establish complete restoration correctness'],
        }
        manifest_path = output / 'PACKAGE-MANIFEST.json'
        manifest_path.write_text(json.dumps(manifest, indent=2, sort_keys=True) + '\n')
        checksum = output / 'SHA256SUMS.txt'
        checksum.write_text(''.join(sha(p) + '  ' + p.name + '\n' for p in (archive, manifest_path)))
        print(json.dumps({k: manifest[k] for k in ('source_commit', 'candidate_archive_sha256',
              'candidate_archive_bytes', 'changed', 'added', 'removed')}, indent=2))
        print('Candidate:', archive)


if __name__ == '__main__':
    main()
