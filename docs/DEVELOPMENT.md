# Development status — 2026-10-18

## Current state

Asteroid City remains a Windows batch utility. The original v1.0.1 download is
unchanged; v1.0.2 is an unreleased maintenance target. Final-remux protection and
package-audit tooling are merged (PRs #1/#2). PR #3 adds workspace safety and the
first matching helper routines used in both film launchers. No film-processing
arguments, cuts, framing, encoder settings or successful output names changed.

- Final-remux warnings/errors retain assembled video and diagnostics; absent or
  empty output is rejected before final cleanup.
- Startup enters the launcher directory, requires docs, refuses ANY existing
  docs/temp and checks mkdir before processing. This preserves recoverable work
  and prevents simultaneous runs from sharing a workspace.
- Success cleanup removes only the known final-remux log and uses nonrecursive
  rmdir. Unknown leftovers survive with a cleanup warning. Explicit exits restore
  the caller directory. There is no automatic resume yet.
- prepare_workspace and cleanup_workspace, plus generic workspace tests, are
  byte-identical to BvS. Film-specific media commands remain separate.

## Authorization and workflow

The owner approved these maintenance/refactoring tasks, useful parallel work,
source-only branches/PRs, Windows CI, and merging validated changes. Local commits
and routine troubleshooting are autonomous. Release assets/tags/publication,
major architecture/dependency changes, and private-film access need separate
approval. No release, binary or logo has been uploaded by this work.

Develop on macOS; validate batch behavior on actual Windows runners. Keep both
repository histories and release lines. Use small reviewed changes, then qualify
and prepare releases separately. GitHub connector writes work as teymourb; shell
Git has no HTTPS credentials. Use connector writes and public fetch; never paste
or store tokens. Local pre-upload snapshots remain on local/* branches.

## Validation evidence

Run `python3 -m unittest discover -s tests -v` locally (`python` on Windows).
Python/C# compilation are development-only requirements, not user installation.

- macOS: four source checks PASS; eight Windows-only methods SKIP as intended.
- Windows Server 2022: all 12 test methods PASS without skips in the real-tool
  stage, with MKVToolNix 78.0 and 102.0. Run:
  https://github.com/teymourb/Asteroid-City-Scope-Restorer/actions/runs/39156005808
- The 78.0 executable SHA-256 equals the historical bundled executable:
  f707365fc6374db58c875d69fe8d3c3f572ab54369b28a863bc9aaad3ebc09ef.
- Tests cover 32 remux branch/status cases, missing tools/output, both synthetic
  remux modes (video packet hashes + PCM bytes preserved), unrelated caller cwd
  and sentinel files, missing docs, temp as file, repeated restart with retained
  work, concurrent launch, unknown nested leftovers, and warning/error exits.
- The first workspace run caught an inner environment scope restoring cwd too
  early. The correction is protected by actual processing-cwd and untouched-
  caller-directory assertions. Diagnostic ampersand quoting was also corrected.
- Test helpers execute production startup/remux/helper/exit sections; dialogs,
  earlier media processing and PAUSE are bypassed. Full-film output, HDR, real
  source timing, Windows 10/11 desktop UI and general special-character media
  paths have NOT been qualified. An actual ACL/disk-full fixture is not included.
- Source command digests remain unchanged; diff checks pass. No private media used.

## Package and release state

See PACKAGE-AUDIT-1.0.2.md and THIRD-PARTY-NOTICES.md for the audited old download,
versions, hashes and open redistribution/source-provision gaps.

The old local ZIP at sibling ../release-candidates/asteroid-city/1.0.2/ is a
review snapshot from fdd245f and DOES NOT contain the new workspace-safety fix.
It is 174202948 bytes, SHA-256
083b2d8e99b78dadf0bb9b36ef64dbf7842a94d460daf1a874ec6113b416e227.
Two builds were byte-identical, all 625 payloads verified, and tools/logo retained
byte-for-byte. Adjacent manifest/checksums/VERIFICATION.txt describe that snapshot.
Do not publish it as the current release. Rebuild after source/qualification and
redistribution decisions are settled, then obtain owner publication approval.

The existing local FFmpeg 8.0.1 has a missing x265 dylib; it was not repaired or
used for qualification. Windows uses isolated, versioned test tools. This does
not change the processing binaries bundled for users.

## Next engineering work

Add stage-level failure handling for source preparation, extraction, encoding and
assembly before deleting their inputs. Then simplify repeated input/remux branch
logic with equivalent command tests. Grow portable planning/profile components
from demonstrated shared needs; no new engine language or GUI stack is selected.
Source-fingerprint research is a separate synthetic-first task and does not block
these maintenance fixes. Real-media qualification requires explicit authorization.
