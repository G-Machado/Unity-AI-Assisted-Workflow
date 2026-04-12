---
name: doc-init
description: Bootstrap .claude/docs/ for a Unity project. Scans existing C# files and project structure to generate initial PROJECT.md, SYSTEMS.md, DECISIONS.md, and ERRORS.md. Run once when first setting up a project, or when docs are missing.
---

# Skill: doc-init

## Purpose
Create the `.claude/docs/` documentation layer from scratch by scanning
the existing Unity project. Produces dense, structured files that give
Claude full context in minimal tokens from the very first session.

## When to Use
- First time setting up docs on an existing project
- `.claude/docs/` is missing or corrupted
- Invoked by `/doc-init` command

---

## Step 1 — Create directory
```bash
mkdir -p .claude/docs
```

---

## Step 2 — Scan the project

Run these to understand what exists:
```bash
# All C# scripts
find Assets -name "*.cs" | sort

# Scene files
find Assets -name "*.unity" | sort

# ScriptableObject assets
find Assets -name "*.asset" | sort

# Recent git history (if repo exists)
git log --oneline -10 2>/dev/null || echo "no git history"

# Current branch
git branch --show-current 2>/dev/null || echo "main"
```

For each `.cs` file found, read it to extract:
- Class name and type (MonoBehaviour, ScriptableObject, static, interface)
- `[SerializeField]` fields
- Public methods and events
- `using` statements (reveals dependencies)

Limit scan to `Assets/Scripts/` and subdirectories. Skip `Assets/Plugins/`,
`Assets/ThirdParty/`, generated files.

---

## Step 3 — Write PROJECT.md

```markdown
# Project State
updated: <today> | branch: <current branch> | status: stable

## Active Work
none

## Systems
<one line per discovered system: Name — purpose — path>

## Open Issues
none

## Next
<none, or infer from TODO comments found in code>
```

If the codebase has TODO/FIXME comments, list them under Open Issues.

---

## Step 4 — Write SYSTEMS.md

One `##` block per class discovered. Infer dependencies from `using` statements
and field types. If a class references `PlayerHealth` by type, it depends on it.

```markdown
# System Map
<!-- Initialized by doc-init on <date>. Updated by update-docs after each commit. -->

## <ClassName>
path: <Assets/relative/path.cs>
type: <MonoBehaviour|ScriptableObject|static|interface|manager>
depends: <comma-separated list, or "none">
exposes: <public methods/events, or "none">
serialized: <_fieldName(Type), or omit if none>
notes: <only if something non-obvious was found>
```

Batch all discovered classes. If there are more than 20 classes,
prioritize: MonoBehaviours > ScriptableObjects > managers > utilities.

---

## Step 5 — Write DECISIONS.md

```markdown
# Decision Log
<!-- Append-only. One entry per architectural decision. -->

## [<today>] Initial project scan
context: doc-init run on existing project
chosen: documented current architecture as-is
rejected: n/a
reason: baseline for future decisions
affects: all systems
```

---

## Step 6 — Write ERRORS.md

```markdown
# Error Log
<!-- Append-only. Entries added by fix-unity-error on resolution. -->
```

If TODO/FIXME comments in code suggest known bugs, add them as open entries:

```markdown
## [<today>] <issue from TODO comment>
status: open
cause: <inferred from context>
fix: pending
files: <file:line>
```

---

## Step 7 — Print summary

```
✅ .claude/docs/ initialized

  PROJECT.md   — current state snapshot
  SYSTEMS.md   — <N> systems documented
  DECISIONS.md — baseline entry written
  ERRORS.md    — <N> open issues from TODO comments, or empty

Tip: run /doc-update after your next commit to keep these current.
```

---

## Hard Rules
- ❌ Never guess at system behavior — only record what the code confirms
- ❌ Never scan third-party or plugin folders
- ✅ Mark anything uncertain with `# unverified` inline comment
- ✅ Keep every entry as short as possible
- ✅ The goal is context density, not completeness — better to have 10 accurate entries than 30 speculative ones
