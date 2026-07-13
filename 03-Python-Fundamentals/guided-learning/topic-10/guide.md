# Topic 10: Log Parsing Basics

**Time:** 20 minutes

## Goal
Read log lines and extract useful values.

## Commands to Use
```bash
cd ~/ncc-labs/day1
vi sample.log
vi log_parse_basic.py
python3 log_parse_basic.py
```

## Guided Steps
1. Open `vi sample.log` and add the sample log content below.
2. Open `vi log_parse_basic.py` and add the script content below.
3. Read it line by line.
4. Split each line into parts.
5. Print the log level and the original line.
6. Explain how this becomes the base of a parser.

## Checkpoint
What part of the line holds the log level in this sample?

## File Content
`sample.log`
```text
2026-07-08 09:00:01 INFO Application started
2026-07-08 09:01:23 WARN Disk usage above 80%
2026-07-08 09:02:45 ERROR Failed to connect to database
```

## Script Content
```python
with open('sample.log', 'r', encoding='utf-8') as file_handle:
    for line in file_handle:
        parts = line.split()
        print(parts[2], line.strip())
```
