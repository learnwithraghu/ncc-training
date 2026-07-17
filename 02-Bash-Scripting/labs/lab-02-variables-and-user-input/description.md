# Lab 02: Variables and User Input

## Why this lab
Learners practice storing values in variables and collecting input from the user.

## Scenario details
The learner is given a small script that asks for a name and a project code, then prints a personalized message. They must complete or run the script and verify the output changes with input.

## Lab setup
- A partially completed greeting script or starter file
- A workspace with a simple input/output exercise
- No external dependencies

## Suggested engineer setup
```bash
mkdir -p ~/ncc-labs/day1/bash-lab-02
cat > ~/ncc-labs/day1/bash-lab-02/greet.sh <<'EOF'
#!/usr/bin/env bash
read -p "Enter your name: " name
read -p "Enter project code: " code
echo "Hello $name, welcome to project $code"
EOF
chmod +x ~/ncc-labs/day1/bash-lab-02/greet.sh
```

## Success criteria
- Read user input with `read`
- Store values in variables
- Print a personalized message
