---
description: Manually trigger a documentation update. Updates PROJECT.md, SYSTEMS.md, DECISIONS.md, and ERRORS.md based on recent commits. Use if you skipped an update or want to refresh docs mid-session.
allowed-tools: Read, Write, Bash(git log:*), Bash(git diff:*), Bash(git branch:*), Bash(git show:*)
---

Use the `update-docs` skill to refresh `.claude/docs/`.

If `.claude/docs/` does not exist, suggest running `/doc-init` first and stop.

Context: $ARGUMENTS

Follow the update-docs skill instructions exactly.
End by printing a one-line summary of what was updated.
