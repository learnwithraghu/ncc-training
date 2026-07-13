# Topic 7: Sample Files and Backup Setup

**Time:** 20 minutes

## Goal
Create the sample files used by the backup script.

## Commands to Use
```bash
cd ~/ncc-labs/day1
mkdir -p logs
echo "My study notes" > notes.txt
echo "Application started" > logs/app.log
echo "Error: disk full" > logs/error.log
echo "GET /home" > logs/access.log
ls -R
```

## Guided Steps
1. Make a `logs/` directory.
2. Create one text file in the working directory.
3. Create three log files in `logs/`.
4. List the folder tree.
5. Explain why these files are useful for a backup demo.

## Checkpoint
Why is it helpful to have both `.txt` files and `.log` files for the backup exercise?
