---
description: Bootstrap Claude + MCP config for this Unity project. Creates .claude/ structure, copies agent configs, and sets up .mcp.json for Unity MCP server.
allowed-tools: Read, Write, Bash(mkdir:*), Bash(cp:*), Bash(ls:*), Bash(test:*)
---

Bootstrap the Claude Code environment for this Unity project.

## Steps

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

5. **Write `.mcp.json`** at project root — only if it doesn't exist:
```json
{
  "mcpServers": {
    "unity": {
      "command": "npx",
      "args": ["-y", "unity-mcp-server"],
      "env": {
        "UNITY_PROJECT_PATH": "REPLACE_WITH_YOUR_UNITY_PROJECT_PATH",
        "UNITY_EDITOR_PATH": "REPLACE_WITH_YOUR_UNITY_EDITOR_PATH"
      }
    }
  }
}
```

6. **If any file already exists**, ask before overwriting. Show the existing content and confirm.

7. **Print a summary** of what was created/skipped.

8. **Print next steps**:
   - Edit `.mcp.json` and set `UNITY_PROJECT_PATH` and `UNITY_EDITOR_PATH`
   - Install Unity MCP server: `npm install -g unity-mcp-server`
   - Start your first task with `/investigate $ARGUMENTS`
