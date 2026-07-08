# Day 1, Guide 8: Python + Bash Automation Lab

## Goal
Combine Python and Bash into a single automation workflow that runs your Day 1 toolkit.

## Time
Approximately **60 minutes**.

## Prerequisites

- Completion of [guide_01_python_for_devops.md](guide_01_python_for_devops.md)
- Working `backup.sh` from [02-Bash-Scripting](../02-Bash-Scripting/README.md)
- Working directory: `~/ncc-labs/day1/`

---

## 1. Calling Python from Bash

You can run Python from a Bash script just like any other command:

```bash
#!/bin/bash
python3 log_parser.py sample.log > report.txt
```

## 2. Calling Bash from Python

Python can run shell commands using the `subprocess` module:

```python
import subprocess

result = subprocess.run(["ls", "-la"], capture_output=True, text=True)
print(result.stdout)
```

## 3. Building a Daily Report

You will create a script that:

1. Runs `backup.sh` to back up files
2. Runs `log_parser.py` to analyze logs
3. Combines the results into a single `daily_report.txt`

---

## Hands-On: Build `run_day1.sh`

### Step 1: Create the orchestrator script

```bash
cat > ~/ncc-labs/day1/run_day1.sh << 'EOF'
#!/bin/bash
set -e

WORK_DIR="$HOME/ncc-labs/day1"
REPORT_FILE="$WORK_DIR/daily_report.txt"
DATE=$(date +"%Y-%m-%d %H:%M:%S")

cd "$WORK_DIR"

# Clear previous report
> "$REPORT_FILE"

{
    echo "Daily DevOps Report"
    echo "==================="
    echo "Generated: $DATE"
    echo "Hostname: $(hostname)"
    echo "User: $(whoami)"
    echo ""

    echo "Step 1: Running backup"
    echo "----------------------"
    ./backup.sh
    echo ""

    echo "Step 2: Analyzing logs"
    echo "----------------------"
    python3 log_parser.py sample.log
    echo ""

    echo "Step 3: File listing"
    echo "--------------------"
    ls -la "$WORK_DIR"

} >> "$REPORT_FILE"

echo "Report generated: $REPORT_FILE"
cat "$REPORT_FILE"
EOF
chmod +x ~/ncc-labs/day1/run_day1.sh
```

### Step 2: Run the orchestrator

```bash
cd ~/ncc-labs/day1
./run_day1.sh
```

You should see a combined report showing backup output, log analysis, and file listing.

---

## Hands-On: Extend `log_parser.py` to Write a Report

Modify `log_parser.py` so it can write its output directly to a file.

Add a `--output` argument:

```python
import argparse

parser = argparse.ArgumentParser(description="Parse log files")
parser.add_argument("logfile", help="Path to log file")
parser.add_argument("--output", "-o", help="Output report file")
args = parser.parse_args()

# ... existing parsing logic ...

if args.output:
    with open(args.output, "w") as file:
        file.write(report_text)
else:
    print(report_text)
```

Then update `run_day1.sh` to use:

```bash
python3 log_parser.py sample.log --output log_report.txt
```

---

## Lab Challenge

Complete the exercises in [labs/lab_01_python_challenge.md](labs/lab_01_python_challenge.md).

---

## Day 1 Completion Checklist

By the end of this guide, your `~/ncc-labs/day1/` folder should contain:

- [ ] `backup.sh` — backs up `.txt` and `.log` files
- [ ] `log_parser.py` — analyzes log levels and errors
- [ ] `run_day1.sh` — orchestrates backup + log analysis
- [ ] `sample.log` — sample log data
- [ ] `daily_report.txt` — generated report
- [ ] `logs/` directory with sample log files
- [ ] `backup/` directory with timestamped backups

On **Day 2**, you will initialize a Git repository in `~/ncc-labs/` and commit this `day1/` folder to GitHub.

---

## Check Your Understanding

1. How do you run a Python script from inside a Bash script?
2. What does `set -e` do in `run_day1.sh`?
3. Why is it useful to have one orchestrator script instead of running commands manually?
4. What files should be included when you commit this folder to Git?
