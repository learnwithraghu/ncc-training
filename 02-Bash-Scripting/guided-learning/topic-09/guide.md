# Topic 9: Reporting, Processes, and Email

**Time:** 20 minutes

## Goal
Build a Bash script that finds the top 10 processes and emails the report.

## Commands to Use
Copy this into the file with `vi` or `nano`, then run it.

```bash
cd ~/ncc-labs/day1
cat > top10_process_email.sh <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

TO_EMAIL="${1:?Usage: $0 recipient@example.com}"
FROM_EMAIL="${FROM_EMAIL:-server@example.com}"
SUBJECT="${SUBJECT:-Top 10 Processes Report}"

REPORT=$(ps -eo pid,ppid,user,%cpu,%mem,comm --sort=-%cpu | head -n 11)

BODY=$(cat <<EOM
Subject: ${SUBJECT}
To: ${TO_EMAIL}
From: ${FROM_EMAIL}
Content-Type: text/plain; charset=UTF-8

Top 10 Processes by CPU Usage

${REPORT}
EOM
)

if command -v sendmail >/dev/null 2>&1; then
  printf "%s\n" "$BODY" | sendmail -t
  echo "Email sent using sendmail."
else
  echo "sendmail not found."
  echo "On Alpine Linux, install a mail transfer agent such as postfix:"
  echo "  sudo apk add postfix"
  echo "Then enable and start it if needed."
  exit 1
fi
EOF
chmod +x top10_process_email.sh
./top10_process_email.sh recipient@example.com
```

## Guided Steps
1. Use `ps` to list running processes.
2. Sort by CPU usage and keep the top 10 rows.
3. Build an email body in a variable.
4. Send the message with `sendmail`.
5. If `sendmail` is missing on Alpine Linux, install a mail transfer agent first.

## Checkpoint
Why is `head -n 11` used instead of `head -n 10`?
