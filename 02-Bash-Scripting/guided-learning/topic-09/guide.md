# Topic 9: Reporting, Processes, and Email

**Time:** 20 minutes

## Goal
Write a Bash script that takes an email address and sends a hello email.

## Script
Create the script directly:

```bash
cd ~/ncc-labs/day1
vi top10_process_email.sh
```

Paste this content:

```bash
#!/usr/bin/env bash
set -euo pipefail

TO_EMAIL="${1:?Usage: $0 recipient@example.com}"
FROM_EMAIL="${FROM_EMAIL:-server@example.com}"
SUBJECT="${SUBJECT:-Hello}"

{
  echo "Subject: ${SUBJECT}"
  echo "To: ${TO_EMAIL}"
  echo "From: ${FROM_EMAIL}"
  echo "Content-Type: text/plain; charset=UTF-8"
  echo
  echo "Hello"
} | sendmail -t

echo "Hello email sent to ${TO_EMAIL}."
```

Make it executable and run it:

```bash
chmod +x top10_process_email.sh
./top10_process_email.sh alice@example.com
```

## Install on Alpine Linux
If `sendmail` is missing, install a mail transfer agent first:

```bash
sudo apk update
sudo apk add postfix
sudo rc-update add postfix default
sudo rc-service postfix start
```

Check that `sendmail` exists after installation:

```bash
command -v sendmail
```

## Guided Steps
1. Accept an email address as script input.
2. Create a short hello message.
3. Pipe the message to `sendmail`.
4. Install `postfix` on Alpine Linux if `sendmail` is not available.

## Checkpoint
Why is the email address passed as the first argument to the script?
