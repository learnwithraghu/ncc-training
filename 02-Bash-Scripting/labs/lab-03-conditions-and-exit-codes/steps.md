# Lab 03 Steps

## Step 1: Inspect the validation script
Run:
```bash
cd ~/ncc-labs/day1/bash-lab-03
cat check-file.sh
```
Explain the `if`, `then`, and `exit` lines.

## Step 2: Test the valid path
Run:
```bash
./check-file.sh input.txt
echo $?
```
Point out the success message and exit code `0`.

## Step 3: Test the invalid path
Run:
```bash
./check-file.sh missing.txt
echo $?
```
Point out the failure message and exit code `1`.

## Step 4: Explain the branch logic
Ask the learner what changes between the two runs and why.

## Checkpoint
The learner should understand how Bash conditions control script flow and exit status.
