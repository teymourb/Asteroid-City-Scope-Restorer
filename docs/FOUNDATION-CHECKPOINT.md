# Shared-foundation checkpoint for Asteroid

2026-11-09: the bounded design/prototype task is complete, and production migration is stopped for review. Both public launchers and film recipes remain unchanged.

The developer-only reference code is temporarily maintained under tools/foundation in the sibling Batman repository; no second engine copy is introduced here, no permanent engine repository is selected, and no runtime dependency on that checkout is added to Asteroid.

- All four mode pipelines are audited. Asteroid has 25 canonical media stages for unmasked and 32 for masked; source/destination branch variants are preserved in the audit, not silently discarded.
- Asteroid's actual video-only MKVToolNix preparation arguments are represented by a small profile, separate from BvS's output naming/source contract/expected codec.
- Generated 96x64 AVC video/tone fixtures pass legacy/shared preparation comparisons under MKVToolNix 78 and 102: packet/timing parity, unchanged coded picture payloads and 24 decoded frames, one video track, source unchanged.
- Malformed generated media and native fault scenarios compare warning/failure/output-guard behavior with the real BAT preparation block. The common isolated suite has 17 methods, zero skips.
- Identity design distinguishes source-video acceptance from whole-job/retained-stream identity, preventing stale final output when audio/subtitle choices change.

The Python 3.14 reference is a proposed technology direction, not an accepted production stack. Its direct-child timeout does not replace existing Windows job-object supervision. It does not implement full source recognition, resume, cleanup, GUI, complete media execution or cross-platform support. No exhaustive public frame validation is introduced. Existing Asteroid runtime/regression files still match the previously passing 64-method baseline.

The common source-controlled report, job-state contract, technology recommendation, four mode maps and verification summary are under docs/planning/foundation in the Batman repository. The workspace GOALS-AND-ROADMAP.md links to that report when both projects are checked out together. Next proposed proofs are native supervision parity and self-contained packaging, followed by incremental stage extraction only after review. No private films, dependency upgrades or publication were involved.
