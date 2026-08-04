#!/usr/bin/env bash
set -euo pipefail

BUILD_ID="${BUILD_NUMBER:-local}"
echo "Hello from Jenkins Lab!"
echo "Build: ${BUILD_ID}"
echo "Version: $(cat VERSION)"
