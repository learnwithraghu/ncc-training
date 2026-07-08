# Day 1, Guide 7: Python Fundamentals for DevOps

## Goal
Learn enough Python to read files, process text, and automate small DevOps tasks.

## Time
Approximately **75 minutes**.

## Prerequisites

- Python 3 installed (`python3 --version`)
- Working directory: `~/ncc-labs/day1/`

---

## 1. Why Python for DevOps?

Python is one of the most popular languages in DevOps because it is:

- Easy to read and write
- Available on most Linux systems
- Supported by huge libraries for cloud, containers, and CI/CD

DevOps engineers use Python for:

- Log analysis and monitoring
- Automating repetitive tasks
- Writing deployment scripts
- Interacting with APIs (AWS, Kubernetes, GitHub)

## 2. Your First Python Script

Create `hello.py`:

```python
#!/usr/bin/env python3
print("Hello from Python!")
```

Run it:

```bash
python3 hello.py
```

## 3. Variables and Data Types

```python
name = "Alice"          # string
age = 30                # integer
pi = 3.14159            # float
is_active = True        # boolean

print(f"Name: {name}, Age: {age}, Pi: {pi}")
```

## 4. Lists and Loops

```python
servers = ["web-01", "web-02", "db-01"]

for server in servers:
    print(f"Checking {server}...")
```

## 5. Conditionals

```python
status_code = 500

if status_code >= 500:
    print("Server error!")
elif status_code >= 400:
    print("Client error!")
else:
    print("OK")
```

## 6. Reading Files

```python
with open("sample.log", "r") as file:
    content = file.read()
    print(content)
```

Read line by line:

```python
with open("sample.log", "r") as file:
    for line in file:
        print(line.strip())
```

## 7. Writing Files

```python
with open("report.txt", "w") as file:
    file.write("Daily Report\n")
    file.write("============\n")
```

---

## Hands-On: Build `log_parser.py`

You will create a Python script that reads a log file and counts how many times each log level appears.

### Step 1: Get the sample log file

Copy the sample log file into your workspace:

```bash
cp /workspaces/ncc-training/03-Python-Fundamentals/labs/sample.log ~/ncc-labs/day1/sample.log
```

Or create your own:

```bash
cat > ~/ncc-labs/day1/sample.log << 'EOF'
2026-07-08 09:00:01 INFO Application started
2026-07-08 09:01:23 WARN Disk usage above 80%
2026-07-08 09:02:45 ERROR Failed to connect to database
2026-07-08 09:03:10 INFO User logged in
2026-07-08 09:04:55 ERROR Timeout while fetching data
2026-07-08 09:05:30 WARN Memory usage high
2026-07-08 09:06:12 INFO Scheduled job completed
2026-07-08 09:07:44 ERROR Database connection lost
EOF
```

### Step 2: Create `log_parser.py`

```bash
cat > ~/ncc-labs/day1/log_parser.py << 'EOF'
#!/usr/bin/env python3
import sys
from collections import defaultdict

def parse_log_file(filepath):
    counts = defaultdict(int)
    errors = []

    with open(filepath, "r") as file:
        for line in file:
            line = line.strip()
            if not line:
                continue

            parts = line.split()
            if len(parts) >= 3:
                level = parts[2]
                counts[level] += 1

                if level == "ERROR":
                    errors.append(line)

    return counts, errors

def main():
    if len(sys.argv) < 2:
        print("Usage: python3 log_parser.py <logfile>")
        sys.exit(1)

    log_file = sys.argv[1]
    counts, errors = parse_log_file(log_file)

    print("Log Level Summary")
    print("=================")
    for level, count in sorted(counts.items()):
        print(f"{level}: {count}")

    print("\nError Details")
    print("=============")
    if errors:
        for error in errors:
            print(error)
    else:
        print("No errors found.")

if __name__ == "__main__":
    main()
EOF
chmod +x ~/ncc-labs/day1/log_parser.py
```

### Step 3: Run it

```bash
cd ~/ncc-labs/day1
python3 log_parser.py sample.log
```

Expected output:

```
Log Level Summary
=================
ERROR: 3
INFO: 3
WARN: 2

Error Details
=============
2026-07-08 09:02:45 ERROR Failed to connect to database
2026-07-08 09:04:55 ERROR Timeout while fetching data
2026-07-08 09:07:44 ERROR Database connection lost
```

---

## Check Your Understanding

1. What does `with open(...) as file:` do?
2. How do you run a Python script from the terminal?
3. What is the purpose of `sys.argv`?
4. Why is `defaultdict` useful for counting?

---

## Next Step

Continue to [guide_02_python_automation_lab.md](guide_02_python_automation_lab.md) to combine Python with your Bash scripts.
