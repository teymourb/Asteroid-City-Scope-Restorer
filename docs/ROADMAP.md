# Asteroid roadmap view

Owner decisions dated 2026-11-09: two standalone restorers with one maintained engine; reliable jobs first. Stable IDs below refer to the cross-project register under docs/planning in the Batman repository. This is a scoped view, not a competing register or implementation approval.

| Milestone | Outcome | Feature references |
|---|---|---|
| M0 maintenance | Finalize Windows fixes; accurately document shipped fingerprints/cleanup | SAFE-02/08, SRC-01/03/04, DOC-01 |
| M1 shared foundation | Explicit Asteroid profile/dependencies; common safe execution/status/job contracts demonstrated with BvS | ARCH-01–04, UX-04/05 |
| M2 reliable jobs | Verified stage resume, clearer progress, separate work drive, capacity/recovery/cleanup policy | JOB-01–05, UX-03 |
| M3 measured optimization | Reduce repeated I/O/peak space; bounded concurrency only with evidence | SRC-06, PERF-01–03 |
| Parallel qualification | Preserve synthetic checks; assess actual framing, logos/joins, streams and timing when authorized | QUAL-01–04 |
| M4+ interface/platforms | GUI using same engine; select and qualify native OS/CPU packages | UI-01, PLAT-02/03 |
| Stewardship | Source/build provenance; explicitly selected dependency upgrades | DIST-01–03 |

Already shipped: extracted-AVC source gate, dialogs/fallback, clearer prompts, stage/remux guards, destination protection, separate logs and bounded cleanup. The manual-unmasked .mkv.mkv packaging typo is fixed in v1.0.2. Do not schedule these as absent features.

The local Windows correction passed 64 methods with zero skips under MKVToolNix 78 and 102. Run cross-project suites serially. Synthetic success is not complete-film qualification.

Resume, configurable work drives, richer progress and lower peak storage are future work. Public validation-level selection was withdrawn; developer assembly checks remain separate. Logo permission/publication were resolved in later records. Historical candidate blockers are not automatically current blockers.

BvS optional final RPU injection and trim reconstruction are distant research, not an Asteroid commitment. Hardware signing investigation was dropped. Source integration and releases remain separate authorized steps.
