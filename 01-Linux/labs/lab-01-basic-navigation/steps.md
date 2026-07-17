# Lab 01 Steps

## Step 1: Confirm the starting point
Run:
```bash
pwd
```
Explain that this shows the current location in the filesystem.

## Step 2: Inspect what is available
Run:
```bash
ls
```
Then try:
```bash
ls -a
```
Point out the hidden `.lab-profile` file if it exists.

## Step 3: Enter the training workspace
Run:
```bash
cd ~/ncc-labs/day1/navigation
pwd
```
Confirm that the prompt now reflects the new location.

## Step 4: Explore nested folders
Run:
```bash
cd projects
ls
cd app
ls
```
This shows how to move deeper into the tree.

## Step 5: Move back out
Run:
```bash
cd ..
pwd
cd ..
pwd
```
Explain that `..` means the parent directory.

## Step 6: Return to the start
Run:
```bash
cd ~
pwd
```
End by returning to the home directory.

## Checkpoint
The learner should be able to explain where they are, how to move around, and how to return to the starting point.
