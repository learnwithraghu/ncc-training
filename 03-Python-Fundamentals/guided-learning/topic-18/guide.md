# Topic 18: Disk Usage Reporting

**Time:** 20 minutes

## Goal
Run a shell command from Python and filter the output.

## Commands to Use
```bash
cd ~/ncc-labs/day1
cat > disk_report.py << 'EOF'
import subprocess

result = subprocess.run(['df', '-h'], capture_output=True, text=True, check=True)
print('Filesystems above 50% usage:')

for line in result.stdout.splitlines()[1:]:
    parts = line.split()
    if len(parts) >= 5 and parts[4].endswith('%'):
        usage = int(parts[4].rstrip('%'))
        if usage > 50:
            print(line)
EOF
python3 disk_report.py
```

## Guided Steps
1. Run `df -h` from Python.
2. Split the output into lines.
3. Skip the header line.
4. Print filesystems above 50% usage.
5. Explain why this is useful for monitoring.

## Checkpoint
Why would a Python script be useful here instead of manual checking?
