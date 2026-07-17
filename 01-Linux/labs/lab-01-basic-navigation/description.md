# Lab 01: Basic Linux Navigation

## Why this lab
Learners need to get comfortable moving around the filesystem before they can do anything else in Linux.

## Scenario details
The learner starts in a clean workspace with a small folder tree already prepared. Their job is to locate the training area, inspect what is available, and move between directories without losing their place.

## Lab setup
- A small training workspace is mounted for the learner
- A few folders and files are already present
- The learner starts in the home directory or a defined lab directory

## Suggested engineer setup
```bash
mkdir -p ~/ncc-labs/day1/navigation/{projects/app,notes}
touch ~/ncc-labs/day1/navigation/projects/app/README.md
touch ~/ncc-labs/day1/navigation/.lab-profile
```

## Success criteria
- Use `pwd`, `ls`, and `cd` confidently
- Move into and out of directories
- Identify the current location in the filesystem
