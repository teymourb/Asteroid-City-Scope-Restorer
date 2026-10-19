# Proposed release 1.0.2 — not published

This maintenance update adds clearer source/output/mode setup with validation,
dialog cancellation/error handling, manual path fallback and final confirmation.
No workspace is created until selection is complete. Use simple folder names;
unsupported CMD path characters are rejected explicitly. Visible stage messages
explain when tool details are being written to logs.

Preparation, splitting, encoding, assembly and final muxing stop on errors or
missing/empty outputs. Independent decoded-frame assembly validation checks the
ordered frames, native format and geometry before final remux. It does not prove
intended edits, timing, HDR metadata, audio/subtitle handling or synchronization.

All intermediate videos and logs remain even after output creation. Disk use is
substantially greater than the historical release; peak use is not yet measured.
Do not restart or delete work after a failure: preserve processing.log and
final-remux.log for troubleshooting. Startup refuses existing docs/temp instead
of deleting it. Automatic resume is not implemented.

Film cuts, framing, encoder arguments, stream selection and successful output
filenames remain unchanged. Windows is the only supported application target.
See DEVELOPMENT.md for exact Windows evidence and qualification limitations.

Publication remains gated on full-film qualification, package provenance and
redistribution questions in PACKAGE-AUDIT-1.0.2.md, and explicit owner approval.
Historical tools remain unchanged; no current public package has been published.
