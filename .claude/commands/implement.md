---
description: Begin implementation of the approved approach. Creates branch (with confirmation), implements minimum necessary, then stops for Unity validation.
allowed-tools: Read, Write, Edit, Bash(git checkout:*), Bash(git branch:*)
---

Use the `start-implementation` skill to implement the approved approach.
Context: $ARGUMENTS

Activate the **Implementer** subagent for this task.
Follow the start-implementation skill instructions exactly.

**STOP POINT 1**: Present the branch name and wait for explicit confirmation before creating it.
**STOP POINT 2**: After implementation, announce "Implementation complete — please validate in Unity Editor." Do NOT commit.
