# Lab 01: Script Basics and Execution

## Why this lab
Learners need to understand how Bash scripts are created, marked executable, and run from the command line.

## Scenario details
The learner receives a simple script workspace with one script that does not run yet because it is missing the execute bit. They must inspect the file, fix permissions, and run it successfully.

## Lab setup
- A Bash script that prints a short message
- The script starts without execute permission
- A safe workspace for basic script execution

## Suggested engineer setup
```bash
mkdir -p ~/ncc-labs/day1/bash-lab-01
cat > ~/ncc-labs/day1/bash-lab-01/hello.sh <<'EOF'
#!/usr/bin/env bash
echo "hello from bash"
EOF
chmod 644 ~/ncc-labs/day1/bash-lab-01/hello.sh
```

## Success criteria
- Identify the shebang
- Make the script executable
- Run the script from the terminal
