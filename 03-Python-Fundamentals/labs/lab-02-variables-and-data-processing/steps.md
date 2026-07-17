# Lab 02 Steps

## Step 1: Open the script
Run:
```bash
cd ~/ncc-labs/day1/python-lab-02
cat summary.py
```
Review the variable names and values.

## Step 2: Run the script
Run:
```bash
python3 summary.py
```
Observe the formatted output.

## Step 3: Change the values
Edit the file or run a quick one-liner:
```bash
python3 - <<'EOF'
name = "Ravi"
service = "api"
count = 5
print(f"{name} is reviewing {count} {service} servers")
EOF
```
Explain how variables affect the result.

## Step 4: Try a new message
Update the script so the sentence mentions a different team or count.

## Checkpoint
The learner should be able to use variables and f-strings to produce a custom message.
