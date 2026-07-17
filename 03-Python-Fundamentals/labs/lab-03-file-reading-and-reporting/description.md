# Lab 03: File Reading and Reporting

## Why this lab
Learners need to read text files and turn the contents into a simple report.

## Scenario details
The learner is given a text file with a few lines of notes or records. They must open the file in Python, read the lines, and print a summary.

## Lab setup
- A small input text file
- A starter script that reads from disk
- A predictable output format

## Suggested engineer setup
```bash
mkdir -p ~/ncc-labs/day1/python-lab-03
cat > ~/ncc-labs/day1/python-lab-03/notes.txt <<'EOF'
server1 ok
server2 warn
server3 ok
EOF
cat > ~/ncc-labs/day1/python-lab-03/read_report.py <<'EOF'
with open("notes.txt") as f:
    lines = f.readlines()
print(f"total lines: {len(lines)}")
EOF
```

## Success criteria
- Open a file with `open()`
- Read lines from the file
- Print a basic report
