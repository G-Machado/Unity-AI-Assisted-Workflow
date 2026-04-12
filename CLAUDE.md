# unity-ai-ritual

You are working on a Unity project with a strict, disciplined AI workflow.
Read and follow these rules in every session, without exception.

---

## The 7 Laws — Non-Negotiable

1. **Investigate before implementing** — never write code without completing an investigation first
2. **No branch without approval** — always present the branch name and wait for explicit confirmation
3. **Never push automatically** — `git push` is always a manual human action
4. **Never create PRs automatically** — PRs require deliberate human creation
5. **Stop before Unity validation** — implementation ends; the developer validates in the Editor
6. **Manual validation required** — no automated test replaces opening Unity and checking Play Mode
7. **Propose alternatives first** — always offer 3 approaches before taking any action

## Workflow — Follow This Sequence Every Time

```
/investigate-task  →  developer approves approach
        ↓
/start-implementation  →  ⛔ STOP — developer opens Unity
        ↓
/validate-unity  →  errors?  →  /fix-unity-error
        ↓
/modular-commits  →  ⛔ STOP — developer reviews and pushes manually
```

Skipping steps is not allowed.

## Guardrails — NEVER Do These

- ❌ `git push` (any variant, including `--force`)
- ❌ `gh pr create` or `gh pr merge`
- ❌ `git commit` without explicit developer approval of the commit plan
- ❌ Implement anything without a completed `investigate-task` first
- ❌ Apply a fix without presenting alternatives first

If asked to do any of the above, refuse clearly and explain why.

## Available Skills

- `investigate-task` — root cause analysis, 3 approaches, no code
- `start-implementation` — branch + implementation after approved approach
- `validate-unity` — Unity Editor validation, MCP inspection
- `fix-unity-error` — error classification and solution proposals
- `modular-commits` — logical atomic commits, no push

## Available Commands

- `/ritual-init` — bootstrap this project's Claude + MCP config
- `/investigate` — investigate a task (alias)
- `/implement` — start approved implementation (alias)
- `/validate` — validate in Unity (alias)
- `/fix-error` — fix a Unity error (alias)
- `/commit` — structure modular commits (alias)

## MCP

When Unity MCP is available, prefer it over assumptions for:
- Reading Unity Console output
- Inspecting GameObjects and components
- Checking scene hierarchy
- Confirming missing references

## Language and Tone

- Be precise and technical
- Flag uncertainty rather than guessing
- Present options — the developer decides
- Mark risks explicitly with ⚠️
