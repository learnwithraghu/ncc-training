# Day 1, Guide 6: Bash Loops, Functions, and Command Substitution

## Goal
Make scripts reusable and powerful using loops, functions, and command substitution.

## Time
Approximately **45 minutes**.

## Prerequisites
- Completion of [guide_01_basics.md](guide_01_basics.md)
- Working directory: `~/ncc-labs/day1/`

---

## 1. Command Substitution

Capture the output of a command and store it in a variable.

```bash
TODAY=$(date +%Y-%m-%d)
echo "Today is $TODAY"
```

Older syntax (still common):

```bash
TODAY=`date +%Y-%m-%d`
```

## 2. Loops

### Loop over a range

```bash
for i in {1..5}; do
    echo "Count: $i"
done
```

### Loop over files

```bash
for file in *.log; do
    echo "Found log file: $file"
done
```

### Loop over lines in a file

```bash
while read -r line; do
    echo "Line: $line"
done < sample.log
```

## 3. Functions

Functions make scripts modular and easier to read.

```bash
#!/bin/bash

greet() {
    echo "Hello, $1!"
}

greet "Alice"
greet "Bob"
```

`$1`, `$2`, etc. are function arguments.

---

## Hands-On: Build `backup.sh` Version 2

You will improve `backup.sh` so it:

1. Accepts a source directory as an argument
2. Backs up all `.txt` and `.log` files
3. Uses functions for setup and backup logic
4. Reports how many files were backed up

### Step 1: Create sample files

```bash
cd ~/ncc-labs/day1
mkdir -p logs
echo "Application started" > logs/app.log
echo "Error: disk full" > logs/error.log
echo "GET /home" > logs/access.log
echo "My study notes" > notes.txt
```

### Step 2: Rewrite `backup.sh`

```bash
cat > backup.sh << 'EOF'
#!/bin/bash
set -e

# Default source directory
SOURCE_DIR="${1:-$HOME/ncc-labs/day1}"
BACKUP_DIR="$SOURCE_DIR/backup"
DATE=$(date +%Y-%m-%d-%H%M%S)
FILE_COUNT=0

setup_backup_dir() {
    if [ ! -d "$BACKUP_DIR" ]; then
        mkdir -p "$BACKUP_DIR"
        echo "Created backup directory: $BACKUP_DIR"
    fi
}

backup_files() {
    for file in "$SOURCE_DIR"/*.txt "$SOURCE_DIR"/logs/*.log; do
        if [ -f "$file" ]; then
            filename=$(basename "$file")
            cp "$file" "$BACKUP_DIR/${filename}.${DATE}"
            echo "Backed up: $filename"
            FILE_COUNT=$((FILE_COUNT + 1))
        fi
    done
}

main() {
    echo "Starting backup from: $SOURCE_DIR"
    setup_backup_dir
    backup_files
    echo "Backup complete. $FILE_COUNT file(s) backed up at $DATE"
}

main
EOF
chmod +x backup.sh
```

### Step 3: Test it

```bash
./backup.sh
ls -la backup/
```

Try running it with a different directory:

```bash
./backup.sh /tmp
```

---

## Lab Challenge

Complete the exercises in [labs/lab_01_bash_challenge.md](labs/lab_01_bash_challenge.md).

---

## Check Your Understanding

1. What is the difference between `$(command)` and `` `command` ``?
2. How do you pass arguments to a Bash function?
3. What happens if you use `"$SOURCE_DIR"/*.txt` and no matching files exist?
4. Why is `set -e` useful in automation scripts?

---

## Next Step

Continue to [03-Python-Fundamentals](../03-Python-Fundamentals/README.md) to write a Python log parser that works with the files you just created.
