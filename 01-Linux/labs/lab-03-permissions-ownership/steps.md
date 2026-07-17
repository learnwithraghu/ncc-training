# Lab 03 Steps

## Step 1: Inspect permissions
Run:
```bash
cd ~/ncc-labs/day1/permissions-lab
ls -l
```
Ask the learner to identify the script and the private file.

## Step 2: Try the script
Run:
```bash
./run-report.sh
```
The expected result is a permission error before the fix.

## Step 3: Make the script executable
Run:
```bash
chmod +x run-report.sh
ls -l run-report.sh
./run-report.sh
```
Explain that the execute bit is required for scripts.

## Step 4: Tighten the private file
Run:
```bash
chmod 600 private.txt
ls -l private.txt
```
Explain that only the owner should be able to read it.

## Step 5: Review the result
Run:
```bash
ls -l
```
Help the learner read the permission string from left to right.

## Step 6: Explain the fix
Have the learner say why one file needed `+x` and the other needed restricted access.

## Checkpoint
The learner should be able to read a permission string and apply a simple fix.
