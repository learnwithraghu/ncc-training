# Bash Scripting Lab Challenge

## Goal
Practice Bash scripting by solving real-world automation tasks.

## Setup

All work happens in `~/ncc-labs/day1/`.

```bash
cd ~/ncc-labs/day1
```

---

## Challenge 1: System Info Reporter

Create a script called `system_info.sh` that prints:

1. Current date and time
2. Current user
3. Hostname
4. Current working directory
5. Number of files in the current directory

Example output:

```
System Information Report
=========================
Date: 2026-07-08 10:30:00
User: student
Hostname: lab-machine
Directory: /home/student/ncc-labs/day1
File count: 12
```

### Hints

- Use `date`, `whoami`, `hostname`, `pwd`
- Use `ls | wc -l` to count files

---

## Challenge 2: Log Analyzer

Create a script called `count_errors.sh` that:

1. Accepts a log file path as an argument
2. Counts how many lines contain the word `ERROR`
3. Counts how many lines contain the word `WARN`
4. Prints a summary

Example:

```bash
./count_errors.sh logs/error.log
```

Output:

```
Log Analysis: logs/error.log
ERROR count: 3
WARN count: 1
```

### Hints

- Use `grep -c "ERROR" "$1"`
- Remember to quote the file path

---

## Challenge 3: Archive Old Backups

Create a script called `archive_old.sh` that:

1. Looks in the `backup/` directory
2. Finds backup files older than 1 minute
3. Compresses them into a single `archive.tar.gz` file
4. Removes the original files after archiving

### Hints

- Use `find backup/ -type f -mmin +1`
- Use `tar -czf archive.tar.gz` with the found files

---

## Challenge 4: Menu-Driven Backup Tool

Create a script called `backup_menu.sh` that shows a menu:

```
Backup Tool
1. Run backup
2. List backups
3. Clean old backups
4. Exit
Choose an option:
```

Use a `case` statement to handle each option.

### Hints

```bash
case "$OPTION" in
    1) ./backup.sh ;;
    2) ls -la backup/ ;;
    3) rm -rf backup/* ;;
    4) echo "Goodbye" ;;
    *) echo "Invalid option" ;;
esac
```

---

## Submission

When you finish, your `~/ncc-labs/day1/` folder should contain:

- `backup.sh`
- `system_info.sh`
- `count_errors.sh`
- `archive_old.sh`
- `backup_menu.sh`
- `logs/` directory with sample log files

These files will be committed to Git on Day 2.
