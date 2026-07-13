# Topic 10: Log Parsing Basics

**Time:** 20 minutes

## Goal
Read log lines and extract useful values.

## Commands to Use
```bash
cd ~/ncc-labs/day1
cat > sample.log << 'EOF'
2026-07-08 09:00:01 INFO Application started
2026-07-08 09:01:23 WARN Disk usage above 80%
2026-07-08 09:02:45 ERROR Failed to connect to database
EOF
cat > log_parse_basic.py << 'EOF'
with open('sample.log', 'r', encoding='utf-8') as file_handle:
    for line in file_handle:
        parts = line.split()
        print(parts[2], line.strip())
EOF
python3 log_parse_basic.py
```

## Guided Steps
1. Create a small sample log file.
2. Read it line by line.
3. Split each line into parts.
4. Print the log level and the original line.
5. Explain how this becomes the base of a parser.

## Checkpoint
What part of the line holds the log level in this sample?
