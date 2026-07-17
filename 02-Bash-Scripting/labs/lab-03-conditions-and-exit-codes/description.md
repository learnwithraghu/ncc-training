# Lab 03: Conditions and Exit Codes

## Why this lab
Learners need to make scripts react to success and failure conditions.

## Scenario details
The learner is given a small validation script that checks whether a required file exists. They must test the script with both valid and invalid input and observe the exit codes.

## Lab setup
- A workspace with one required file and one missing file path
- A script that uses `if` and `exit`
- A clear pass/fail result

## Suggested engineer setup
```bash
mkdir -p ~/ncc-labs/day1/bash-lab-03
printf 'sample data\n' > ~/ncc-labs/day1/bash-lab-03/input.txt
cat > ~/ncc-labs/day1/bash-lab-03/check-file.sh <<'EOF'
#!/usr/bin/env bash
file="$1"
if [[ -f "$file" ]]; then
  echo "file exists"
  exit 0
else
  echo "file missing"
  exit 1
fi
EOF
chmod +x ~/ncc-labs/day1/bash-lab-03/check-file.sh
```

## Success criteria
- Use `if` statements
- Test file existence
- Observe exit codes `0` and `1`
