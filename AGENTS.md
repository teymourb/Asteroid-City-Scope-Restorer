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

For documentation and planning tasks, read docs/README.md and the relevant current
architecture/roadmap before historical notes. Update affected feature/decision and
user-facing documentation with behavior changes. Keep owner decisions, proposals,
research, local validation and shipped features distinct; do not infer new scope
from a backlog item.

Before each future release publication, show the owner the exact final release
notes, README changes, version/tag and asset/checksum list, then stop for review
and explicit publication approval. A general go-ahead is not this final review.
Keep public notes focused on user-visible changes and essential usage information;
roadmaps, implementation debates and internal qualification belong in developer docs.
Editorial release-page corrections must not silently replace published ZIP bytes.
