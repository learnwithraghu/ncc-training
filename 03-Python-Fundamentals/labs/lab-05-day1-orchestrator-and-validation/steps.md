# Lab 05 Steps

## Step 1: Inspect the folder
Run:
```bash
cd ~/ncc-labs/day1/python-lab-05
find . -maxdepth 2 -type f | sort
```
Review the input, output, and scripts.

## Step 2: Open the Python script
Run:
```bash
cat report.py
```
Explain how `Path.glob()` finds matching files.

## Step 3: Run the Python script directly
Run:
```bash
python3 report.py
```
Observe the number of `.txt` files.

## Step 4: Run the Bash launcher
Run:
```bash
./run_lab.sh
```
Show how Bash can orchestrate Python.

## Step 5: Make a small change
Add another `.txt` file and rerun the scripts.

## Checkpoint
The learner should understand how Bash can launch Python and how Python can validate workspace state.
