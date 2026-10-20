# Proposed release 1.0.2 — not published

This maintenance update clarifies source/output selection, restoration choices,
confirmation, processing stages and completion. Cancel a dialog to enter a path
manually or quit. No processing starts before confirmation. The required source
remains an unaltered Asteroid City Blu-ray video track; source identity is not
automatically verified.

The program stops on reported preparation, splitting, encoding, assembly or
packaging failures and missing/empty expected outputs. FFmpeg ignores accidental
keyboard commands. Avidemux questions and warnings are visible in the console
and require a deliberate answer. Continuing does not resolve a codec warning.
Developer frame comparisons and qualification experiments are separate tools,
not part of the application workflow or download payload.

Intermediate videos and logs are retained, including after successful output
creation. Disk use is substantially greater than the historical release; peak
use is not yet measured. After a failure, keep completed encodes and diagnostic
logs rather than restarting. Startup preserves existing docs/temp and existing
output. There is no automatic resume or cleanup.

Film cuts, framing, encoder settings, stream selection, processing tool versions
and successful output names remain unchanged. The unmasked manual-destination
remux now uses the correct AsteroidCity_S.mkv filename. Existing codec/join
compatibility limitations remain unresolved; no pristine-output claim is made.
Windows is the supported application target.

No new public package has been published. Full-package preparation still depends
on tool-source/provenance and logo redistribution decisions, followed by explicit
owner release approval. Historical processing binaries remain unchanged.
