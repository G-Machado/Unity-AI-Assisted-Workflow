---
description: Bootstrap Claude + MCP config for this Unity project. Creates .claude/ structure, copies agent configs, and sets up .mcp.json for Unity MCP server. Skips steps already handled by install.sh.
allowed-tools: Read, Write, Bash(mkdir:*), Bash(cp:*), Bash(ls:*), Bash(test:*), Bash(cat:*), Bash(grep:*)
---

Bootstrap the Claude Code environment for this Unity project.

## Pre-check: detect if install.sh already ran

Check if `.claude/settings.json` and `.mcp.json` already exist with real values (not placeholders). If both are present and configured, print:

```
✅ This project was already set up by install.sh.
   .claude/    — present
   CLAUDE.md   — present
   .mcp.json   — configured

   You're ready to go. Start with: /investigate <your task>
```

Then stop — no further action needed.

If `.mcp.json` exists but still contains `REPLACE_WITH`, treat it as not configured and continue to step 5.

## Steps (only if setup is incomplete)

1. **Detect project root** — look for `Assets/`, `ProjectSettings/`, `Packages/` directories to confirm this is a Unity project. If not found, warn and use current directory.

2. **Create `.claude/` directory** if it does not already exist.

3. **Create `.claude/agents/` directory** if it does not already exist.

4. **Write `.claude/settings.json`** — only if it doesn't exist (never overwrite without asking):
```json
{
  "model": "claude-sonnet-4-20250514",
  "permissions": {
    "deny": [
      "Bash(git push*)",
      "Bash(git push --force*)",
      "Bash(gh pr create*)",
      "Bash(gh pr merge*)"
    ]
  }
}
```

5. **Generate `.mcp.json`** at project root — only if it doesn't exist or still has placeholders:
   - Set `UNITY_PROJECT_PATH` to the current working directory (absolute path)
   - Auto-detect `UNITY_EDITOR_PATH`:
     - **Windows**: scan `C:\Program Files\Unity\Hub\Editor\*\Editor\Unity.exe`, pick the latest version
     - **macOS**: scan `/Applications/Unity/Hub/Editor/*/Unity.app/Contents/MacOS/Unity`
     - **Linux**: scan `~/Unity/Hub/Editor/*/Editor/Unity`
   - Also check `ProjectSettings/ProjectVersion.txt` for the project's expected Unity version
   - If auto-detection fails, ask the developer for the path
   - Write the final `.mcp.json` with real paths

6. **If any file already exists** with real content, ask before overwriting. Show the existing content and confirm.

7. **Print a summary** of what was created/skipped.

8. **Print next steps**:
   - Install Unity MCP server (if not already): `npm install -g unity-mcp-server`
   - Start your first task with `/investigate $ARGUMENTS`
