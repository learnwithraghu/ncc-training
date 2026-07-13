# Topic 7: Command-Line Arguments

**Time:** 20 minutes

## Goal
Pass values into a Python script from the command line.

## Commands to Use
```bash
cd ~/ncc-labs/day1
vi args_demo.py
python3 args_demo.py apples bananas
```

## Guided Steps
1. Open `vi args_demo.py` and add the script content below.
2. Import `sys`.
3. Print the script name.
4. Print the list of arguments.
5. Run the script with one and two values.
6. Explain how `sys.argv` helps with automation.

## Checkpoint
What happens if you run the script with no extra arguments?

## Script Content
```python
import sys

print(f'Script name: {sys.argv[0]}')
print(f'Arguments: {sys.argv[1:]}')
```
