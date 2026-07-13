# Topic 19: Day 1 Orchestrator

**Time:** 20 minutes

## Goal
Combine Python scripts into one simple workflow.

## Commands to Use
```bash
cd ~/ncc-labs/day1
cat > run_day1.py << 'EOF'
import subprocess

steps = [
    ['python3', 'log_parser.py', 'sample.log'],
    ['python3', 'disk_report.py']
]

for step in steps:
    subprocess.run(step, check=True)

print('Day 1 Python workflow complete')
EOF
python3 run_day1.py
```

## Guided Steps
1. Create a small Python orchestrator.
2. Run two scripts in sequence.
3. Stop on errors with `check=True`.
4. Print a completion message.
5. Connect this idea to the Bash orchestrator from Day 1.

## Checkpoint
What is the benefit of running several Python tasks from one script?
