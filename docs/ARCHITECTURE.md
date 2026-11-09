# Asteroid architecture and shared-engine direction

## Current implementation

The Windows BAT delegates setup, workspace supervision and source acceptance to PowerShell 5.1 helpers, then runs film-specific processing, assembly and final remux with bundled tools. Those three helpers currently match the Batman copies byte for byte. Ownership, owned-process supervision, bounded cleanup and separate logs exist; general resume does not.

The supported source is documented AVC video. Fingerprinting hashes normally extracted AVC bytes, independently of audio/subtitles/track order. [SOURCE-FINGERPRINT.md](SOURCE-FINGERPRINT.md) gives exact contracts. BvS HEVC AUD/RPU normalization is not Asteroid's algorithm.

The film profile must preserve masked/unmasked Scope modes, segment boundaries, B&W/Scope crop/scale/pad settings, logo inputs, encoder instructions, recorded 15-input assemblies and output naming. Structural refactoring preserves restoration intent.

## Accepted direction, proposed implementation

The owner selected two standalone products sharing one maintained engine and reliable jobs first: resume, clearer progress, reduced disk use. Asteroid keeps its name, entry point, profile and package. Common mechanics should own process execution, status/events, workspace/job state and checkpoint verification. Profiles own exact media recipes; OS adapters own supervision/filesystem behavior.

No language, framework, engine repository or GUI is selected. Demonstrate a representative shared stage in each film against old behavior before broad extraction. Do not call Batman's historical continuation experiment general resume or weaken safety guards during refactoring.

## Differences and extension limits

Asteroid has an AVC pipeline and distinct opening/logo/framing transformations. BvS uses 4K HEVC/HDR10 and different modes. Shared operating behavior does not make media recipes or qualification interchangeable. A future BvS HEVC RPU injection feature does not apply automatically to Asteroid; any Asteroid DV route requires a separate codec/color proposal.

Cross-platform distribution needs native dependencies and OS/output evidence per film, not just a portable interface. Public source integration, packages and media-affecting changes retain existing authorization boundaries.
