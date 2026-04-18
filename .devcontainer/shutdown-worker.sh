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

cleanup() {
    exit_code="$1"
    log "worker exiting pid=$$ exit_code=$exit_code"
    rm -f "$PID_FILE"
}

trap 'cleanup "$?"' EXIT

log "timer started for ${MINUTES} minutes pid=$$ ppid=$PPID"
sleep "$DELAY_SECONDS"
log "sleep complete after ${DELAY_SECONDS} seconds"

stop_output="$(python3 "$SCRIPT_DIR/stop_codespace.py" 2>&1)"
stop_status=$?

while IFS= read -r line; do
    [[ -n "$line" ]] && log "stop_codespace.py $line"
done <<< "$stop_output"

if [[ $stop_status -eq 0 ]]; then
    log "stop request sent"
else
    log "stop request failed exit_code=$stop_status"
fi
