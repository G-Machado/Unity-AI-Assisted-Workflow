---
name: start-implementation
description: Execute an approved implementation approach with minimal footprint. Creates a branch (after confirmation), implements only what was approved, then stops for Unity validation. Activates only after investigate-task has been completed and an approach explicitly approved.
---

# Skill: start-implementation

## Pre-conditions (ALL must be true before starting)
- [ ] `investigate-task` was completed for this task
- [ ] One approach was explicitly approved by the developer
- [ ] Working directory is clean or accounted for

## Mandatory Steps

### ⛔ STOP 1 — Branch Confirmation
Present the branch name. **Do not create the branch until confirmed.**

```
Proposed branch: fix/<task-slug>
Confirm to proceed? 
```

Branch naming convention:
- Bug fix: `fix/<task-slug>`
- Feature: `feature/<task-slug>`
- Refactor: `refactor/<task-slug>`

### 2. Implement the Minimum Necessary
- Implement only what the approved approach requires
- Do NOT refactor unrelated code
- Do NOT add features beyond scope
- Do NOT change formatting outside modified areas
- Keep changes as small and reviewable as possible

### 3. Inline Documentation
- Add brief comments to non-obvious changes
- Mark workarounds: `// WORKAROUND: <reason>`
- Mark known debt: `// TODO: <description>`

### 4. Self-Review Checklist
Before STOP 2, verify:
- [ ] Only files listed in the investigation were modified
- [ ] No `Debug.Log`, `print`, or debug artifacts left
- [ ] No commented-out dead code added
- [ ] No hardcoded values that should be serialized
- [ ] All `[SerializeField]` attributes correct
- [ ] No unused `using` statements added

### ⛔ STOP 2 — Hand Off to Validation
Do NOT commit. Do NOT stage.

Announce:
```
Implementation complete.
Modified files: [list]
Please validate in Unity Editor, then run /validate
```

## Hard Rules
- ❌ Do NOT commit
- ❌ Do NOT push
- ❌ Do NOT open a PR
- ❌ Do NOT implement beyond approved scope
- ✅ Always stop at STOP 1 and STOP 2
- ✅ Always hand off to validate-unity
