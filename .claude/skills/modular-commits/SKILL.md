---
name: modular-commits
description: Structure code changes into logical, atomic, Conventional Commits. Audits all changes, groups by logical unit, presents a commit plan for approval, then executes. Use after validate-unity passes. Never pushes.
---

# Skill: modular-commits

## Purpose
Organize changes into logical, atomic, reviewable commits.
This skill structures and executes commits — it NEVER pushes.

## Step 1: Audit All Changes

```bash
git status
git diff --stat
```

Categorize every changed file:
- New features / new files
- Bug fixes
- Refactors
- Tests
- Documentation
- Configuration

## Step 2: Propose Commit Structure

**Present the full plan before executing any commit. Wait for approval.**

```
Proposed Commits:

[1] fix(PlayerHealth): correct health reduction on damage
    Files: Assets/Scripts/Player/PlayerHealth.cs

[2] refactor(HealthUI): decouple UI update from damage event
    Files: Assets/Scripts/UI/HealthBarUI.cs

[3] test(PlayerHealth): add unit test for TakeDamage
    Files: Assets/Tests/PlayerHealthTests.cs

Approve this plan? (yes/no)
```

## Step 3: Conventional Commits Format

```
<type>(<scope>): <short description>

[optional body — explain WHY, not what]
```

| Type | When |
|------|------|
| `feat` | New feature or behavior |
| `fix` | Bug fix |
| `refactor` | Restructure without behavior change |
| `chore` | Tooling, config, dependencies |
| `docs` | Documentation only |
| `test` | Tests only |
| `perf` | Performance improvement |
| `style` | Formatting only |

## Step 4: Execute Commits

After approval, stage and commit each logical group:

```bash
git add <specific files only>
git commit -m "fix(PlayerHealth): correct health reduction on damage"
```

**Never use `git add .` blindly** — always stage intentionally.

## Step 5: Final Summary

```
Commits created:
  abc1234 fix(PlayerHealth): correct health reduction on damage
  def5678 refactor(HealthUI): decouple UI update from damage event
  ghi9012 test(PlayerHealth): add unit test for TakeDamage

Branch: fix/player-health-not-updating
Status: ✅ Ready for review

Review with: git log --oneline
Push manually when ready: git push origin <branch>
```

## Hard Rules
- ❌ NEVER run `git push` — not ever
- ❌ NEVER use `git add .` without reviewing what it stages
- ❌ NEVER execute commits before plan approval
- ✅ Always present commit plan before executing
- ✅ Always commit in atomic units
- ✅ Remind developer to push manually at the end
