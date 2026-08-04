#!/usr/bin/env bash
set -euo pipefail

echo "Testing output..."
if grep -q "Hello from Jenkins Lab!" output.txt; then
  echo "Test passed!"
else
  echo "Test failed: expected greeting not found"
  exit 1
fi
