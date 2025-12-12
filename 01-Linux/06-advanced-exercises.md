# Module 4: Advanced Exercises (15 Minutes)

## Goal
Apply what you've learned to solve real-world problems using loops and more complex logic.

## 1. Loops
Loops allow you to repeat actions.

### `for` Loop
```bash
#!/bin/bash
for i in {1..5}; do
    echo "Count: $i"
done
```

### Loop through files
```bash
#!/bin/bash
for file in *.txt; do
    echo "Found text file: $file"
done
```

## 2. Real-World Scenario: Log Backup Script
Let's create a script that simulates backing up log files.

**Task:**
1.  Create a directory called `logs`.
2.  Create dummy log files: `app.log`, `error.log`, `access.log`.
3.  Write a script `backup_logs.sh` that:
    *   Creates a `backup` directory if it doesn't exist.
    *   Copies all `.log` files to the `backup` directory.
    *   Appends the current date to the backup filenames (e.g., `app.log` -> `app.log.2023-10-27`).

**Solution:**
```bash
#!/bin/bash

# Create backup dir
mkdir -p backup

# Get current date
DATE=$(date +%Y-%m-%d)

for file in *.log; do
    echo "Backing up $file..."
    cp "$file" "backup/$file.$DATE"
done

echo "Backup complete!"
```

## Hands-on Exercise 4
1.  Implement the `backup_logs.sh` script above.
2.  Run it and verify the contents of the `backup` folder.
3.  **Challenge:** Modify the script to *move* the files instead of copying them, effectively "archiving" them.
