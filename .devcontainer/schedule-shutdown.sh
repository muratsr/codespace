#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
PID_FILE="/tmp/codespace-auto-shutdown.pid"
MINUTES="${1:-10}"
DELAY_SECONDS=$((MINUTES * 60))

log() {
    echo "shutdown scheduler $(date '+%Y-%m-%d %H:%M:%S') $1" >> "$REPO_ROOT/date.txt"
}

log "requested delay minutes=$MINUTES seconds=$DELAY_SECONDS"

if [[ -f "$PID_FILE" ]]; then
    existing_pid="$(cat "$PID_FILE")"
    if [[ -n "$existing_pid" ]] && kill -0 "$existing_pid" 2>/dev/null; then
        log "timer already active with pid $existing_pid"
        exit 0
    fi

    rm -f "$PID_FILE"
    log "removed stale pid file"
fi

nohup setsid bash "$SCRIPT_DIR/shutdown-worker.sh" \
    "$SCRIPT_DIR" "$REPO_ROOT" "$PID_FILE" "$MINUTES" "$DELAY_SECONDS" \
    </dev/null >/tmp/codespace-auto-shutdown.log 2>&1 &

shutdown_pid=$!
echo "$shutdown_pid" > "$PID_FILE"
log "background pid $shutdown_pid log_file=/tmp/codespace-auto-shutdown.log"