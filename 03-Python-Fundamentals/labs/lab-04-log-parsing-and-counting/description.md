# Lab 04: Log Parsing and Counting

## Why this lab
Learners start working with realistic log data and counting useful events.

## Scenario details
The learner receives a small application log containing info, warning, and error lines. Their job is to parse the file and count the important events.

## Lab setup
- A log file with repeated message types
- A starter parser script
- A clear counting target such as `ERROR` lines

## Suggested engineer setup
```bash
mkdir -p ~/ncc-labs/day1/python-lab-04
cat > ~/ncc-labs/day1/python-lab-04/app.log <<'EOF'
INFO service started
WARN retry
ERROR database unavailable
INFO request complete
ERROR timeout
EOF
cat > ~/ncc-labs/day1/python-lab-04/count_errors.py <<'EOF'
count = 0
with open("app.log") as f:
    for line in f:
        if "ERROR" in line:
            count += 1
print(f"error count: {count}")
EOF
```

## Success criteria
- Loop through file lines
- Match a string in each line
- Count matching records
