# Topic 7: Command-Line Arguments

**Time:** 20 minutes

## Goal
Pass values into a Python script from the command line.

## Commands to Use
```bash
cd ~/ncc-labs/day1
cat > args_demo.py << 'EOF'
import sys

print(f'Script name: {sys.argv[0]}')
print(f'Arguments: {sys.argv[1:]}')
EOF
python3 args_demo.py apples bananas
```

## Guided Steps
1. Import `sys`.
2. Print the script name.
3. Print the list of arguments.
4. Run the script with one and two values.
5. Explain how `sys.argv` helps with automation.

## Checkpoint
What happens if you run the script with no extra arguments?
