# Topic 13: subprocess and Shell Commands

**Time:** 20 minutes

## Goal
Run shell commands from Python.

## Commands to Use
```bash
cd ~/ncc-labs/day1
cat > subprocess_demo.py << 'EOF'
import subprocess

result = subprocess.run(['ls', '-la'], capture_output=True, text=True, check=True)
print(result.stdout)
EOF
python3 subprocess_demo.py
```

## Guided Steps
1. Import `subprocess`.
2. Run a shell command.
3. Capture the output.
4. Print the output to the screen.
5. Explain why `check=True` is useful.

## Checkpoint
When would you use `subprocess.run()` in a DevOps script?
