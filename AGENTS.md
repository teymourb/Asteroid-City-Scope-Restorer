# Project rules

Read docs/DEVELOPMENT.md for approved scope, current status and validation limits.
Maintain the existing Windows utility incrementally. Preserve media command
behavior unless a task explicitly authorizes changes. Never access private film
files without task-specific permission. Synthetic test fixtures only.

Local commits are routine within approved scope. Pushes, merges, public tags and
releases need explicit owner authorization. Do not change global configuration or
install substantial infrastructure as a workaround for missing access.

Run the focused tests for this patch. Windows skips on macOS are not Windows
validation. Update the single status/evidence record rather than duplicating it.
