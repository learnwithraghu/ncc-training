# Lab 04 Steps

## Step 1: Inspect the log
Run:
```bash
cd ~/ncc-labs/day1/log-filtering
cat app.log
```
Ask the learner to identify the error pattern.

## Step 2: Find errors
Run:
```bash
grep ERROR app.log
```
Then try:
```bash
grep -n ERROR app.log
```

## Step 3: Add context or count matches
Run one of:
```bash
grep -c ERROR app.log
```
or
```bash
grep -n -C 1 ERROR app.log
```
Explain why context is useful in troubleshooting.

## Step 4: Save filtered output
Run:
```bash
grep ERROR app.log > output/errors.txt
```
Verify the file was created.

## Step 5: Combine commands with a pipe
Run:
```bash
cat app.log | grep ERROR
```
Explain that pipes pass output from one command into another.

## Step 6: Review the saved report
Run:
```bash
cat output/errors.txt
```
Confirm that only the desired lines were stored.

## Checkpoint
The learner should be able to reduce a noisy file into a useful report.
