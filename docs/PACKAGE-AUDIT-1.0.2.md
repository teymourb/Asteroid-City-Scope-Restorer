# 1.0.2 candidate package audit — 2026-10-18

## Audited baseline

Public asset: https://github.com/teymourb/Asteroid-City-Scope-Restorer/releases/download/v1.0.1/Asteroid-City-Scope-Restorer_v1.0.1.7z

- Archive bytes: 114762853; SHA-256:
  `f1f925a6f14f9d569e9b9054776956938a0a61abf0779e61791fa478edd2828b`.
- 733 entries; 622 regular files totaling 462753829 bytes. No symlinks found.
- Root contains the batch script, README, MIT license, tools and public logo.
- Packaged batch text matches v1.0.1 after CRLF/LF normalization.
- Only the existing public release archive was accessed. No private media.
- Public logo was inventoried/hashed, not played or used in testing.

| Executable | Observed version (static inspection) | SHA-256 |
| --- | --- | --- |
| mkvmerge.exe | PE/README 78.0 | f707365fc6374db58c875d69fe8d3c3f572ab54369b28a863bc9aaad3ebc09ef |
| HandBrakeCLI.exe | embedded 1.6.1 (2023012300) | 3ba066c1b962f5bfe56edf54e11b74ccd729aa14133583d26cb37c7566e647ca |
| avidemux_cli.exe | PE 2.8.1.22260 | 7abf1a406ef27f82c121189939be21a8e15908877b4fb40ed37a0208a74828dd |
| ffmpeg.exe | embedded N-112110-g5acc3c4cff-20230917 | d28eec987cf8a2f25f3ce303ff612c35bf7ca541c3a5090de718caf525fb9a62 |

The official MKVToolNix 78.0 portable archive was downloaded independently and its
SHA-256 verified against the official sidecar:
`28aeb942e88b9bde8ad93b00020c9ab5289836bffd6df36582a6fd652cc7fdba`.
Its mkvmerge executable is byte-for-byte identical to the packaged executable.
The Windows workflow now tests both this exact executable hash and 102.0.
All four processing executables have the AMD64 PE machine type (64-bit Windows).
This establishes provenance for the relevant mkvmerge executable, not every
binary in the legacy package. Other executables were inspected statically on Mac;
no Windows executables were executed locally. Their full provenance, advisories,
code signatures and complete dependency source correspondence are not certified.

## Existing processing evidence

The final-remux source at main commit 055496b passes all six methods on Windows
Server 2022 with MKVToolNix 102.0 and FFmpeg/FFprobe 7.1.1. This includes 32
branch/status cases, three missing-tool/output cases, and both modes' synthetic
remuxes with identical video packet hashes and PCM audio bytes:
https://github.com/teymourb/Asteroid-City-Scope-Restorer/actions/runs/39127120978

The source batch has not changed during packaging. These tests bypass dialogs,
earlier processing and PAUSE. They do not establish full-film correctness.
The exact-78.0 workflow is prepared locally but has not run; automatic approval
review rejected uploading the packaging/CI source branch under the local-only
candidate boundary. Explicit upload/CI authorization is needed for that step.
No candidate archive, binaries or logo were uploaded.

## Candidate contents and build

Run from a clean source commit:

```
python3 tools/build_candidate.py /absolute/path/v1.0.1.7z /new/output/directory
```

The script uses the checksum-locked original archive, overlays the approved batch
script (Windows CRLF), current README/changelog/release notes, third-party notices
and missing FFmpeg/HandBrake GPL texts. Every retained tool file and the public
logo must remain byte-identical. It removes only these unused copied-installation
uninstall files; the restorer never invokes them:

- docs/programs/avidemux/Uninstall Avidemux VC++ 64bits.exe
- docs/programs/avidemux/Uninstall Avidemux VC++ 64bits.ini
- docs/programs/mkvtoolnix/uninst.exe

Distribution is a normal ZIP, so extraction does not require a 7z utility.
No runtime installation, encoder update or film-transform change is introduced.
The build adds no Git history, development tests, local development artifacts,
temporary processing data, private media or credentials. Original public component assets
remain, including the legacy commercial-source logo described below.

ZIP file ordering/timestamps/permissions are fixed. All ZIP CRCs and decompressed
payload hashes are verified after creation. The adjacent PACKAGE-MANIFEST.json
records the exact source commit, archive checksum, per-file inventory and delta.
SHA256SUMS.txt covers the candidate archive and manifest. The output directory
must be new and outside Git; historical assets are never modified.

## Publication gates

This is a review-only full candidate, not approved for release publication.

- Targeted Windows tests must pass with the exact legacy mkvmerge executable.
- FFmpeg and HandBrake lacked their own license texts in the old package. Added
  license files improve notices, but complete matching source/build/dependency
  provision still needs resolution. Upstream source submodules do not prove it.
- The included Focus Features logo comes from a commercial Blu-ray according to
  historical release notes. This audit found no separate redistribution grant.
  Preserve it locally for behavior review; decide how to handle it before public
  release. Do not silently remove it or substitute different film content.
- Existing batch startup/cleanup and earlier-stage failure handling remain legacy
  limitations. Full-film, synchronization, HDR and Windows desktop-dialog testing
  have not been performed. This patch is not a new whole-restoration qualification.

Recommendation: finish package evidence and keep the candidate local while
resolving the specific redistribution/source gaps. Owner publication approval is
necessary, but should not be treated as proof that those gaps are resolved.
