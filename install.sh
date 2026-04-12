#!/usr/bin/env bash
# ──────────────────────────────────────────────────────────────
# Unity-AI-Assisted-Workflow installer
# Run this FROM your Unity project root:
#   bash /path/to/Unity-AI-Assisted-Workflow/install.sh
#
# What it does:
#   1. Validates you're in a Unity project (looks for Assets/)
#   2. Copies .claude/ folder and CLAUDE.md into the project
#   3. Auto-detects Unity Editor path (Windows / macOS / Linux)
#   4. Generates .mcp.json with real paths — no manual config
#   5. Installs unity-mcp-server if npm is available
# ──────────────────────────────────────────────────────────────
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(pwd)"

# ── Colors ───────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

info()  { echo -e "${CYAN}[info]${NC}  $1"; }
ok()    { echo -e "${GREEN}[ok]${NC}    $1"; }
warn()  { echo -e "${YELLOW}[warn]${NC}  $1"; }
fail()  { echo -e "${RED}[fail]${NC}  $1"; exit 1; }

# ── Step 1: Validate Unity project ──────────────────────────
echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════${NC}"
echo -e "${CYAN}  Unity-AI-Assisted-Workflow Installer${NC}"
echo -e "${CYAN}═══════════════════════════════════════════════════${NC}"
echo ""

if [ ! -d "$PROJECT_DIR/Assets" ] || [ ! -d "$PROJECT_DIR/ProjectSettings" ]; then
    fail "This doesn't look like a Unity project (no Assets/ or ProjectSettings/ found).\n       Run this script from your Unity project root."
fi

info "Unity project detected: $PROJECT_DIR"

# ── Step 2: Copy .claude/ and CLAUDE.md ──────────────────────
if [ -d "$PROJECT_DIR/.claude" ]; then
    warn ".claude/ already exists. Backing up to .claude.bak/"
    cp -r "$PROJECT_DIR/.claude" "$PROJECT_DIR/.claude.bak"
fi

cp -r "$SCRIPT_DIR/.claude" "$PROJECT_DIR/.claude"
ok "Copied .claude/ (commands, skills, agents, settings)"

cp "$SCRIPT_DIR/CLAUDE.md" "$PROJECT_DIR/CLAUDE.md"
ok "Copied CLAUDE.md"

# ── Step 3: Auto-detect Unity Editor ─────────────────────────
detect_unity_editor() {
    local editor_path=""

    # Windows (Git Bash / MSYS2 / WSL with Windows paths)
    if [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "mingw"* ]] || [[ "$OSTYPE" == "cygwin"* ]] || command -v cmd.exe &>/dev/null; then
        # Check Unity Hub default install locations
        local hub_editors=""

        # Try Program Files
        for base in "/c/Program Files/Unity/Hub/Editor" "/mnt/c/Program Files/Unity/Hub/Editor" "C:/Program Files/Unity/Hub/Editor"; do
            if [ -d "$base" ] 2>/dev/null; then
                hub_editors="$base"
                break
            fi
        done

        if [ -n "$hub_editors" ]; then
            # Find the latest version
            local latest
            latest=$(ls -1 "$hub_editors" 2>/dev/null | sort -V | tail -1)
            if [ -n "$latest" ]; then
                # Build the path to the Unity executable
                local candidate="$hub_editors/$latest/Editor/Unity.exe"
                if [ -f "$candidate" ]; then
                    editor_path="$candidate"
                fi
            fi
        fi

        # Fallback: check if Unity.exe is on PATH
        if [ -z "$editor_path" ]; then
            local which_unity
            which_unity=$(command -v Unity.exe 2>/dev/null || true)
            if [ -n "$which_unity" ]; then
                editor_path="$which_unity"
            fi
        fi

    # macOS
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        local hub_editors="/Applications/Unity/Hub/Editor"
        if [ -d "$hub_editors" ]; then
            local latest
            latest=$(ls -1 "$hub_editors" 2>/dev/null | sort -V | tail -1)
            if [ -n "$latest" ]; then
                local candidate="$hub_editors/$latest/Unity.app/Contents/MacOS/Unity"
                if [ -f "$candidate" ]; then
                    editor_path="$candidate"
                fi
            fi
        fi

    # Linux
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        local hub_editors="$HOME/Unity/Hub/Editor"
        if [ -d "$hub_editors" ]; then
            local latest
            latest=$(ls -1 "$hub_editors" 2>/dev/null | sort -V | tail -1)
            if [ -n "$latest" ]; then
                local candidate="$hub_editors/$latest/Editor/Unity"
                if [ -f "$candidate" ]; then
                    editor_path="$candidate"
                fi
            fi
        fi
    fi

    echo "$editor_path"
}

# Also try to read the Unity version from the project itself
detect_project_unity_version() {
    local version_file="$PROJECT_DIR/ProjectSettings/ProjectVersion.txt"
    if [ -f "$version_file" ]; then
        grep -oP 'm_EditorVersion:\s*\K[\S]+' "$version_file" 2>/dev/null || true
    fi
}

UNITY_EDITOR_PATH=$(detect_unity_editor)
PROJECT_VERSION=$(detect_project_unity_version)

if [ -n "$PROJECT_VERSION" ]; then
    info "Project Unity version: $PROJECT_VERSION"
fi

if [ -n "$UNITY_EDITOR_PATH" ]; then
    ok "Auto-detected Unity Editor: $UNITY_EDITOR_PATH"
else
    warn "Could not auto-detect Unity Editor path."
    echo ""
    read -rp "    Enter the full path to your Unity Editor executable: " UNITY_EDITOR_PATH
    if [ -z "$UNITY_EDITOR_PATH" ]; then
        UNITY_EDITOR_PATH="REPLACE_WITH_ABSOLUTE_PATH_TO_UNITY_EDITOR_EXECUTABLE"
        warn "Skipped — you'll need to edit .mcp.json manually later."
    fi
fi

# ── Step 4: Generate .mcp.json ───────────────────────────────
# Convert to absolute path for the project
UNITY_PROJECT_PATH="$(cd "$PROJECT_DIR" && pwd)"

if [ -f "$PROJECT_DIR/.mcp.json" ]; then
    warn ".mcp.json already exists. Backing up to .mcp.json.bak"
    cp "$PROJECT_DIR/.mcp.json" "$PROJECT_DIR/.mcp.json.bak"
fi

cat > "$PROJECT_DIR/.mcp.json" <<MCPEOF
{
  "mcpServers": {
    "unity": {
      "command": "npx",
      "args": ["-y", "unity-mcp-server"],
      "env": {
        "UNITY_PROJECT_PATH": "$UNITY_PROJECT_PATH",
        "UNITY_EDITOR_PATH": "$UNITY_EDITOR_PATH"
      }
    }
  }
}
MCPEOF

ok "Generated .mcp.json with auto-detected paths"

# ── Step 5: Install unity-mcp-server ─────────────────────────
if command -v npm &>/dev/null; then
    info "Installing unity-mcp-server globally..."
    if npm install -g unity-mcp-server 2>/dev/null; then
        ok "unity-mcp-server installed"
    else
        warn "Failed to install unity-mcp-server (you may need to run with admin/sudo)"
    fi
else
    warn "npm not found — install unity-mcp-server manually: npm install -g unity-mcp-server"
fi

# ── Summary ──────────────────────────────────────────────────
echo ""
echo -e "${GREEN}═══════════════════════════════════════════════════${NC}"
echo -e "${GREEN}  Installation complete!${NC}"
echo -e "${GREEN}═══════════════════════════════════════════════════${NC}"
echo ""
echo "  Installed into: $PROJECT_DIR"
echo ""
echo "  Files added:"
echo "    .claude/          commands, skills, agents, settings"
echo "    CLAUDE.md         session rules (the 7 laws)"
echo "    .mcp.json         Unity MCP server config"
echo ""
echo "  Workflow:"
echo "    1. Open Claude Code in this project root"
echo "    2. Start with:  /investigate <your task>"
echo "    3. Follow the ritual: investigate → implement → validate → commit"
echo ""

# Check if .mcp.json still has placeholders
if grep -q "REPLACE_WITH" "$PROJECT_DIR/.mcp.json" 2>/dev/null; then
    echo -e "  ${YELLOW}⚠ Edit .mcp.json to fill in the Unity Editor path${NC}"
    echo ""
fi
