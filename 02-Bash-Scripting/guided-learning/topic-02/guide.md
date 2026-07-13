# Topic 2: Variables and User Input

**Time:** 20 minutes

## Goal
Store values in variables and read input from the user.

## Commands to Use
```bash
cd ~/ncc-labs/day1
cat > greet.sh << 'EOF'
#!/bin/bash
read -p "Enter your name: " NAME
echo "Hello, $NAME"
EOF
chmod +x greet.sh
./greet.sh
```

## Guided Steps
1. Create a script called `greet.sh`.
2. Prompt the user for their name.
3. Store the response in a variable.
4. Print a greeting using the variable.
5. Try the script with different names.

## Example Script
```bash
#!/bin/bash
NAME="Alice"
echo "Hello, $NAME"
```

## Checkpoint
What happens if you leave spaces around the `=` sign when assigning a variable?
