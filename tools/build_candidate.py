#!/usr/bin/env python3
"""Deterministic local v2.0.0 package from the verified published v1.0.2 ZIP.

Standard library only; native Windows supported. No downloads, media execution,
Git configuration changes or publication. Committed clean source is mandatory.
"""
import argparse
import hashlib
import json
import os
from pathlib import Path
import re
import stat
import subprocess
import tempfile
import unicodedata
import zipfile

ROOT = Path(__file__).resolve().parents[1]
VERSION = '2.0.0'
BASELINE_VERSION = '1.0.2'
BASELINE_SHA256 = 'b1fcda55f524649cc96c4d1ee86ff9c4416687e7b29e054e47417041f2a57a02'
BASELINE_ROOT = 'Asteroid-City-Scope-Restorer_v' + BASELINE_VERSION
PACKAGE_ROOT = 'Asteroid-City-Scope-Restorer_v' + VERSION
ASSET_NAME = PACKAGE_ROOT + '.zip'
ZIP_DATE = (2026, 11, 9, 0, 0, 0)
MAX_ENTRIES = 5000
MAX_UNCOMPRESSED_BYTES = 1024 ** 3
OVERLAYS = {
    'Asteroid-City-Scope-Restorer.bat': 'Asteroid-City-Scope-Restorer.bat',
    'VERSION.txt': 'VERSION.txt',
    'README.md': 'README.md',
    'CHANGELOG.md': 'CHANGELOG.md',
    'RELEASE-NOTES.md': 'docs/RELEASE-2.0.0.md',
    'THIRD-PARTY-NOTICES.md': 'docs/THIRD-PARTY-NOTICES.md',
    'docs/scripts/Select-Restoration.ps1': 'docs/scripts/Select-Restoration.ps1',
    'docs/scripts/Manage-Workspace.ps1': 'docs/scripts/Manage-Workspace.ps1',
    'docs/scripts/Test-SourceFingerprint.ps1': 'docs/scripts/Test-SourceFingerprint.ps1',
    'docs/SOURCE-FINGERPRINT.md': 'docs/SOURCE-FINGERPRINT.md',
}


def sha(path):
    digest = hashlib.sha256()
    with Path(path).open('rb') as stream:
        for block in iter(lambda: stream.read(1024 * 1024), b''):
            digest.update(block)
    return digest.hexdigest()


def git(*args, text=False):
    return subprocess.check_output(
        ['git', '--git-dir=' + str(ROOT / '.git'), '--work-tree=' + str(ROOT), *args],
        cwd=ROOT, text=text, encoding='utf-8' if text else None)


def no_links(path):
    for part in (Path(path), *Path(path).parents):
        if part.is_symlink() or (hasattr(part, 'is_junction') and part.is_junction()):
            raise RuntimeError('linked path is not permitted: ' + str(part))
        if part.exists() and getattr(part.stat(follow_symlinks=False), 'st_file_attributes', 0) & 0x400:
            raise RuntimeError('reparse path is not permitted: ' + str(part))


def safe_archive_path(name, expected_root=BASELINE_ROOT):
    if (not name or chr(92) in name or name.startswith('/') or
            any(ord(c) < 32 or ord(c) == 127 for c in name)):
        raise RuntimeError('unsafe archive name: ' + repr(name))
    clean = name[:-1] if name.endswith('/') else name
    parts = clean.split('/')
    if parts[0] != expected_root:
        raise RuntimeError('unexpected archive root: ' + repr(name))
    for part in parts:
        stem = part.split('.', 1)[0].upper()
        if (part in ('', '.', '..') or part.endswith((' ', '.')) or
                re.search(r'[<>:"|?*]', part) or
                stem in {'CON', 'PRN', 'AUX', 'NUL', 'CONIN$', 'CONOUT$'} or
                re.fullmatch(r'(?:COM|LPT)[1-9\u00b9\u00b2\u00b3]', stem)):
            raise RuntimeError('unsafe Windows archive component: ' + repr(name))
    return clean


def preflight_zip(package, expected_root=BASELINE_ROOT):
    """Reject all unsafe metadata before extracting even one entry."""
    entries = package.infolist()
    if not entries or len(entries) > MAX_ENTRIES:
        raise RuntimeError('archive has an unsupported entry count')
    if sum(entry.file_size for entry in entries) > MAX_UNCOMPRESSED_BYTES:
        raise RuntimeError('uncompressed size exceeds bounded baseline budget')
    seen = {}
    for entry in entries:
        clean = safe_archive_path(entry.orig_filename, expected_root)
        if entry.orig_filename != entry.filename:
            raise RuntimeError('ambiguous archive name normalization')
        folded = unicodedata.normalize('NFC', clean).casefold()
        if folded in seen:
            raise RuntimeError('duplicate/case-colliding archive entry: ' + entry.filename)
        kind = stat.S_IFMT(entry.external_attr >> 16)
        if (kind not in (0, stat.S_IFREG, stat.S_IFDIR) or
                entry.external_attr & 0x400 or entry.flag_bits & 1 or
                entry.compress_type not in (zipfile.ZIP_STORED, zipfile.ZIP_DEFLATED)):
            raise RuntimeError('link, special, encrypted or unsupported entry: ' + entry.filename)
        directory = entry.is_dir()
        if clean == expected_root and not directory:
            raise RuntimeError('archive root must be a directory')
        if ((kind == stat.S_IFDIR and not directory) or
                (kind == stat.S_IFREG and directory) or (directory and entry.file_size)):
            raise RuntimeError('inconsistent archive entry type')
        ancestors = folded.split('/')[:-1]
        if any('/'.join(ancestors[:i]) in seen and not seen['/'.join(ancestors[:i])]
               for i in range(1, len(ancestors) + 1)):
            raise RuntimeError('archive file used as parent directory')
        if not directory and any(path.startswith(folded + '/') for path in seen):
            raise RuntimeError('archive file shadows existing directory')
        seen[folded] = directory
    return entries


def extract_verified(package, scratch, expected_root=BASELINE_ROOT):
    entries = preflight_zip(package, expected_root)
    for entry in entries:
        target = scratch.joinpath(*entry.filename.rstrip('/').split('/'))
        if entry.is_dir():
            target.mkdir(parents=True, exist_ok=True)
            continue
        target.parent.mkdir(parents=True, exist_ok=True)
        with package.open(entry) as source, target.open('xb') as destination:
            for block in iter(lambda: source.read(1024 * 1024), b''):
                destination.write(block)
        if target.stat().st_size != entry.file_size:
            raise RuntimeError('extracted size differs: ' + entry.filename)
    return scratch / expected_root


def inventory(root):
    result = {}
    for directory, subdirs, files in os.walk(root, followlinks=False):
        for name in [*subdirs, *files]:
            path = Path(directory) / name
            no_links(path)
            if not path.is_dir() and not stat.S_ISREG(path.stat().st_mode):
                raise RuntimeError('unsupported extracted filesystem entry')
        for name in files:
            path = Path(directory) / name
            result[path.relative_to(root).as_posix()] = {'bytes': path.stat().st_size, 'sha256': sha(path)}
    return dict(sorted(result.items()))


def overlay_bytes(commit):
    data = {destination: git('show', commit + ':' + source) for destination, source in OVERLAYS.items()}
    if data['VERSION.txt'].decode('ascii').strip() != VERSION:
        raise RuntimeError('committed VERSION.txt does not match package version')
    for destination in data:
        if destination.endswith(('.bat', '.ps1')):
            data[destination] = data[destination].replace(b'\r\n', b'\n').replace(b'\n', b'\r\n')
    return data


def verify_delta(before, after):
    changed = sorted(path for path in before.keys() & after.keys() if before[path] != after[path])
    added = sorted(after.keys() - before.keys())
    removed = sorted(before.keys() - after.keys())
    if not set(changed) <= OVERLAYS.keys() or not set(added) <= OVERLAYS.keys() or removed:
        raise RuntimeError('unexpected package delta')
    for path in before:
        if path.startswith(('docs/programs/', 'docs/logos/')) and before[path] != after.get(path):
            raise RuntimeError('retained runtime/support/logo changed: ' + path)
    return changed, added, removed


def write_zip(root, archive, contents):
    with zipfile.ZipFile(archive, 'x', compression=zipfile.ZIP_DEFLATED, compresslevel=9) as package:
        for relative in sorted(contents):
            entry = zipfile.ZipInfo(PACKAGE_ROOT + '/' + relative, date_time=ZIP_DATE)
            entry.compress_type = zipfile.ZIP_DEFLATED
            entry.create_system = 3
            entry.external_attr = 0o100644 << 16
            package.writestr(entry, (root / relative).read_bytes(), compress_type=zipfile.ZIP_DEFLATED, compresslevel=9)
    with zipfile.ZipFile(archive) as package:
        if package.testzip() is not None:
            raise RuntimeError('ZIP CRC verification failed')
        entries = preflight_zip(package, PACKAGE_ROOT)
        if len(entries) != len(contents):
            raise RuntimeError('ZIP payload count differs')
        for entry in entries:
            relative = entry.filename[len(PACKAGE_ROOT) + 1:]
            if hashlib.sha256(package.read(entry)).hexdigest() != contents[relative]['sha256']:
                raise RuntimeError('ZIP payload hash mismatch: ' + relative)


def build(baseline, output, expected_commit=None):
    baseline, output = Path(baseline).absolute(), Path(output).absolute()
    no_links(baseline)
    no_links(output)
    baseline, output = baseline.resolve(), output.resolve()
    if output == ROOT or ROOT in output.parents:
        raise RuntimeError('output must be outside the repository')
    if output.exists():
        raise RuntimeError('output already exists; use a new directory')
    if sha(baseline) != BASELINE_SHA256:
        raise RuntimeError('published v1.0.2 baseline checksum mismatch')
    if git('status', '--porcelain=v1', '--untracked-files=all'):
        raise RuntimeError('commit the source changes before packaging')
    commit = git('rev-parse', 'HEAD', text=True).strip()
    if expected_commit and commit != expected_commit:
        raise RuntimeError('source commit differs from selected revision')
    overlays = overlay_bytes(commit)
    with zipfile.ZipFile(baseline) as package, tempfile.TemporaryDirectory(prefix='asteroid-release-') as folder:
        root = extract_verified(package, Path(folder))
        before = inventory(root)
        for destination, data in overlays.items():
            target = root.joinpath(*destination.split('/'))
            target.parent.mkdir(parents=True, exist_ok=True)
            target.write_bytes(data)
        after = inventory(root)
        changed, added, removed = verify_delta(before, after)
        if git('rev-parse', 'HEAD', text=True).strip() != commit or git('status', '--porcelain=v1', '--untracked-files=all'):
            raise RuntimeError('source checkout changed while preparing package')
        output.mkdir(parents=True, exist_ok=False)
        archive = output / ASSET_NAME
        write_zip(root, archive, after)
        archive_hash = sha(archive)
        (output / 'SHA256SUMS.txt').write_text(archive_hash + '  ' + ASSET_NAME + '\n', encoding='ascii', newline='\n')
        manifest = {
            'status': 'ready for review only; owner publication approval required',
            'version': VERSION, 'proposed_tag': 'v' + VERSION, 'package_root': PACKAGE_ROOT,
            'source_commit': commit, 'baseline_version': BASELINE_VERSION,
            'baseline_archive_sha256': BASELINE_SHA256,
            'candidate_archive_name': ASSET_NAME, 'candidate_archive_sha256': archive_hash,
            'candidate_archive_bytes': archive.stat().st_size,
            'public_assets': [ASSET_NAME, 'SHA256SUMS.txt'],
            'public_checksums_sha256': sha(output / 'SHA256SUMS.txt'),
            'changed': changed, 'added': added, 'removed': removed,
            'original_files': before, 'candidate_files': after,
            'retained_tool_support_and_logo_bytes_unchanged': True,
            'limits': ['Packaging checks do not establish complete restoration or desktop/HDR qualification',
                       'No private film inspected; approved public logo retained without playback',
                       'Existing dependency source/build correspondence limits remain in notices'],
        }
        (output / 'PACKAGE-MANIFEST.json').write_text(json.dumps(manifest, indent=2, sort_keys=True) + '\n', encoding='utf-8')
        return manifest


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('baseline', type=Path, help='verified published v1.0.2 complete ZIP')
    parser.add_argument('output', type=Path, help='new directory outside repository')
    parser.add_argument('--expected-commit', help='require this exact committed source revision')
    args = parser.parse_args()
    manifest = build(args.baseline, args.output, args.expected_commit)
    print(json.dumps({key: manifest[key] for key in ('source_commit', 'candidate_archive_name',
                     'candidate_archive_sha256', 'candidate_archive_bytes', 'changed', 'added', 'removed')}, indent=2))


if __name__ == '__main__':
    main()
