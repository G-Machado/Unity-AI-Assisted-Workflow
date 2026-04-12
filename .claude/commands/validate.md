---
description: Validate Unity Editor state after implementation. Checks compilation, Play Mode behavior, MCP inspection, and regressions.
allowed-tools: Read, Bash(git diff:*), Bash(git status:*)
---

Use the `validate-unity` skill to validate the current implementation.
Unity output / error to analyze: $ARGUMENTS

Activate the **Validator** subagent for this task.
Follow the validate-unity skill instructions exactly.

If errors are found, immediately route to fix-unity-error.
If validation passes, route to modular-commits.
Never commit during this step.
