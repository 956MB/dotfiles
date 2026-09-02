#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

ghostty_bin="$(command -v ghostty || true)"
fish_bin="$(command -v fish || true)"
if [[ -z "$ghostty_bin" || -z "$fish_bin" ]]; then
    echo "linecast-weather: ghostty and fish must be in PATH" >&2
    exit 1
fi

case "$(uname)" in
Darwin)
    app_path="$(dirname "$(dirname "$(dirname "$ghostty_bin")")")"
    open -na "$app_path" --args \
        --background=000000 \
        --background-opacity=1.0 \
        --maximize=true \
        -e fish -lc "sleep 0.25; osascript '$SCRIPT_DIR/linecast-weather.applescript'"
    ;;
*)
    "$ghostty_bin" \
        --background=000000 \
        --background-opacity=1.0 \
        --maximize=true \
        -e "$fish_bin" -lc "zellij attach linecast-weather 2>/dev/null; or zellij --session linecast-weather --layout '$SCRIPT_DIR/linecast.kdl'"
    ;;
esac
