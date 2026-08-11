#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

echo "Checking Python syntax..."
python3 -m py_compile app.py test_app.py

echo "Running flake8 lint..."
python3 -m flake8 app.py test_app.py --max-line-length=100

echo "Lint checks passed."
