# Topic 9: Reporting and Log Analysis

**Time:** 20 minutes

## Goal
Create small reporting scripts and count values in log files.

## Commands to Use
```bash
cd ~/ncc-labs/day1
cat > count_errors.sh << 'EOF'
#!/bin/bash
LOG_FILE="$1"
echo "Log Analysis: $LOG_FILE"
echo "ERROR count: $(grep -c 'ERROR' "$LOG_FILE")"
echo "WARN count: $(grep -c 'WARN' "$LOG_FILE")"
EOF
chmod +x count_errors.sh
./count_errors.sh logs/error.log
```

## Guided Steps
1. Accept a log file as an argument.
2. Count lines containing `ERROR`.
3. Count lines containing `WARN`.
4. Print a short summary.
5. Run the script against your sample logs.

## Checkpoint
Why should you quote `"$LOG_FILE"` when using it in `grep`?
