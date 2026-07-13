# Topic 3: Conditions and Exit Codes

**Time:** 20 minutes

## Goal
Use `if` statements and check command results.

## Commands to Use
```bash
cd ~/ncc-labs/day1
cat > check_number.sh << 'EOF'
#!/bin/bash
read -p "Enter a number: " NUM

if [ "$NUM" -gt 10 ]; then
  echo "Greater than 10"
elif [ "$NUM" -eq 10 ]; then
  echo "Exactly 10"
else
  echo "Less than 10"
fi
EOF
chmod +x check_number.sh
./check_number.sh
echo $?
```

## Guided Steps
1. Create a script that reads a number.
2. Compare the number with `if`, `elif`, and `else`.
3. Run the script with a few values.
4. Check the exit code with `echo $?`.
5. Explain what a zero exit code means.

## Checkpoint
When would you use a file test like `[ -f file.txt ]` instead of a number test?
