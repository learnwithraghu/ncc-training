# Lab 02: Variables and Data Processing

## Why this lab
Learners practice storing values, working with strings and numbers, and printing formatted output.

## Scenario details
The learner receives a small script that takes a name, service, and count value, then prints a useful summary message. The lab stays simple but builds the habit of turning input into output.

## Lab setup
- A starter Python file with variables or placeholders
- A few values the learner can update
- No external packages required

## Suggested engineer setup
```bash
mkdir -p ~/ncc-labs/day1/python-lab-02
cat > ~/ncc-labs/day1/python-lab-02/summary.py <<'EOF'
name = "Asha"
service = "web"
count = 3
print(f"{name} is reviewing {count} {service} servers")
EOF
```

## Success criteria
- Assign values to variables
- Use strings and integers
- Print formatted output with an f-string
