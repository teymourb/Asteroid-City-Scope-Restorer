# Published checkpoint — 2026-10-21

Version 1.0.2 is published with its complete ZIP and SHA256SUMS.txt:
https://github.com/teymourb/Asteroid-City-Scope-Restorer/releases/tag/v1.0.2

The cleanup/runtime revision passed 63 tests with zero skips in each fully
provisioned Windows MKVToolNix 78/102 job. Public ZIP downloads were independently
checked against local SHA256 values and all ZIP CRCs verified after publication.
Windows evidence: https://github.com/teymourb/Asteroid-City-Scope-Restorer/actions/runs/39525495135

CHANGELOG.md now describes shipped behavior. The following dated implementation
notes are historical; references to pending qualification/publication or earlier
retention policies do not describe the published version. Post-release record
corrections do not alter published tags, ZIPs, binaries or processing commands.

# Automatic workspace cleanup — 2026-10-21

Owner authorized silent discard on confirmed fresh start and after successful
processing, retaining small logs separately. Generated restoration media use
docs/temp; diagnostics use docs/logs/run-GUID. No automatic resume. Startup text
explains manual deletion only after closing the program. The workspace supervisor
must exclude concurrent runs and terminate only its own descendants before cleanup;
path containment/reparse guards protect originals, outputs and unrelated files.
Existing success checks remain operational, not decoded quality qualification.
Earlier retention-policy sections below are historical and superseded here.
Windows evidence for this revision is pending; do not ship preceding candidate ZIPs.
Owner confirmed logo distribution permission and deferred dependency provenance
improvements/tool upgrades; no binaries or media recipes change in this patch.

# Dialog readiness — 2026-10-20

Each native file/folder dialog waits for Enter after printing its instructions.
Q cancels before opening it. This includes re-opening a dialog after an invalid
selection. The pause is outside the dialog-error fallback catch, so cancellation
cannot be mistaken for an unavailable dialog. Manual mode and validation-only
entry points do not add pauses. Focused Windows readiness tests cover Enter, Q
and invalid-answer retry without opening GUI windows in CI.

# Console presentation and local packaging — 2026-10-20

The owner-approved ASCII layout groups setup, choices, paths, storage and results.
Wrapped path strings are display-only; selected values and processing arguments
are unchanged. The source-check heartbeat updates one bounded line on interactive
consoles and remains newline-delimited when redirected. Windows regression is
required for the current presentation revision; owner source matching and Q
cancellation were already demonstrated for the preceding fingerprint source.

Full-package builders preserve retained runtime bytes, use audited historical
archives, include the new helpers and official HandBrake notices, and verify ZIP
payload hashes/CRCs. Outputs are local review packages, not approved publication.
Corresponding-source/build records and Asteroid logo packaging remain separate
from source behavior qualification.

# Mandatory fingerprint implementation — 2026-10-20

The mandatory source-video fingerprint gate runs after workspace creation
and before video preparation. `docs/scripts/Test-SourceFingerprint.ps1` identifies
exactly one video track using MKVToolNix JSON, extracts that identified track, and
compares a film-specific compressed-stream SHA256. BvS uses bundled FFmpeg stream
copy with HEVC AUD/RPU NAL types 35/62 removed for the comparison only; Asteroid
uses the extracted AVC bytes. The source and restoration inputs are unchanged.
This does not decode frames, certify timing/HDR/output quality, or authorize
private-media access. Details/evidence are recorded in `docs/SOURCE-FINGERPRINT.md`.

The helper is a required runtime payload. Candidate builds must include it beside
Select-Restoration.ps1; developer qualification tools remain excluded. Final Windows
qualification and exact source identities are recorded in PR #12. Do not infer
RC readiness from historical passing runs below or from implementation alone.

# Current public/developer boundary — 2026-10-20

The owner requested removal of developer qualification from the public program.
The launcher now asks only for the required source, output folder, restoration
and confirmation. It never invokes frame comparison or asks for a check level.
Frame comparison and its manifests are developer tools under `tools/qualification`;
BvS storage and continuation helpers are also separate developer experiments.
They are excluded from the application payload. There is no public validation
report or skipped-test status. Processing exit/output/input safeguards remain.
Successful completion returns 0; actual MKVToolNix warnings retain their warning
status. Retaining temporary files alone is not a warning. All intermediates are
still retained: no cleanup or automatic resume has been introduced.

Cuts, requested frame counts, transformations, HandBrake settings, Avidemux
section order and tool versions remain unchanged. FFmpeg uses -nostdin and
Avidemux questions remain visible. This does not resolve codec/join uncertainty.
Windows evidence for this revision must be recorded before validated merge;
earlier results below qualify their historical source revisions only.

## Historical implementation/evidence record

The following dated sections describe prior work, including the now withdrawn
public validation-level design. They are retained as development history and
must not be read as the current application workflow or release instructions.

# Development status — 2026-10-19

## Current state

Asteroid City remains a Windows batch utility. Published v1.0.1 is unchanged;
v1.0.2 is the unreleased maintenance target. Final-remux protection, workspace
safety, processing safeguards and package-audit tooling are integrated. PR #6
adds independent assembly validation, merged after Windows qualification at
b8a2f1ae2c6cc69b4d81272c43997614d59cc2e8. Film cuts, framing, original media arguments, encoder settings
and successful output names remain unchanged.

- Startup enters the launcher directory, requires docs, refuses ANY existing
  docs/temp and checks workspace creation. Existing work and concurrent runs
  cannot share or overwrite the same workspace.
- All 57 preparation, splitting, encoding and assembly invocations have immediate
  status gates and require a nonempty regular output. MKVToolNix warnings stop
  separately; positive errors and negative native crashes stop downstream work.
  Both assembly branches precheck every load/append input, including the logo.
- Stage progress/diagnostics append to docs/temp/processing.log; final-remux
  diagnostics go to docs/temp/final-remux.log. Final-remux warnings/errors and
  missing/empty final outputs prevent successful completion.
- PR #6 introduced the assembled-video check; current RC runs it only when
  exhaustive checking is selected. Fixed ordered manifests
  match the actual Avidemux load/append arguments. Windows PowerShell 5.1 invokes
  the existing bundled FFmpeg to decode every input and the assembled output.
  Disk-backed SHA256 frame records and per-frame native pixel format/geometry
  must match in order and count. Process, parse and comparison failures stop
  processing and preserve evidence under docs/temp.
- This is a decoded-video assembly check, not a proof of intended film edits,
  timing, HDR metadata, audio/subtitle handling or full-film quality. It fully
  decodes inputs and output, adding substantial runtime that has not yet been
  measured on the actual films. No extra runtime binary is bundled.
- ALL intermediate videos and logs remain even after the final output is made.
  Completion returns review warning status 1. Automatic cleanup remains off;
  review the result before moving/removing the workspace. This increases disk
  use, and startup preserves the workspace until it is moved aside.
- Explicit exits restore the caller directory. Generic helpers match BvS;
  film-specific processing remains separate. There is no automatic resume.

## User interaction update — see PROJECT-STATUS.md for current evidence

- Shared PowerShell 5.1 setup replaces VBScript/mshta and ambiguous yes/no
  selection prompts. Source, destination, mode and final confirmation are
  validated before docs/temp is created. Dialog cancellation/failure offers
  manual entry or quit; existing outputs and workspaces are preserved.
- Unicode, spaces, ampersands, parentheses and brackets are supported by
  inherited environment transport; !, %, ^ and invalid/control characters
  are explicitly refused while the legacy batch body still uses expansion.
- Console stage messages explain quiet tool progress; failures direct users to
  preserved logs and discourage repeating expensive encoding prematurely.
- Exact processing-command digest remains unchanged. Native Windows tests add
  actual helper-to-child transport, both complete synthetic pipeline branches,
  cancellation, invalid confirmation and existing-output protection. No film
  processing or desktop dialog qualification is claimed by these fixtures.

## Authorization and workflow

The owner approved maintenance/refactoring, useful parallel work, source-only
branches/PRs, Windows CI and validated merges. Local commits/troubleshooting are
autonomous. Release assets/tags/publication, major architecture/dependency
changes and private-film access need separate approval. No release, binary or
logo has been uploaded by this work; synthetic fixtures only.

Develop on macOS; require actual Windows evidence for batch changes. Preserve
both histories and release lines. GitHub connector writes work as teymourb;
shell Git has no HTTPS credentials. Use connector writes and public fetch;
never paste/store tokens. Local snapshots remain on local/* branches.

## Validation evidence

Run `python3 -m unittest discover -s tests -v` locally (`python` on Windows).
Python/C# compilation are development-only requirements, not user installation.

- Current macOS result: seven source checks PASS; 22 Windows-only methods SKIP
  as intended (29 total). Source-command digests remain unchanged. Mac skips
  are not Windows qualification.
- PR #6 source head 6218892d408fb5c87d332a8ca6a28ac13981bbfd PASS on Windows
  Server 2022 with MKVToolNix 78.0 and 102.0: all 29 methods pass with no skips
  in each real-tool stage. Both job logs were verified before merging:
  https://github.com/teymourb/Asteroid-City-Scope-Restorer/actions/runs/39193313681.
- The earlier processing-safeguard head c988930 passed all 16 then-existing
  methods, with no skips, for MKVToolNix 78.0 and 102.0 before PR #4 merged:
  https://github.com/teymourb/Asteroid-City-Scope-Restorer/actions/runs/39157814277.
- CI downloads checksum-locked historical releases and extracts only tool
  folders for actual Avidemux 2.8.1 / bundled FFmpeg tests. It does not extract or
  use the film-derived logo. MKVToolNix 78.0's executable matches the old package:
  f707365fc6374db58c875d69fe8d3c3f572ab54369b28a863bc9aaad3ebc09ef.
- Native-stub tests exercise every processing gate: success, positive error,
  negative crash, partial/missing/empty/directory output, missing tools and
  missing assembly inputs. Downstream work must stop and original/predecessor
  sentinel bytes survive. Full production-mode control flow covers both source
  selection branches. Dialogs and PAUSE are bypassed; tools/logo are synthetic.
- Real assembly fixtures cover H.264 and 10-bit HEVC, B-frames/multiple GOPs,
  ordered-frame equality, omitted/repeated/reordered segments and Avidemux's
  silent append failure (observed exit 0 with a partial output, then rejected).
  Separate validator tests cover malformed decoder/hash
  evidence with a passing native-stub control, wrong pixel interpretation,
  corruption, special-character paths, 10-bit preservation and existing evidence.
- A later-GOP open-GOP HEVC seek/copy fixture contains missing reference pictures
  (POC 29/24), independently confirmed by a normal FFmpeg decode. The test must
  reject that genuinely damaged fixture; a closed-GOP seek/copy control must
  pass. This demonstrates a synthetic extraction hazard, not evidence that
  either actual film is affected. Production media arguments remain unchanged.
- Final-remux tests cover every source/destination/mode branch, warning/error/
  negative-crash statuses, missing tools/output and real synthetic remuxing with
  video packet hashes and PCM sample bytes preserved.
- Workspace tests cover unrelated caller cwd/sentinels, missing docs, temp as a
  file, repeated restart, concurrent launch and unknown nested leftovers.
  Actual ACL denial and disk-full fixtures are not included.
- Full films, intended restoration edits, HDR, real source timing/synchronization,
  Windows 10/11 desktop UI and general special-character media paths remain
  unqualified. No private media has been accessed.

## Avidemux status limitation

Avidemux 2.8.1's CLI append callback discards the append result; save failure is
not propagated, and normal CLI shutdown returns zero. A nonempty file plus exit
0 cannot justify deleting assembly inputs. The independent frame-sequence gate
addresses this narrow risk; broader qualification is still required before
restoring automatic cleanup.

- [Avidemux automation callbacks](https://raw.githubusercontent.com/mean00/avidemux2/2.8.1/avidemux/common/ADM_toolkit/automation.cpp)
- [Avidemux CLI shutdown](https://raw.githubusercontent.com/mean00/avidemux2/2.8.1/avidemux/cli/ADM_userInterfaces/ADM_dialog/DIA_none.cpp)
- [FFmpeg framehash](https://ffmpeg.org/ffmpeg-formats.html#framehash)
- [FFmpeg showinfo](https://ffmpeg.org/ffmpeg-filters.html#showinfo)

## Package and release state

See PACKAGE-AUDIT-1.0.2.md and THIRD-PARTY-NOTICES.md for old-package versions,
hashes and open redistribution/source-provision gaps. Resolve these and the
logo redistribution question before preparing a current public package.

The old local ZIP at ../release-candidates/asteroid-city/1.0.2/ is a stale review
snapshot from fdd245f, predating workspace and processing safeguards. It is
174202948 bytes, SHA256
083b2d8e99b78dadf0bb9b36ef64dbf7842a94d460daf1a874ec6113b416e227.
Two builds were identical; all 625 payloads verified and tools/logo retained
byte-for-byte. Its adjacent manifest/checksums/VERIFICATION.txt describe only
that snapshot. Do not publish it as current. Rebuild after qualification and
redistribution decisions, then obtain owner publication approval.

Local FFmpeg 8.0.1 has a missing x265 dylib; it was not repaired or used for
qualification. Windows CI uses isolated test tools; bundled production binaries
remain unchanged.

## Next checkpoints

The automated assembly checkpoint is complete. Start with one bounded owner-run
full-film qualification and measure validation overhead
before release; Windows access should be requested when real-media qualification
becomes the necessary next step. No interactive desktop is needed for current
headless CI. Private-media access still needs task-specific permission.

Resolve package provenance/source-provision and logo questions in parallel.
Simplify repeated input/remux branches using equivalent-command tests, then grow
shared planning/profile components from demonstrated needs. No engine language
or GUI stack is selected. Fingerprint research remains synthetic-first and does
not block these maintenance fixes. Publication stays separately approved.

## Maintenance RC interaction and validation policy (2026-10-20)

Setup now requires an explicit choice between basic checks and exhaustive decoded
frame comparison. Basic retains process-status, expected-output and input checks;
it does not establish assembly frame identity, codec compatibility, timestamps,
HDR, audio synchronization or playback. Its assembly-check.txt explicitly says
NOT RUN. Exhaustive records RUNNING, then PASS only after validator exit 0; a
failure or controlled cancellation records NOT PASSED and stops final remux.
Neither mode enables automatic cleanup. Both retain all intermediates and logs.

All production FFmpeg split invocations add only -nostdin, disabling accidental
keyboard commands. Cut positions, frame counts, stream-copy flags, HandBrake
settings, Avidemux load/append order and tool versions remain unchanged.
Avidemux runs attached to the console so codec questions and answers are visible.
No warning is automatically accepted. Its detailed stdout/stderr now appear only
in that console, not processing.log; the log retains the assembly stage marker
and subsequent validation status. Declining a question does not guarantee the
historical tool reports failure; basic checks cannot qualify a partial assembly.

Exhaustive validation prints the active file and ten-second elapsed heartbeats.
Press Q to cancel its decoding, parsing or comparison; it stops processing,
terminates only its own decoder child if active and preserves evidence. The
optional CancellationFile parameter requests the same cancellation for automation
and tests; it cannot bypass validation or establish a pass. Ctrl+C and forced
host termination cannot guarantee a completed status record; never infer PASS
from a RUNNING record. Actual interactive Windows keyboard behavior still needs
bounded desktop qualification; native cancellation-file tests cover the shared
stop/child-cleanup path using synthetic data.
