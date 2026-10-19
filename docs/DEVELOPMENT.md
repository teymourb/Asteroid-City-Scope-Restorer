# Development status — 2026-10-18

## Current state

Asteroid City remains a Windows batch utility. Published v1.0.1 is unchanged;
v1.0.2 is the unreleased maintenance target. Final-remux protection, workspace
safety and package-audit tooling are integrated. Processing safeguards merged in
PR #4 at 1da68de5. They add the following behavior without changing film cuts, framing, media arguments,
encoder settings or successful output names:

- Startup enters the launcher directory, requires docs, refuses ANY existing
  docs/temp and checks workspace creation. Existing work and concurrent runs
  cannot share or overwrite the same workspace.
- All 57 preparation, splitting, encoding and assembly invocations have immediate
  process-status gates and require a nonempty regular output. MKVToolNix warnings
  stop separately; positive errors and negative native crashes stop downstream
  work. Both assembly branches precheck every load/append input, including the
  external logo. These are minimum structural checks, not completeness proof.
- Stage progress and diagnostics append to docs/temp/processing.log; final-remux
  diagnostics go to docs/temp/final-remux.log. Final-remux warning/error or absent
  or empty final output prevents successful completion.
- Avidemux 2.8.1 does not reliably propagate append/save failures into its process
  status. Therefore ALL intermediate videos and logs remain after output creation
  too. The launcher asks for completeness review and returns warning status 1.
  This intentionally increases disk use. Review the output before moving or
  manually removing the workspace. Startup preserves it until it is moved aside.
- Explicit exits restore the caller directory. Generic workspace/output helpers
  match BvS; film-specific processing remains separate. There is no automatic
  resume or independently qualified assembly-completeness check.

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

- macOS: five source checks PASS; eleven Windows-only methods SKIP as intended.
  Source-command digests remain unchanged and diff checks pass.
- Validated processing-safeguard source head: c988930. Windows Server 2022 CI:
  https://github.com/teymourb/Asteroid-City-Scope-Restorer/actions/runs/39157814277.
  Both MKVToolNix 78.0 and 102.0 jobs PASS, with all 16 methods passing and no
  skips in each real-tool stage. Job logs were checked before merging.
- The 78.0 executable SHA-256 equals the historical bundled executable:
  f707365fc6374db58c875d69fe8d3c3f572ab54369b28a863bc9aaad3ebc09ef.
- Native-stub tests exercise every processing command with success, positive
  error, negative crash plus partial output, missing/empty/directory output,
  missing tools and missing assembly inputs. They require downstream work to
  stop and original/predecessor sentinel bytes to survive. Complete production
  mode control flow is also exercised for both source-selection branches, with
  success/retained-work and failure cases. Dialogs and PAUSE are bypassed; tools
  and the logo are synthetic fixtures.
- Final-remux tests cover all source/destination/mode branches, warning/error and
  negative-crash statuses, missing tools/output, plus both actual synthetic remux
  modes with video packet hashes and PCM sample bytes preserved.
- Workspace tests cover unrelated caller cwd and sentinels, missing docs, temp as
  file, repeated restart with retained work, concurrent launch and unknown nested
  leftovers. Tests protect against prior cwd/environment-scope and diagnostic
  ampersand bugs. An actual ACL-denial/disk-full fixture is not included.
- Initial stage CI exposed an absolute test-harness launch path being parsed by
  cmd.exe at spaces/special characters. The fixture now launches stage.cmd
  relative to its working directory; the current run verifies that correction.
- Stub success does not prove real extraction/encoding/assembly correctness.
  Full-film output, assembly completeness, HDR, real source timing, Windows
  10/11 desktop UI and general special-character media paths remain unqualified.
  No private media has been accessed.

## Avidemux status limitation

Avidemux 2.8.1 source inspection found that its CLI append callback discards the
append result, save callback does not propagate failure, and normal CLI shutdown
returns zero. A nonempty file and exit 0 therefore cannot justify deleting
assembly inputs. Independent completeness qualification is required before
restoring automatic cleanup.

- [Avidemux 2.8.1 automation callbacks](https://raw.githubusercontent.com/mean00/avidemux2/2.8.1/avidemux/common/ADM_toolkit/automation.cpp)
- [Avidemux 2.8.1 CLI UI_RunApp](https://raw.githubusercontent.com/mean00/avidemux2/2.8.1/avidemux/cli/ADM_userInterfaces/ADM_dialog/DIA_none.cpp)

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

Add an independent assembly-completeness check before considering automatic
cleanup. Complete owner-run full-film qualification before release. Simplify
repeated input/remux branches with equivalent command tests. Grow portable
planning/profile components from demonstrated shared needs; no engine language
or GUI stack is selected. Source-fingerprint research remains a separate,
synthetic-first task and does not block maintenance fixes. Real-media
qualification requires explicit authorization. Resolve package redistribution
and source-provision questions before preparing a current release candidate;
publication remains separately approved.

## Assembly-check branch — Windows evidence pending

Adds docs/scripts/Validate-Assembly.ps1 and fixed ordered manifests derived from
the actual Avidemux arguments. Before final remux it independently decodes all
inputs and assembled output with bundled FFmpeg, comparing SHA256 rawvideo frame
records and native per-frame pixel format/geometry. Status/parse/decode/mismatch
failures preserve all work; evidence is disk-backed under docs/temp. No original
media commands change, no new runtime is bundled, and automatic cleanup stays off.
Full decoding adds substantial unmeasured runtime. Timing, HDR metadata, audio,
intended source edits and full-film quality are outside this pixel-sequence gate.

New tests include actual historical Avidemux/FFmpeg synthetic H.264 and HEVC10
assemblies, wrong sequences and failed append; multiple-GOP/B-frame clips;
malformed decoder evidence, corruption, paths, 10-bit and existing evidence.
CI downloads checksum-locked historical archives and extracts only tool folders.
No film-derived logo or protected media is used. Local checks pass; current-head
Windows evidence is required before merge.
