# Lab 05: Day 1 Orchestrator and Validation

## Why this lab
Learners bring Linux, Bash, and Python together in one small automation workflow.

## Scenario details
The learner is given a Bash launcher and a Python validation script. The launcher prepares input and the Python script checks a file or summarizes a folder so the learner sees the full workflow end to end.

## Lab setup
- A small folder of input files
- A Bash launcher script
- A Python validation or reporting script

## Suggested engineer setup
```bash
mkdir -p ~/ncc-labs/day1/python-lab-05/input ~/ncc-labs/day1/python-lab-05/output
printf 'alpha\n' > ~/ncc-labs/day1/python-lab-05/input/a.txt
printf 'beta\n' > ~/ncc-labs/day1/python-lab-05/input/b.txt
cat > ~/ncc-labs/day1/python-lab-05/report.py <<'EOF'
from pathlib import Path
files = list(Path("input").glob("*.txt"))
print(f"text files: {len(files)}")
EOF
cat > ~/ncc-labs/day1/python-lab-05/run_lab.sh <<'EOF'
#!/usr/bin/env bash
python3 report.py
EOF
chmod +x ~/ncc-labs/day1/python-lab-05/run_lab.sh
```

## Success criteria
- Run a Python script from a Bash wrapper
- Use `pathlib` or simple file matching
- Produce a small validation report
