---
description: Bootstrap .claude/docs/ for this Unity project. Scans existing scripts and generates PROJECT.md, SYSTEMS.md, DECISIONS.md, and ERRORS.md. Run once on project setup, or when docs are missing.
allowed-tools: Read, Write, Bash(find:*), Bash(git log:*), Bash(git branch:*), Bash(mkdir:*)
---

Use the `doc-init` skill to initialize project documentation.

If `.claude/docs/` already exists and contains files, warn before overwriting:
```
⚠ .claude/docs/ already exists. Overwrite? (yes/no)
```
Wait for confirmation before proceeding.

Follow the doc-init skill instructions exactly.
End by printing the summary of what was created.
