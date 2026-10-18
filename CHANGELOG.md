# Changelog

## 1.0.2 — unreleased candidate

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
resumable-job support. Earlier stages retain their legacy failure/cleanup behavior.

## 1.0.1 — 2024-07-10

Existing published version: manual source-input fallback added.
