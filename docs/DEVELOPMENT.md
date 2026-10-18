# Development and current status

## Accepted scope and workflow

The owner approved a local Asteroid City final-remux repair on 2026-10-18.
Develop on macOS; Windows remains the current application target. Keep both
existing repositories and release histories. Use a short-lived fix branch,
local tests and commits, then a reviewed pull request and Windows evidence.
`main` is stable integration; public tagged release packages are user downloads.
There is no separate production server or staging deployment for this utility.

Local edits, ordinary troubleshooting, tests, review, documentation, and commits
are authorized in this scope. Ask before pushes, merges, public tags/releases,
substantial new dependencies, or protected-media access. The GitHub connection
alone is not publication approval. No private films or credentials belong in Git,
CI, logs, or test artifacts. Do not execute the full legacy script on macOS.

## Current work

- Branch: `fix/final-remux-safety`, based on published `v1.0.1` (`f1d467d`).
- Target: `1.0.2`, not tagged or released.
- Correct two unmasked/manual-destination input paths; protect both modes' final
  remux with status checks, diagnostic capture, and output-presence/size checks.
- MKVToolNix status 0 means success; 1 means warnings requiring review; 2 means
  error. Missing tools and other positive error statuses also stop cleanup.
  Reference: https://mkvtoolnix.download/doc/mkvmerge.html#mkvmerge.exit_codes
- Warning/error exits retain `docs/temp/AsteroidCity_S.mkv` and the log. Startup
  still clears that workspace: copy retained work elsewhere before restarting.
- Earlier processing, cleanup safety, source identity, existing-output protection,
  special-character path support, and authoritative output validation remain
  separate work. Do not describe this patch as solving those problems.

## Tests

Run `python3 -m unittest discover -s tests -v` on macOS, or
`python -m unittest discover -s tests -v` on Windows. Python is a development-only
requirement; users still launch the batch file.

Three source regression tests run on any OS. They protect the v1.0.1 processing
command baseline (normalizing only the approved filename fix/log redirection),
check all eight final-remux command branches, and check the terminal handlers.

Windows tests extract the actual two final-remux blocks and terminal handlers
into disposable harnesses. They bypass dialogs, previous processing and PAUSE;
therefore they do not validate the full batch script or desktop dialogs. A native
C# executable stub, compiled using Windows' .NET Framework compiler, tests both
modes, both source-entry branches, both destination-entry branches, and success,
warning, error, missing-executable, and empty/missing-output behavior. Paths
contain spaces. Tests verify original-source sentinel bytes remain unchanged.
All test workspaces are isolated temporary directories.

The real synthetic test uses FFmpeg to generate one second of blue video/tone,
runs the production final-remux block with real mkvmerge, then uses FFprobe packet
SHA-256 hashes to compare both video and audio with the synthetic source.
Set `RESTORER_REAL_MKVMERGE` to an absolute mkvmerge executable path to enable it
on Windows. It does not exercise film cuts, encoding stages, logos, HDR, chapters,
subtitles, full-film synchronization, or complete restoration quality.

The proposed workflow uses Windows Server 2022, a pinned checkout action, no
submodules, sparse checkout excluding the commercial logo, read-only repository
permissions, no persisted checkout credentials, and a 15-minute timeout. It
runs native stubs before downloading test-only MKVToolNix 102.0 from its official
site (pinned SHA-256) and FFmpeg 7.1.1 via Chocolatey (Gyan binary package).
These test versions do not update the application's distributed dependencies.
Workflow triggers are pull requests and manual dispatch, with no publishing job.
Only approved code/tests and synthetic data are used; logs remain on GitHub.

## Validation evidence — 2026-10-18

- macOS ARM64, system Python 3.9.6: three source tests PASS; three Windows test
  methods SKIPPED as intended. This is static evidence only.
- `git diff --check`: PASS at local review.
- Regression sensitivity: the final-remux branch check rejects unpatched v1.0.1
  as expected (missing guards), then passes on the patched source.
- Existing local mkvmerge 96.0 launches. Existing FFmpeg 8.0.1 fails to launch
  because its x265 dylib is missing. No system dependencies were modified.
- Windows matrix and real synthetic remux: NOT RUN. Proposed workflow has not
  been executed or validated on a runner.
- Full-film qualification: NOT RUN; no private media accessed.
- Release archives and bundled tool versions: NOT audited or repackaged.

## Release gate and next steps

Review the local diff, approve a branch push/PR and CI tool downloads, then obtain
Windows results. A hosted Server run does not establish Windows 10/11 desktop
behavior. Before release, audit the existing downloadable package and qualify the
patch against its actual mkvmerge binary. Preserve historical downloads. Prepare
an exact candidate package, checksums, and evidence for owner publication approval.
Until then, do not recommend public release.

Follow-up priority: safe startup/cleanup and consistent stage failure handling.
Portable planning/profile extraction can follow useful Windows maintenance fixes.
