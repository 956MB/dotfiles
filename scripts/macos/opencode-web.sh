#!/bin/bash
set -euo pipefail

: "${OPENCODE_KEYCHAIN_SERVICE:=opencode-server}"
: "${OPENCODE_KEYCHAIN_ACCOUNT:=opencode}"
: "${OPENCODE_SERVER_USERNAME:=opencode}"
: "${OPENCODE_SERVER_PORT:=4096}"
: "${BROWSER:=false}"

OPENCODE_SERVER_PASSWORD="$(security find-generic-password -s "$OPENCODE_KEYCHAIN_SERVICE" -a "$OPENCODE_KEYCHAIN_ACCOUNT" -w 2>/dev/null || true)"
export OPENCODE_SERVER_PASSWORD OPENCODE_SERVER_USERNAME BROWSER

mkdir -p "$HOME/Library/Logs"

exec "$(command -v opencode)" web --port "$OPENCODE_SERVER_PORT" --hostname 127.0.0.1
