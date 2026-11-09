# Asteroid-City-Scope-Restorer v2.0.0

Asteroid City Scope Restorer now provides one restoration: **Theatrical Scope
(unmasked)**. The separate masked output has been retired to simplify the program
and avoid its additional cropping/re-encoding path.

## What changes

- Choose the source MKV and destination folder, review the fixed restoration and
  storage information, and confirm. There is no numbered restoration-mode menu.
- The sole output remains **`Asteroid City Theatrical Scope Restoration (unmasked).mkv`**.
- Correct a Windows working-file check that could mistake valid nonempty files
  for directories. Missing, empty or directory outputs still stop processing.
- Refresh the instructions while retaining credits, artwork and the source/unmasked
  comparisons. Remove the retired masked comparison image and description.

Removing a supported output option is the reason for the major version number.
If you specifically need the old native 1920 x 804 masked container, use
[v1.0.2](https://github.com/teymourb/Asteroid-City-Scope-Restorer/releases/tag/v1.0.2).

## What stays the same

The unmasked restoration uses a **1920 x 1080 container** with constant-height
Scope presentation. Its original compressed Scope sections are retained; the
Black and White sequences retain the existing scaling and windowboxing. Split
points, requested frame counts, crop/scale/pad values, encoding settings,
assembly order, source fingerprint and processing-tool versions are unchanged.

The strict supported-video check remains mandatory. Audio and subtitle selections
may differ in the source MKV, but the supported AVC video must match. Your original
file is unchanged and existing destination outputs are protected. Dialog/manual
fallback, cancellation before processing, stage safeguards and separately retained
diagnostic logs remain.

Generated working media use `docs/temp`. They are removed after successful
completion and when a fresh run is confirmed; small records remain in `docs/logs`.
After interruption, close the program before changing temporary files. A fresh
run starts over: **automatic resume is not available**.

This is a focused simplification of the existing Windows program. It does not
ship the shared-engine prototype, a GUI, new codecs, Dolby Vision functionality,
or a redesign of joining. Synthetic regression checks do not establish complete
film playback, frame accuracy at every cut, synchronization or image quality.

## Download and run

Download the complete application ZIP and `SHA256SUMS.txt` from this release.
GitHub's generated Source code archives are not complete runnable installations.
Extract the whole application to a fresh folder, keep the source outside that
folder, and double-click `Asteroid-City-Scope-Restorer.bat`. Required processing
programs and support files remain included; no developer runtime or account is
needed to run the complete application. The film itself is not included.
