# Topic 13: subprocess and Shell Commands

**Time:** 20 minutes

## Goal
Run shell commands from Python.

## Commands to Use
```bash
cd ~/ncc-labs/day1
vi subprocess_demo.py
python3 subprocess_demo.py
```

## Guided Steps
1. Open `vi subprocess_demo.py` and add the script content below.
2. Import `subprocess`.
3. Run a shell command.
4. Capture the output.
5. Print the output to the screen.
6. Explain why `check=True` is useful.

## Checkpoint
When would you use `subprocess.run()` in a DevOps script?

## Script Content
```python
import subprocess

result = subprocess.run(['ls', '-la'], capture_output=True, text=True, check=True)
print(result.stdout)
```
