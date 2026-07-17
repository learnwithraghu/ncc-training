# Lab 02: File and Directory Management

## Why this lab
Learners practice creating, copying, moving, renaming, and deleting files the way they will on real systems.

## Scenario details
The learner receives a workspace with incoming files, a backup area, and a cleanup task. They must organize the content so the directory tree ends in a known good state.

## Lab setup
- A working folder with sample files and folders
- Enough structure to copy, move, and clean up safely
- A reset path the engineer can rebuild quickly

## Suggested engineer setup
```bash
mkdir -p ~/ncc-labs/day1/file-mgmt/{incoming,backup,archive}
printf 'draft report\n' > ~/ncc-labs/day1/file-mgmt/incoming/report.txt
touch ~/ncc-labs/day1/file-mgmt/incoming/{draft1.txt,draft2.txt}
```

## Success criteria
- Create files and directories
- Copy and move content
- Remove files and empty folders correctly
