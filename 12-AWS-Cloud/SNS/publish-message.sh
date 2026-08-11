#!/usr/bin/env bash
set -euo pipefail

TOPIC_ARN=${1:-}
SUBJECT=${2:-"SNS Test Message"}
MESSAGE=${3:-"Hello from SNS"}

if [ -z "$TOPIC_ARN" ]; then
  echo "Usage: $0 <topic-arn> [subject] [message]"
  exit 1
fi

aws sns publish \
  --topic-arn "$TOPIC_ARN" \
  --subject "$SUBJECT" \
  --message "$MESSAGE"
