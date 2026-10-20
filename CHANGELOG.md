# Changelog

## 1.0.2 — unreleased candidate

- Replace legacy VBScript/mshta selection and ambiguous yes/no prompts with a
  shared PowerShell setup: validated source/output paths, explicit dialog
  cancellation/failure fallback, mode selection, final confirmation and quit.
  Setup completes before temporary work is created. Unsupported CMD path
  characters are rejected explicitly. Show stage activity and actionable errors.

- Offer an explicit routine/exhaustive check choice. Exhaustive checks compare
  decoded frames, native format and geometry before final remux and can take
  many hours; routine records NOT RUN. Neither proves timing, HDR, source
  identity, intended edits or universal playback. Retain all work and reports.
- Disable accidental FFmpeg keyboard commands. Show Avidemux questions directly
  in the console; never automatically accept codec warnings. Show decoder
  validation elapsed time and allow controlled cancellation during decoding.

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
