# Day 1, Guide 5: Bash Scripting Basics

## Goal
Write your first shell scripts to automate tasks using variables, user input, conditions, and exit codes.

## Time
Approximately **60 minutes**.

## Prerequisites
- Completion of [01-Linux](../01-Linux/README.md) guides
- Working directory: `~/ncc-labs/day1/`

---

## 1. What is a Script?

A script is a text file containing multiple commands that can be executed together.

**Shebang:** The first line tells the system which interpreter to use.

```bash
#!/bin/bash
```

## 2. Your First Script

Create `hello.sh`:

```bash
#!/bin/bash
echo "Hello, World!"
```

Make it executable and run it:

```bash
chmod +x hello.sh
./hello.sh
```

> **Why `./`?** The current directory is usually not in the system `PATH`, so you must tell the shell exactly where the script is.

## 3. Variables

```bash
#!/bin/bash
NAME="Alice"            # No spaces around =
echo "Hello, $NAME"
echo "Hello, ${NAME}"   # Safer when concatenating
```

**Good practice:** Quote variables to handle spaces.

```bash
FILE="my document.txt"
cp "$FILE" /tmp
```

## 4. User Input

```bash
#!/bin/bash
echo "What is your name?"
read USER_NAME
echo "Nice to meet you, $USER_NAME"
```

You can also read with a prompt:

```bash
read -p "Enter backup directory name: " BACKUP_DIR
```

## 5. Conditions (`if/else`)

```bash
#!/bin/bash
read -p "Enter a number: " NUM

if [ "$NUM" -gt 10 ]; then
    echo "The number is greater than 10."
elif [ "$NUM" -eq 10 ]; then
    echo "The number is exactly 10."
else
    echo "The number is less than 10."
fi
```

Common numeric tests:

| Test | Meaning |
|------|---------|
| `-eq` | Equal to |
| `-ne` | Not equal to |
| `-gt` | Greater than |
| `-lt` | Less than |
| `-ge` | Greater than or equal |
| `-le` | Less than or equal |

File tests:

```bash
if [ -d "backup" ]; then
    echo "Backup directory exists"
fi

if [ -f "app.log" ]; then
    echo "Log file exists"
fi
```

## 6. Exit Codes

Every command returns an exit code:

- `0` = success
- Non-zero = failure

```bash
mkdir /root/test 2>/dev/null
echo $?   # Likely non-zero (permission denied)
```

Use `set -e` at the top of a script to make it stop on the first error:

```bash
#!/bin/bash
set -e
```

---

## Hands-On: Build `backup.sh` Version 1

You will create a script that backs up files from `~/ncc-labs/day1/` into a timestamped backup directory.

### Step 1: Create the script

```bash
cd ~/ncc-labs/day1
cat > backup.sh << 'EOF'
#!/bin/bash
set -e

# Configuration
SOURCE_DIR="$HOME/ncc-labs/day1"
BACKUP_DIR="$HOME/ncc-labs/day1/backup"
DATE=$(date +%Y-%m-%d-%H%M%S)

# Create backup directory if it doesn't exist
if [ ! -d "$BACKUP_DIR" ]; then
    mkdir -p "$BACKUP_DIR"
    echo "Created backup directory: $BACKUP_DIR"
fi

# Copy notes.txt if it exists
if [ -f "$SOURCE_DIR/notes.txt" ]; then
    cp "$SOURCE_DIR/notes.txt" "$BACKUP_DIR/notes.txt.$DATE"
    echo "Backed up notes.txt"
else
    echo "No notes.txt found to back up"
fi

echo "Backup completed at $DATE"
EOF
chmod +x backup.sh
```

### Step 2: Test it

```bash
./backup.sh
ls -la backup/
```

Run it again and notice how each backup gets a unique timestamp.

---

## Check Your Understanding

1. What does `#!/bin/bash` do?
2. Why should you quote variables like `"$FILE"`?
3. What exit code does a successful command return?
4. How do you make a script executable?

---

## Next Step

Continue to [guide_02_loops_and_functions.md](guide_02_loops_and_functions.md) to make `backup.sh` more powerful with loops and functions.
