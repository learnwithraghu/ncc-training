# Lab 02 Steps

## Step 1: Inspect the workspace
Run:
```bash
cd ~/ncc-labs/day1/file-mgmt
ls
```
Review the incoming, backup, and archive folders.

## Step 2: Create a working folder
Run:
```bash
mkdir -p reports
```
Explain that `mkdir -p` creates the directory if it does not already exist.

## Step 3: Create a few files
Run:
```bash
touch reports/january.txt reports/february.txt
printf 'status: draft\n' > reports/draft.txt
```
This gives the learner files to manage.

## Step 4: Copy a file to backup
Run:
```bash
cp reports/january.txt backup/
```
Then verify:
```bash
ls backup
```

## Step 5: Move and rename a file
Run:
```bash
mv reports/february.txt archive/february-archive.txt
```
Explain that `mv` can move and rename in one command.

## Step 6: Remove the unnecessary file
Run:
```bash
rm reports/draft.txt
```
Warn that `rm` removes the file immediately.

## Step 7: Verify the final structure
Run:
```bash
find . -maxdepth 2 -type f | sort
```
Check that the files are in the expected places.

## Checkpoint
The learner should understand the difference between create, copy, move, rename, and delete.
