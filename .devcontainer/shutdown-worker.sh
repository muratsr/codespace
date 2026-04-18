#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$1"
REPO_ROOT="$2"
PID_FILE="$3"
MINUTES="$4"
DELAY_SECONDS="$5"

log() {
    echo "shutdown scheduler $(date '+%Y-%m-%d %H:%M:%S') $1" >> "$REPO_ROOT/date.txt"
}

trap 'rm -f "$PID_FILE"' EXIT

log "timer started for ${MINUTES} minutes"
sleep "$DELAY_SECONDS"

if python3 "$SCRIPT_DIR/stop_codespace.py"; then
    log "stop request sent"
else
    log "stop request failed"
fi
