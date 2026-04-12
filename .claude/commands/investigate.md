---
description: Investigate a task before any implementation. Loads project docs for context, performs root cause analysis, and proposes 3 approaches. No code is written.
allowed-tools: Read, Glob, Grep, Bash(git log:*), Bash(git diff:*), Bash(git status:*), Bash(cat:*), Bash(find:*)
---

## Pre-step: Load project context

Before investigating, check if `.claude/docs/` exists.
If it does, read these files silently (do not print their contents):
- `.claude/docs/PROJECT.md` — current state and open issues
- `.claude/docs/SYSTEMS.md` — existing systems and dependencies
- `.claude/docs/DECISIONS.md` — past architectural choices
- `.claude/docs/ERRORS.md` — known errors and proven fixes

Use this context to:
- Avoid re-investigating systems already documented
- Respect past decisions (don't propose approaches already rejected)
- Check if the task touches systems with known issues
- Identify relevant dependencies upfront

If `.claude/docs/` does not exist, note briefly:
```
ℹ No project docs found. Run /doc-init after this session to build context for future investigations.
```

---

## Investigation

Use the `investigate-task` skill to analyze: $ARGUMENTS

Activate the **Investigator** subagent for this task.
Follow the investigate-task skill instructions exactly.
Do NOT write any code. Do NOT create any branch. Do NOT modify any file.
End by announcing: "Investigation complete. Awaiting your approval to proceed."
