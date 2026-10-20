# Proposed release 1.0.2 — not published

This maintenance update adds clearer source/output/mode setup with validation,
dialog cancellation/error handling, manual path fallback and final confirmation.
No workspace is created until selection is complete. Use simple folder names;
unsupported CMD path characters are rejected explicitly. Visible stage messages
explain when tool details are being written to logs.

Preparation, splitting, encoding, assembly and final muxing stop on errors or
missing/empty outputs. Setup explicitly selects routine checks or exhaustive
decoded-frame comparison. Routine records NOT RUN; exhaustive checks frame order,
native format and geometry and may take many hours. Neither proves intended
edits, timing, HDR metadata, source identity or synchronization. Avidemux
questions/diagnostics are visible in the console; only its stage/status is logged.
FFmpeg ignores accidental keyboard commands during splitting.

All intermediate videos and logs remain even after output creation. Disk use is
substantially greater than the historical release; peak use is not yet measured.
Do not restart or delete work after a failure: preserve processing.log and
final-remux.log for troubleshooting. Startup refuses existing docs/temp instead
of deleting it. Automatic resume is not implemented.

Film cuts, framing, encoder arguments, stream selection and successful output
filenames remain unchanged. Windows is the only supported application target.
See DEVELOPMENT.md for exact Windows evidence and qualification limitations.

Full-film qualification is incomplete and legacy join compatibility remains
unresolved; no pristine-output claim is made. A local source-only candidate can
be reviewed without new film encoding. Full-package publication remains gated
on package provenance/redistribution questions in PACKAGE-AUDIT-1.0.2.md and
an explicit owner release decision with the qualification limits disclosed.
Historical tools remain unchanged; no current public package has been published.
