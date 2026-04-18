#!/bin/bash
# Resolve the repository root (works in Codespaces and locally)
REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

# Append current date and time to date.txt
echo "$(date '+%Y-%m-%d %H:%M:%S')" >> "$REPO_ROOT/date.txt"

# Run runner.py and log output with a timestamp
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
echo "[$TIMESTAMP] $(python "$REPO_ROOT/runner.py")" >> "$REPO_ROOT/runner.log"
