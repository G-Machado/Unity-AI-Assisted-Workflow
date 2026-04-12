# Unity-AI-Assisted-Workflow

> Structured AI-assisted development workflow for Unity projects.
> Native Claude Code package — no extra tokens, no external runtime.

---

## What is this?

A Claude Code package that enforces a disciplined, step-by-step workflow for Unity development. It ships as native Claude Code primitives: skills, slash commands, subagents, and a `CLAUDE.md` — no TypeScript, no extra dependencies.

**Core principle:** AI is a collaborator, not an autonomous agent. The developer is always in control.

---

## Install

### Quick install (recommended)

Clone this repo, then run the installer from your Unity project root. It auto-detects your Unity Editor path and generates `.mcp.json` for you — no manual configuration needed.

```bash
# From your Unity project root
bash /path/to/Unity-AI-Assisted-Workflow/install.sh
```

On Windows (Git Bash):
```bash
cd "C:/Users/you/Projects/MyUnityGame"
bash "C:/path/to/Unity-AI-Assisted-Workflow/install.sh"
```

The script will:
1. Validate you're in a Unity project
2. Copy `.claude/` and `CLAUDE.md` into the project
3. Auto-detect the Unity Editor executable (Windows, macOS, Linux)
4. Generate `.mcp.json` with the correct paths
5. Install `unity-mcp-server` via npm (if available)

### Manual install

```bash
cp -r .claude/ /path/to/your/unity/project/
cp CLAUDE.md /path/to/your/unity/project/
cp .mcp.json /path/to/your/unity/project/   # then edit with your paths
```

### From inside Claude Code

If `.claude/` is already in your project, run:
```
/ritual-init
```

This will auto-detect paths and fix any incomplete MCP config.

---

## Setup

After running `install.sh`, everything should be configured automatically. Open Claude Code in your project root:

```bash
cd /path/to/your/unity/project
claude
```

If you need to manually configure MCP, edit `.mcp.json` at your project root with the correct Unity paths. Install the MCP server with `npm install -g unity-mcp-server`.

---

## Workflow

Every task follows this exact sequence — no shortcuts:

```
/investigate <task>
      ↓
  AI proposes 3 approaches → you approve one
      ↓
/implement
      ↓
  ⛔ STOP — open Unity Editor, check Play Mode
      ↓
/validate [paste any errors]
      ↓
  errors? → /fix-error <error>
      ↓
/commit
      ↓
  ⛔ STOP — review commits, push manually
```

---

## Commands

| Command | What it does |
|---|---|
| `/ritual-init` | Bootstrap `.claude/` + `.mcp.json` for this project |
| `/investigate <task>` | Root cause analysis, 3 approaches, no code written |
| `/implement` | Create branch + implement approved approach, stops before commit |
| `/validate [error]` | Validate Unity Editor state, routes on pass/fail |
| `/fix-error <error>` | Classify error, propose 3 solutions, never applies automatically |
| `/commit` | Structure logical commits, present plan, execute after approval |

---

## Guardrails

Blocked at the `settings.json` permission level — Claude Code will refuse these:

| Blocked | Reason |
|---|---|
| `git push` | Always a manual human action |
| `git push --force` | Can cause irreversible data loss |
| `gh pr create` | PRs require deliberate human creation |
| `gh pr merge` | Merging requires human review |

---

## Package Structure

```
Unity-AI-Assisted-Workflow/
├── install.sh                         ← one-command installer (auto-detects Unity)
├── CLAUDE.md                          ← loaded every session, enforces the 7 laws
├── .mcp.json                          ← Unity MCP server config template
└── .claude/
    ├── settings.json                  ← model + permission denies
    ├── commands/
    │   ├── ritual-init.md             ← /ritual-init
    │   ├── investigate.md             ← /investigate
    │   ├── implement.md               ← /implement
    │   ├── validate.md                ← /validate
    │   ├── fix-error.md               ← /fix-error
    │   └── commit.md                  ← /commit
    ├── skills/
    │   ├── investigate-task/SKILL.md  ← auto-invoked by Claude when relevant
    │   ├── start-implementation/SKILL.md
    │   ├── validate-unity/SKILL.md
    │   ├── fix-unity-error/SKILL.md
    │   └── modular-commits/SKILL.md
    └── agents/
        ├── investigator.md            ← subagent: root cause analysis
        ├── implementer.md             ← subagent: disciplined execution
        └── validator.md               ← subagent: pre-commit verification
```

---

## The 7 Laws

1. Investigate before implementing
2. No branch without explicit approval
3. Never push automatically
4. Never create PRs automatically
5. Stop before Unity validation
6. Manual validation required
7. Propose 3 alternatives before acting

---

## Requirements

- Claude Code (any recent version)
- Unity 2021.3+
- `unity-mcp-server` npm package (optional, for Editor inspection)
