# Lab 04 Steps

## Step 1: Inspect the log
Run:
```bash
cd ~/ncc-labs/day1/python-lab-04
cat app.log
```
Identify the repeated message types.

## Step 2: Open the parser
Run:
```bash
cat count_errors.py
```
Review the loop and counter.

## Step 3: Run the script
Run:
```bash
python3 count_errors.py
```
Check the error count.

## Step 4: Improve the parser
Modify the script so it also counts `WARN` lines or prints the matching lines.

## Checkpoint
The learner should be able to scan log lines and count a target event.
