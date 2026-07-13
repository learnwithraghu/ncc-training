# Topic 2: Variables and Data Types

**Time:** 20 minutes

## Goal
Store values in variables and understand basic Python data types.

## Commands to Use
```bash
cd ~/ncc-labs/day1
cat > variables.py << 'EOF'
name = 'Alice'
age = 30
is_active = True
pi = 3.14

print(f'Name: {name}')
print(f'Age: {age}')
print(f'Active: {is_active}')
print(f'Pi: {pi}')
EOF
python3 variables.py
```

## Guided Steps
1. Create a script with string, integer, float, and boolean values.
2. Print each value with an f-string.
3. Change the values and run the script again.
4. Talk about how Python infers the type from the value.
5. Compare a Python variable with a Bash variable.

## Checkpoint
Which data type would you use for a log level like `INFO`?
