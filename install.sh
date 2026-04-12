#!/usr/bin/env bash
# ──────────────────────────────────────────────────────────────
# Unity-AI-Assisted-Workflow — remote installer
#
# Run from your Unity project root:
#   bash <(curl -fsSL https://raw.githubusercontent.com/G-Machado/Unity-AI-Assisted-Workflow/main/install.sh)
#
# What it does:
#   1. Validates you're in a Unity project
#   2. Downloads the latest package from GitHub
#   3. Copies .claude/ and CLAUDE.md into the project
#   4. Auto-detects your Unity Editor path
#   5. Generates .mcp.json — no manual config needed
#   6. Installs unity-mcp-server via npm
# ──────────────────────────────────────────────────────────────
set -euo pipefail

REPO_OWNER="G-Machado"
REPO_NAME="Unity-AI-Assisted-Workflow"
REPO_BRANCH="main"
REPO_ARCHIVE="https://github.com/${REPO_OWNER}/${REPO_NAME}/archive/refs/heads/${REPO_BRANCH}.tar.gz"

PROJECT_DIR="$(pwd)"

# ── Colors ───────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

info()  { echo -e "${CYAN}[info]${NC}  $1"; }
ok()    { echo -e "${GREEN}[ok]${NC}    $1"; }
warn()  { echo -e "${YELLOW}[warn]${NC}  $1"; }
fail()  { echo -e "${RED}[fail]${NC}  $1"; exit 1; }

# ── Header ───────────────────────────────────────────────────
echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════${NC}"
echo -e "${CYAN}  Unity-AI-Assisted-Workflow Installer${NC}"
echo -e "${CYAN}═══════════════════════════════════════════════════${NC}"
echo ""

# ── Step 1: Validate Unity project ───────────────────────────
if [ ! -d "$PROJECT_DIR/Assets" ] || [ ! -d "$PROJECT_DIR/ProjectSettings" ]; then
    fail "Not a Unity project (Assets/ or ProjectSettings/ not found).\n       cd into your Unity project root and run again."
fi

info "Unity project detected: $PROJECT_DIR"

# ── Step 2: Download package from GitHub ─────────────────────
info "Downloading package from GitHub..."

TMPDIR_PKG="$(mktemp -d)"
trap 'rm -rf "$TMPDIR_PKG"' EXIT

if command -v curl &>/dev/null; then
    curl -fsSL "$REPO_ARCHIVE" -o "$TMPDIR_PKG/pkg.tar.gz" \
        || fail "Download failed. Check your connection and that the repo is public."
elif command -v wget &>/dev/null; then
    wget -q "$REPO_ARCHIVE" -O "$TMPDIR_PKG/pkg.tar.gz" \
        || fail "Download failed. Check your connection and that the repo is public."
else
    fail "curl or wget is required to install remotely."
fi

tar -xzf "$TMPDIR_PKG/pkg.tar.gz" -C "$TMPDIR_PKG"
PKG_DIR="$TMPDIR_PKG/${REPO_NAME}-${REPO_BRANCH}"
ok "Downloaded latest package"

# ── Step 3: Copy .claude/ and CLAUDE.md ──────────────────────
if [ -d "$PROJECT_DIR/.claude" ]; then
    warn ".claude/ already exists — backing up to .claude.bak/"
    cp -r "$PROJECT_DIR/.claude" "$PROJECT_DIR/.claude.bak"
fi

cp -r "$PKG_DIR/.claude" "$PROJECT_DIR/.claude"
ok "Copied .claude/ (commands, skills, agents, settings)"

cp "$PKG_DIR/CLAUDE.md" "$PROJECT_DIR/CLAUDE.md"
ok "Copied CLAUDE.md"

# ── Step 4: Auto-detect Unity Editor ─────────────────────────
detect_unity_editor() {
    local editor_path=""

    # Windows (Git Bash / MSYS2)
    if [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "mingw"* ]] || [[ "$OSTYPE" == "cygwin"* ]] || command -v cmd.exe &>/dev/null; then
        for base in "/c/Program Files/Unity/Hub/Editor" "/mnt/c/Program Files/Unity/Hub/Editor"; do
            if [ -d "$base" ] 2>/dev/null; then
                local latest
                latest=$(ls -1 "$base" 2>/dev/null | sort -V | tail -1)
                local candidate="$base/$latest/Editor/Unity.exe"
                [ -n "$latest" ] && [ -f "$candidate" ] && editor_path="$candidate" && break
            fi
        done
        if [ -z "$editor_path" ]; then
            local which_unity
            which_unity=$(command -v Unity.exe 2>/dev/null || true)
            [ -n "$which_unity" ] && editor_path="$which_unity"
        fi

    # macOS
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        local hub_editors="/Applications/Unity/Hub/Editor"
        if [ -d "$hub_editors" ]; then
            local latest
            latest=$(ls -1 "$hub_editors" 2>/dev/null | sort -V | tail -1)
            local candidate="$hub_editors/$latest/Unity.app/Contents/MacOS/Unity"
            [ -n "$latest" ] && [ -f "$candidate" ] && editor_path="$candidate"
        fi

    # Linux
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        local hub_editors="$HOME/Unity/Hub/Editor"
        if [ -d "$hub_editors" ]; then
            local latest
            latest=$(ls -1 "$hub_editors" 2>/dev/null | sort -V | tail -1)
            local candidate="$hub_editors/$latest/Editor/Unity"
            [ -n "$latest" ] && [ -f "$candidate" ] && editor_path="$candidate"
        fi
    fi

    echo "$editor_path"
}

detect_project_unity_version() {
    local version_file="$PROJECT_DIR/ProjectSettings/ProjectVersion.txt"
    if [ -f "$version_file" ]; then
        grep -oP 'm_EditorVersion:\s*\K[\S]+' "$version_file" 2>/dev/null || true
    fi
}

UNITY_EDITOR_PATH=$(detect_unity_editor)
PROJECT_VERSION=$(detect_project_unity_version)

[ -n "$PROJECT_VERSION" ] && info "Project Unity version: $PROJECT_VERSION"

if [ -n "$UNITY_EDITOR_PATH" ]; then
    ok "Auto-detected Unity Editor: $UNITY_EDITOR_PATH"
else
    warn "Could not auto-detect Unity Editor path."
    echo ""
    read -rp "    Enter the full path to your Unity Editor executable: " UNITY_EDITOR_PATH
    if [ -z "$UNITY_EDITOR_PATH" ]; then
        UNITY_EDITOR_PATH="REPLACE_WITH_ABSOLUTE_PATH_TO_UNITY_EDITOR_EXECUTABLE"
        warn "Skipped — edit .mcp.json manually to set the editor path."
    fi
fi

# ── Step 5: Generate .mcp.json ───────────────────────────────
UNITY_PROJECT_PATH="$(cd "$PROJECT_DIR" && pwd)"

if [ -f "$PROJECT_DIR/.mcp.json" ]; then
    warn ".mcp.json already exists — backing up to .mcp.json.bak"
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

ok "Generated .mcp.json"

# ── Step 6: Install unity-mcp-server ─────────────────────────
if command -v npm &>/dev/null; then
    info "Installing unity-mcp-server globally..."
    if npm install -g unity-mcp-server 2>/dev/null; then
        ok "unity-mcp-server installed"
    else
        warn "Failed to install unity-mcp-server (try running as admin)"
    fi
else
    warn "npm not found — install manually: npm install -g unity-mcp-server"
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
echo "  Next steps:"
echo "    1. Open Claude Code:  claude"
echo "    2. Start with:        /investigate <your task>"
echo ""

if grep -q "REPLACE_WITH" "$PROJECT_DIR/.mcp.json" 2>/dev/null; then
    echo -e "  ${YELLOW}⚠  Edit .mcp.json to fill in the Unity Editor path${NC}"
    echo ""
fi
