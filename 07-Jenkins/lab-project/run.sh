#!/usr/bin/env bash
set -euo pipefail

echo "Running app..."
bash app.sh | tee output.txt
echo "Output saved to output.txt"
