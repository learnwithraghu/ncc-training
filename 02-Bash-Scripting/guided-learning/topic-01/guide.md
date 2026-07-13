# Topic 1: Script Basics and Shebang

**Time:** 20 minutes

## Goal
Create and run your first Bash script.

## Commands to Use
```bash
cd ~/ncc-labs/day1
touch hello.sh
chmod +x hello.sh
./hello.sh
```

## Guided Steps
1. Create `hello.sh`.
2. Add a shebang line at the top of the file.
3. Print a greeting with `echo`.
4. Make the script executable.
5. Run it with `./hello.sh`.

## Example Script
```bash
#!/bin/bash
echo "Hello, Bash!"
```

## Checkpoint
Why do you need `./` before the script name?
