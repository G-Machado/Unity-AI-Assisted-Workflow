# unity-ai-ritual

> Structured AI-assisted development workflow for Unity projects.
> Native Claude Code package — no extra tokens, no external runtime.

---

## What is this?

A Claude Code package that enforces a disciplined, step-by-step workflow for Unity development. It ships as native Claude Code primitives: skills, slash commands, subagents, and a `CLAUDE.md` — no TypeScript, no extra dependencies.

**Core principle:** AI is a collaborator, not an autonomous agent. The developer is always in control.

---

## Install

Copy the `.claude/` folder and `CLAUDE.md` into your Unity project root:

```bash
# From this package directory
cp -r .claude/ /path/to/your/unity/project/
cp CLAUDE.md /path/to/your/unity/project/
cp .mcp.json /path/to/your/unity/project/   # then edit with your paths
```

Or run the init command from inside your Unity project with Claude Code:

```
/ritual-init
```

---

## Setup

### 1. Configure MCP (optional but recommended)

Edit `.mcp.json` at your project root:

```json
{
  "mcpServers": {
    "unity": {
      "command": "npx",
      "args": ["-y", "unity-mcp-server"],
      "env": {
        "UNITY_PROJECT_PATH": "/absolute/path/to/MyUnityProject",
        "UNITY_EDITOR_PATH": "/Applications/Unity/Hub/Editor/2022.3.0f1/Unity.app/Contents/MacOS/Unity"
      }
    }
  }
}
```

Install the server:
```bash
npm install -g unity-mcp-server
```

### 2. Open Claude Code in your project root

```bash
cd /path/to/your/unity/project
claude
```

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
unity-ai-ritual/
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
