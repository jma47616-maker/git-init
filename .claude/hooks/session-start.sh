#!/bin/bash
# Installs REA (Reverse Engineer Anything) and its Android engines for
# Claude Code cloud sessions (web / mobile app), so /rea-mobile works.
set -euo pipefail

if [ "${CLAUDE_CODE_REMOTE:-}" != "true" ]; then
  exit 0
fi

REA_VERSION="6.7.0"
TOOLS_DIR="$HOME/.local/share/rea/android"
JADX_JAR="$TOOLS_DIR/jadx-headless-mcp-0.7.1-all.jar"
JADX_URL="https://github.com/1013503897/jadx-headless-mcp/releases/download/v0.7.1/jadx-headless-mcp-0.7.1-all.jar"
# Pinned by REA in src/android/JadxRelease.ts.
JADX_SHA256="6e5eacf500b64292bfb73c49797c1958f6ee44646e43e868039ae7feb573ff75"
APKTOOL_JAR="$TOOLS_DIR/apktool_3.0.3.jar"
APKTOOL_URL="https://github.com/iBotPeaches/Apktool/releases/download/v3.0.3/apktool_3.0.3.jar"
APKTOOL_SHA256="dbf930b076c6b9be08d57c449cacefc3bdd6b71ebd59b3066fc0e1f5b14f9423"

mkdir -p "$TOOLS_DIR"

# Download $1 to $2 and verify SHA-256 $3; skip if already verified.
fetch_verified() {
  local url="$1" dest="$2" sha="$3"
  if [ -f "$dest" ] && echo "$sha  $dest" | sha256sum -c - >/dev/null 2>&1; then
    return 0
  fi
  curl -fsSL --retry 3 -o "$dest.tmp" "$url"
  if ! echo "$sha  $dest.tmp" | sha256sum -c - >/dev/null 2>&1; then
    rm -f "$dest.tmp"
    echo "SHA-256 mismatch for $url" >&2
    return 1
  fi
  mv "$dest.tmp" "$dest"
}

fetch_verified "$JADX_URL" "$JADX_JAR" "$JADX_SHA256"
fetch_verified "$APKTOOL_URL" "$APKTOOL_JAR" "$APKTOOL_SHA256"

cat > "$TOOLS_DIR/apktool" <<WRAPPER
#!/bin/sh
exec java -jar "$APKTOOL_JAR" "\$@"
WRAPPER
chmod +x "$TOOLS_DIR/apktool"

# Warm the npx cache so the REA MCP server starts quickly.
npx -y "rea-agents@$REA_VERSION" --version >/dev/null

if [ -n "${CLAUDE_ENV_FILE:-}" ]; then
  {
    echo "export REA_JADX_MCP_JAR=\"$JADX_JAR\""
    echo "export REA_APKTOOL_COMMAND=\"$TOOLS_DIR/apktool\""
  } >> "$CLAUDE_ENV_FILE"
fi
