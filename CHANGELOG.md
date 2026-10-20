## Console presentation — unreleased

Group setup and results with ASCII headings and spacing. Wrap long displayed
paths without changing their values. Show one shared free-space figure for a
shared drive. Source-check elapsed progress updates in place on an interactive
console; redirected logs remain ordinary lines. Processing recipes are unchanged.

## Mandatory source recognition — unreleased

Check the supported compressed video before restoration starts. BvS recognizes
its confirmed HDR10 base stream with or without the tested added Profile 8.1 RPU;
Asteroid checks its original AVC extraction. Wrong sources and failed checks stop
with diagnostics. No video encoding or decoding is performed by this check.
Only its own temporary extraction is removed. Film-processing recipes are unchanged.

# Changelog

## 1.0.2 — unreleased candidate

- Replace legacy VBScript/mshta selection and ambiguous yes/no prompts with a
  shared PowerShell setup: validated source/output paths, explicit dialog
  cancellation/failure fallback, mode selection, final confirmation and quit.
  Setup completes before temporary work is created. Unsupported CMD path
  characters are rejected explicitly. Show stage activity and actionable errors.

- Rewrite setup, processing and completion messages using the original source
  requirements and restoration descriptions; remove developer qualification
  choices and frame-comparison reports from the released workflow.
- Keep frame comparison, fixtures and qualification helpers in developer tools,
  separate from the application and its public package.
- Disable accidental FFmpeg keyboard input and show Avidemux questions and
  diagnostics directly in the console. Warnings are not automatically accepted.
- Stop failed preparation/splitting/encoding/assembly, record stage diagnostics
  and reject missing/empty outputs before dependent work. Catch native crashes.
- Preserve intermediates and logs after completion or failure. Retention alone
  does not turn successful completion into a warning; actual tool warnings and
  errors remain separate. Allow additional disk space for retained files.

- Anchor execution to the launcher folder and refuse an existing temporary
  workspace instead of deleting retained work on restart.
- Remove wildcard cleanup; preserve unexpected temporary files/subdirectories
  and restore the caller directory on success, warnings and errors.

- Fix unmasked restoration's final remux when the destination is entered manually:
  use `AsteroidCity_S.mkv`, rather than the nonexistent `.mkv.mkv` filename.
- In both modes, stop before cleanup on final-remux errors, and retain the
  assembled video and `docs/temp/final-remux.log`.
- Distinguish MKVToolNix warnings from errors. Warnings also retain the
  intermediate and request output review instead of displaying “Done!”.
- Reject a missing or empty destination output after a nominally successful remux.
- Add focused regression tests and a proposed Windows Actions workflow.

Cuts, encoder arguments, transforms, stream-selection arguments, and successful
output filenames are unchanged. This is not comprehensive output validation or
resumable-job support. All processing stages have status/output gates and preserve work on failure.

## 1.0.1 — 2024-07-10

Existing published version: manual source-input fallback added.
