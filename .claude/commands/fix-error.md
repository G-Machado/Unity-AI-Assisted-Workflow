---
description: Classify a Unity error and propose 3 solutions (Quick Fix, Optimal Fix, Balanced Fix) with impact, risk, and affected files. Checks known errors log before analyzing. Never applies fixes automatically.
allowed-tools: Read, Write, Glob, Grep, Bash(find:*)
---

## Pre-step: Check known errors

Before analyzing, check if `.claude/docs/ERRORS.md` exists.
If it does, scan it for entries matching this error's class, file, or message.

If a matching resolved entry is found:
```
⚡ Known fix found in ERRORS.md:
   <paste the relevant entry>

Apply this fix? (yes / no — to run full analysis instead)
```

If the developer confirms, apply the known fix directly and skip the full analysis.
If no match is found, proceed normally.

---

## Analysis

Use the `fix-unity-error` skill to analyze this error: $ARGUMENTS

Follow the fix-unity-error skill instructions exactly.
Classify the error, research solutions, generate all 3 approaches with full analysis.
End with: "Awaiting your approval before any changes are made."
Never modify any file during this step.

---

## Post-step: Log resolved error

After the developer confirms a fix and it has been applied and validated:

Append to `.claude/docs/ERRORS.md` (create the file if it doesn't exist):

```markdown
## [<today>] <short error description>
status: resolved
category: <COMPILE|RUNTIME|REFERENCE|SERIALIZATION|etc.>
cause: <one-line root cause>
fix: <which approach was applied — Quick/Optimal/Balanced>
solution: <one-line description of what was done>
files: <File.cs:line>
```

Print: `📄 Error logged in ERRORS.md`
