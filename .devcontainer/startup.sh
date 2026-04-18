#!/bin/bash
# Resolve the repository root (works in Codespaces and locally)
REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

# Append current date and time to date.txt
echo "startup.sh called $(date '+%Y-%m-%d %H:%M:%S')" >> "$REPO_ROOT/date.txt"

# Schedule an automatic Codespace shutdown 10 minutes after startup.
bash "$REPO_ROOT/.devcontainer/schedule-shutdown.sh" 2

# Run runner.py and log output with a timestamp
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
echo "startup.sh ran runner [$TIMESTAMP] $(python "$REPO_ROOT/runner.py")" >> "$REPO_ROOT/runner.log"
