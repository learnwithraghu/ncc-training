# Lab 05 Steps

## Step 1: Inspect the source folder
Run:
```bash
cd ~/ncc-labs/day1/bash-lab-05
find source -maxdepth 1 -type f | sort
```
Explain which files should be included in the backup.

## Step 2: Open the script
Run:
```bash
cat backup.sh
```
Review the timestamp, output directory, and loop.

## Step 3: Run the automation
Run:
```bash
./backup.sh
```
Note the created backup path in the output.

## Step 4: Verify the backup
Run:
```bash
find backup -maxdepth 2 -type f | sort
```
Confirm that only `.txt` and `.log` files were copied.

## Step 5: Explain the workflow
Ask the learner to name the Bash features used in the script.

## Checkpoint
The learner should be able to describe how the script combines variables, loops, and command substitution.
