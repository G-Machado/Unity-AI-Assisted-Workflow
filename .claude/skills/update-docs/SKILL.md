---
name: update-docs
description: Update .claude/docs/ after a commit. Keeps PROJECT.md, SYSTEMS.md, DECISIONS.md, and ERRORS.md accurate and token-efficient. Called automatically by modular-commits at the end of every commit cycle.
---

# Skill: update-docs

## Purpose
Maintain a living documentation layer that gives Claude full project context
in the fewest tokens possible. All files use structured data — no prose.

## Trigger
Called at the end of `modular-commits`, after all commits are executed.
Also callable manually: `/doc-update`

## Pre-conditions
- Commits have been made (git log has new entries)
- Working directory is clean

---

## Step 1 — Gather raw data

Run these to understand what changed:
```bash
git log --oneline -5
git diff HEAD~1 HEAD --stat
git diff HEAD~1 HEAD -- "*.cs" "*.unity" "*.asset" "*.prefab"
git branch --show-current
```

---

## Step 2 — Update PROJECT.md

Location: `.claude/docs/PROJECT.md`

**Format — strict, no deviation:**
```markdown
# Project State
updated: YYYY-MM-DD | branch: <branch> | status: stable|wip|broken

## Active Work
<one line per open task, or "none">

## Systems
<SystemName> — <one-line purpose> — <path>

## Open Issues
<issue> — <file:line if known>, or "none"

## Next
<next planned task, or "none">
```

**Rules:**
- `updated` field always reflects today
- `status: wip` if on a feature branch with uncommitted intent
- `status: stable` if on main/master with clean tree
- `status: broken` if there are known compilation errors
- Add new systems from this commit's changes; never remove existing ones
- Keep each system to one line

---

## Step 3 — Update SYSTEMS.md

Location: `.claude/docs/SYSTEMS.md`

**Format:**
```markdown
# System Map
<!-- Updated by update-docs. Do not edit manually. -->

## <SystemName>
path: <relative/path/To/File.cs>
type: MonoBehaviour | ScriptableObject | static | interface | manager
depends: <SystemA>, <SystemB>
exposes: <MethodOrProperty()>, <EventName>
serialized: <_fieldName(Type)>, ...
notes: <one-line gotcha or constraint, if any>
```

**Rules:**
- One `##` block per C# class or significant asset
- Only add/update systems touched in this commit
- Never delete a system entry — mark deprecated ones with `status: deprecated`
- `depends` = what this system reads from or calls
- `exposes` = what other systems depend on from this one
- If no serialized fields, omit the `serialized` line
- `notes` only if there's something non-obvious (lifecycle quirk, known bug, etc.)

---

## Step 4 — Append to DECISIONS.md

Location: `.claude/docs/DECISIONS.md`

Only append if this commit implemented a non-trivial architectural choice
(e.g. chose event system over direct ref, chose singleton over injection).
Skip if the commit was a bug fix with no architectural implications.

**Format — append only, never edit existing entries:**
```markdown
## [YYYY-MM-DD] <short title>
context: <why a decision was needed>
chosen: <what was implemented>
rejected: <alternatives that were considered>
reason: <one sentence — the deciding factor>
affects: <SystemA>, <SystemB>
```

---

## Step 5 — Check ERRORS.md

Location: `.claude/docs/ERRORS.md`

If the commit resolved an error that was previously logged in ERRORS.md,
update its `status` line from `open` to `resolved` and add `fix-commit: <hash>`.

Do NOT add new entries to ERRORS.md here — that is handled by `fix-unity-error`.

---

## Hard Rules
- ❌ Never write prose — structured data only
- ❌ Never delete existing entries (mark deprecated/resolved instead)
- ❌ Never fabricate system details — only record what git diff confirms
- ✅ Keep every line as short as possible
- ✅ If a file didn't change in this commit, don't touch its SYSTEMS.md entry
- ✅ Always update `updated:` in PROJECT.md
