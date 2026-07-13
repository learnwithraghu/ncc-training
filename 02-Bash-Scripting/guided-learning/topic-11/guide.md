# Topic 11: Script Arguments and Usage Hints

**Time:** 20 minutes

## Goal
Read command-line arguments and show helpful usage output.

## Commands to Use
```bash
cd ~/ncc-labs/day1
cat > args_demo.sh << 'EOF'
#!/bin/bash

if [ $# -lt 2 ]; then
  echo "Usage: $0 <first> <second>"
  exit 1
fi

echo "Script name: $0"
echo "First argument: $1"
echo "Second argument: $2"
EOF
chmod +x args_demo.sh
./args_demo.sh apple banana
```

## Guided Steps
1. Create a script that prints `$0`, `$1`, and `$2`.
2. Add a usage message for missing arguments.
3. Run the script with two sample arguments.
4. Try it again with only one argument.
5. Explain why usage hints help other users.

## Checkpoint
What does `$0` represent inside a Bash script?
