#!/usr/bin/env bash
set -euo pipefail

TARGET_CPU=${1:-80}
DURATION_SECONDS=${2:-300}
WORKERS=$(nproc)

if command -v stress-ng >/dev/null 2>&1; then
  echo "Using stress-ng to target ~${TARGET_CPU}% CPU for ${DURATION_SECONDS}s across ${WORKERS} workers..."
  stress-ng --cpu "${WORKERS}" --cpu-load "${TARGET_CPU}" --timeout "${DURATION_SECONDS}s"
  exit 0
fi

echo "stress-ng not found. Using a fallback load loop."
echo "This aims to target about ${TARGET_CPU}% CPU for ${DURATION_SECONDS}s."

pids=()
for _ in $(seq 1 "${WORKERS}"); do
  (
    end=$((SECONDS + DURATION_SECONDS))
    while [ "$SECONDS" -lt "$end" ]; do
      busy_end=$((SECONDS + 8))
      while [ "$SECONDS" -lt "$busy_end" ]; do :; done
      sleep_time=$(awk -v t="${TARGET_CPU}" 'BEGIN { printf "%.2f", (100 - t) / 100 }')
      sleep "$sleep_time"
    done
  ) &
  pids+=("$!")
done

for pid in "${pids[@]}"; do
  wait "$pid"
done

echo "Done."
