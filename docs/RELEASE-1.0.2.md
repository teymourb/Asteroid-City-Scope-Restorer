# Proposed release 1.0.2 — not published

Fixes a late failure in the unmasked restoration when you enter the output folder
manually. Both restoration modes now retain their assembled video when final
muxing fails or reports warnings, with details in `docs/temp/final-remux.log`.
They also stop if the final output is missing or empty.

On a warning or failure, copy the retained assembled video and log somewhere safe
before restarting: the existing startup routine clears temporary files. A file
left in the destination after an error may be incomplete and must not be used.
A warning result needs inspection. There is no automatic resume function yet.

The required source edition, cuts, framing, encoding settings, audio/subtitle
selection and successful output filenames are unchanged. Windows remains the
only application target; this patch does not add macOS/Linux support.

Windows Server 2022 regression and synthetic-media tests pass (all six test
methods; see PACKAGE-AUDIT-1.0.2.md for evidence and coverage). Publication is pending
audit and targeted qualification of the actual downloadable package/tool version,
resolution of the source/redistribution gaps in PACKAGE-AUDIT-1.0.2.md and owner
approval. A local review candidate is prepared using the audited original tools;
see its adjacent manifest for the exact source commit, checksum and contents. Existing releases
remain available. See DEVELOPMENT.md for exact evidence and limitations.

The candidate uses ZIP packaging and removes unused copied-installation
uninstallers. Existing processing binaries are retained byte-for-byte.
