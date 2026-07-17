# Lab 04 Steps

## Step 1: Inspect the files
Run:
```bash
cd ~/ncc-labs/day1/bash-lab-04
ls files
```
Review the file list.

## Step 2: Open the loop script
Run:
```bash
cat count-files.sh
```
Explain how the loop walks through `files/*.txt`.

## Step 3: Run the script
Run:
```bash
./count-files.sh
```
Observe the repeated output for each file.

## Step 4: Modify the pattern
Run:
```bash
for file in files/*.txt; do echo "$file"; done
```
Show how Bash expands the pattern.

## Step 5: Add a second command
Run:
```bash
for file in files/*.txt; do echo "$file"; wc -l "$file"; done
```
Reinforce the repeatable processing pattern.

## Checkpoint
The learner should understand how loops automate repeated file operations.
