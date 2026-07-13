# Topic 17: Log Parser Build

**Time:** 20 minutes

## Goal
Build a parser that counts log levels and lists errors.

## Commands to Use
```bash
cd ~/ncc-labs/day1
vi log_parser.py
python3 log_parser.py sample.log
```

## Guided Steps
1. Open `vi log_parser.py` and add the script content below.
2. Read the log file path from `sys.argv`.
2. Count log levels with `defaultdict`.
3. Collect error lines in a list.
4. Print a summary and the error details.
5. Explain how the parser fits the Day 1 workflow.

## Checkpoint
Why does `defaultdict(int)` make counting simpler?

## Script Content
```python
import sys
from collections import defaultdict

if len(sys.argv) < 2:
    print('Usage: python3 log_parser.py <logfile>')
    raise SystemExit(1)

counts = defaultdict(int)
errors = []

with open(sys.argv[1], 'r', encoding='utf-8') as file_handle:
    for line in file_handle:
        parts = line.strip().split()
        if len(parts) >= 3:
            level = parts[2]
            counts[level] += 1
            if level == 'ERROR':
                errors.append(line.strip())

print('Log Level Summary')
print('=================')
for level, count in sorted(counts.items()):
    print(f'{level}: {count}')

print('\nError Details')
print('=============')
for error in errors:
    print(error)
```
