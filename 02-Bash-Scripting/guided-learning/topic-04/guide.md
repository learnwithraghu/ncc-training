# Topic 4: Command Substitution and Quoting

**Time:** 20 minutes

## Goal
Capture command output and quote variables safely.

## Commands to Use
```bash
cd ~/ncc-labs/day1
TODAY=$(date +%Y-%m-%d)
echo "Today is $TODAY"
FILE="my document.txt"
cp "$FILE" /tmp 2>/dev/null
```

## Guided Steps
1. Capture the output of `date` in a variable.
2. Print the stored value.
3. Create a variable with a space in the value.
4. Quote the variable when using it in a command.
5. Compare `$()` with backticks if you have seen both.

## Example Script
```bash
#!/bin/bash
TODAY=$(date +%Y-%m-%d)
echo "Today is $TODAY"
```

## Checkpoint
Why is quoting `"$FILE"` safer than using `$FILE` alone?
