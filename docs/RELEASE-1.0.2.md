# Asteroid-City-Scope-Restorer v1.0.2 — release notes

This maintenance update makes the existing restoration easier to start and
troubleshoot while preserving its film-specific processing recipe.

- A source-video fingerprint check requires the supported original Blu-ray video before restoration starts. Audio and subtitle selections may vary.
- Clearer source and destination dialogs, with time to read the instructions before opening them, plus manual path entry and cancellation.
- More descriptive restoration choices, a grouped confirmation screen, and clearer progress, completion and error messages.
- Processing stops on reported failures or missing/empty expected files. Existing destination outputs are protected.
- Generated working videos are removed automatically after success and when a fresh run is confirmed. Small diagnostic records remain separately in `docs/logs`.
- FFmpeg ignores accidental keyboard commands; assembly questions are visible in the program window.

Split points, requested frame counts, crop/scale/pad settings, encoding settings
and assembly order remain unchanged. Processing tool versions are unchanged.
This update does not redesign encoding or joining.

## Download and use

Download the complete application ZIP, which includes the launcher, required
helpers and processing tools with their support files. The film is not included.
Extract the entire ZIP to its own folder, keep the source MKV outside that folder,
and double-click the launcher BAT. Your original source is unchanged.

Allow room for temporary source-video extraction, restoration working videos
and the final MKV. After an interruption, close the program before deleting
`docs/temp` or retaining it for troubleshooting. Never alter it during processing.
A fresh run begins from the start; automatic resume is not available.
