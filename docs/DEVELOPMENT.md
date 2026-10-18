# Development and current status

## Accepted scope and workflow

The owner approved the Asteroid City final-remux repair on 2026-10-18, then
authorized branch publication, pull-request review, Windows testing and merging
validated changes into main. Public release publication still requires approval.
Develop on macOS; Windows remains the current application target. Keep both
existing repositories and release histories. Use a short-lived fix branch,
local tests and commits, then a reviewed pull request and Windows evidence.
`main` is stable integration; public tagged release packages are user downloads.
There is no separate production server or staging deployment for this utility.

Local edits, ordinary troubleshooting, tests, review, documentation, and commits
are authorized in this scope. Pushes, PR creation, CI tool downloads and merging
this validated fix are now authorized. Public tags/releases, substantial new
dependencies outside this test scope, and protected-media access need separate
approval. The GitHub connection alone is not publication approval. No private films or credentials belong in Git,
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
runs the production final-remux block with real mkvmerge, then compares FFprobe video-packet
SHA-256 hashes and concatenated PCM audio sample bytes with the synthetic source.
PCM packet boundaries may change during remuxing, so sample bytes are compared
without decoding or requiring identical packet sizes.
Set `RESTORER_REAL_MKVMERGE` to an absolute mkvmerge executable path to enable it
on Windows. It does not exercise film cuts, encoding stages, logos, HDR, chapters,
subtitles, full-film synchronization, or complete restoration quality.

The workflow uses Windows Server 2022, a pinned checkout action, no
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
- First Windows run: native batch matrix (32 cases) and three missing-tool/
  output cases PASS. Synthetic test exposed an invalid test assumption about
  PCM packet boundaries. The revised test compares video packet hashes and
  exact PCM sample bytes. The corrected rerun passes, confirming that sample
  bytes are preserved despite the original packet-hash comparison failure.
  Run: https://github.com/teymourb/Asteroid-City-Scope-Restorer/actions/runs/39126761694
- Windows Server 2022, Python 3.12.10, MKVToolNix 102.0, FFmpeg/FFprobe 7.1.1:
  all six test methods PASS with no skips in the real-tool stage. This includes
  32 branch/status combinations, three missing-tool/output cases, and synthetic
  remuxes in both modes with identical video packet hashes and PCM sample bytes.
  Passing run: https://github.com/teymourb/Asteroid-City-Scope-Restorer/actions/runs/39126930925
  Application source has not changed since this run; the final follow-up commit
  only records this evidence and release qualification limits.
- Full-film qualification: NOT RUN; no private media accessed.
- Historical archive audited; see PACKAGE-AUDIT-1.0.2.md for exact versions,
  hashes and observed provenance/redistribution gaps. Review-only ZIP preparation
  is authorized. Targeted exact-legacy-mkvmerge Windows tests are pending.
  Automatic approval review rejected uploading the packaging/CI source branch,
  interpreting the local-only candidate boundary to include those source files.
  No candidate archive/binaries were uploaded. Request explicit source-branch/CI
  upload approval before attempting that remote step again.

## Release gate and next steps

PR: https://github.com/teymourb/Asteroid-City-Scope-Restorer/pull/1

The GitHub plugin is authenticated as teymourb and successfully published the
branch and opened the PR. Both repositories report push/admin account permissions.
Shell Git has no HTTPS credentials; use the authenticated plugin for writes and
public Git fetch for local synchronization. Do not request or store tokens. The
initial local commit is preserved on local/final-remux-safety-initial; the plugin
created an equivalent remote commit with the identical source tree.

PR #1 is merged at 055496b. The owner subsequently approved auditing the old
download and preparing a local 1.0.2 candidate. Work is on
release/1.0.2-candidate. The prior branch/PR/CI workflow remains authorized;
public release publication remains unapproved. A hosted Server run does not establish Windows 10/11 desktop
behavior. Before release, complete exact-mkvmerge Windows evidence and resolve the
package audit gaps documented in PACKAGE-AUDIT-1.0.2.md. Preserve historical downloads. Prepare
an exact candidate package, checksums, and evidence for owner publication approval.
Until then, do not recommend public release.

Follow-up priority: safe startup/cleanup and consistent stage failure handling.
Portable planning/profile extraction can follow useful Windows maintenance fixes.

## Local candidate evidence — 2026-10-18

- Source commit: fdd245f0517c447771a21745520397b396a6a075.
- Built candidate lives outside Git at sibling path
  ../release-candidates/asteroid-city/1.0.2/.
- ZIP: Asteroid-City-Scope-Restorer_v1.0.2-candidate.zip, 174202948 bytes,
  SHA-256 083b2d8e99b78dadf0bb9b36ef64dbf7842a94d460daf1a874ec6113b416e227.
- Two independent builds produce identical ZIP, manifest and checksum bytes.
  All 625 archived files pass CRC and exact decompressed hash verification.
  Retained tool files and public logo are byte-identical to the old release.
  Windows CRLF verified; no test/temp/uninstaller payloads included.
- Wrong baseline and existing output directory are rejected without overwriting.
- Three local source tests still pass; Windows tests remain platform skips here.
- Packaging/CI source changes are committed only locally. Automatic approval
  review rejected their remote upload as conflicting with the local-only boundary.
  Ask for explicit packaging/CI source-branch upload permission; do not bypass it.
- Exact MKVToolNix 78.0 Windows tests, dependency corresponding-source provision,
  public logo redistribution and owner release approval remain open. Do not
  publish this review candidate or describe it as release-qualified.

## Follow-up authorization — 2026-10-18

The owner explicitly approved uploading only packaging/CI source changes and
opening a PR to run the exact-legacy-mkvmerge Windows checks. This resolves the
prior automatic-review restriction on that source upload. Candidate ZIP,
binaries, logo and private media remain excluded from upload. Publication of
release assets/tags remains unapproved. Existing permission to merge validated
source changes through the agreed PR workflow remains applicable.
