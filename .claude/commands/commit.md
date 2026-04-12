---
description: Organize changes into logical, atomic commits using Conventional Commits. Presents commit plan for approval before executing. Never pushes.
allowed-tools: Read, Bash(git status:*), Bash(git diff:*), Bash(git add:*), Bash(git commit:*), Bash(git log:*), Bash(git branch:*)
---

Use the `modular-commits` skill to structure commits for the current changes.
Context: $ARGUMENTS

Follow the modular-commits skill instructions exactly.

1. Run `git status` and `git diff --stat` to audit all changes
2. Group files by logical unit
3. Present the full commit plan — wait for explicit approval
4. After approval, execute commits one by one
5. Print summary of all commits made

NEVER run `git push`. NEVER run `git push --force`.
End by printing the branch name and reminding the developer to push manually.
