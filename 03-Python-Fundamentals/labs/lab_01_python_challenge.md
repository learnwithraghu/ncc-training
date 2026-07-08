# Python Fundamentals Lab Challenge

## Goal
Practice Python by solving DevOps-style automation tasks.

## Setup

All work happens in `~/ncc-labs/day1/`.

```bash
cd ~/ncc-labs/day1
```

---

## Challenge 1: Disk Usage Reporter

Create a script called `disk_report.py` that:

1. Runs the `df -h` command
2. Parses the output
3. Prints each filesystem with usage above 50%

Example output:

```
Filesystems above 50% usage:
/dev/sda1  60%
```

### Hints

- Use `subprocess.run(["df", "-h"], capture_output=True, text=True)`
- Split lines and skip the header

---

## Challenge 2: File Size Checker

Create a script called `file_size_checker.py` that:

1. Accepts a directory path as an argument
2. Lists all files in that directory
3. Prints each file name and size in bytes
4. Highlights files larger than 1 KB

Example output:

```
Files in /home/student/ncc-labs/day1:
backup.sh          245 bytes
log_parser.py      890 bytes
sample.log       1,240 bytes  [LARGE]
```

### Hints

- Use `os.listdir()` and `os.path.getsize()`
- Use `{:>15}` for alignment

---

## Challenge 3: Config File Validator

Create a script called `validate_config.py` that:

1. Reads a simple config file with `KEY=VALUE` pairs
2. Checks that required keys exist: `APP_NAME`, `PORT`, `LOG_LEVEL`
3. Prints missing keys or confirms the config is valid

Example config file (`app.conf`):

```
APP_NAME=MyApp
PORT=8080
LOG_LEVEL=INFO
```

Example output:

```
Config valid: True
```

If a key is missing:

```
Missing required keys: ['PORT']
```

### Hints

- Read the file line by line
- Skip empty lines and lines starting with `#`
- Split on `=` to get key-value pairs

---

## Challenge 4: Combine Everything

Update `run_day1.sh` to also run:

1. `disk_report.py`
2. `file_size_checker.py .`
3. `validate_config.py app.conf`

Make sure each script's output is appended to `daily_report.txt`.

---

## Submission

When you finish, your `~/ncc-labs/day1/` folder should contain:

- `backup.sh`
- `log_parser.py`
- `run_day1.sh`
- `disk_report.py`
- `file_size_checker.py`
- `validate_config.py`
- `app.conf`
- `sample.log`
- `daily_report.txt`

These files will be committed to Git on Day 2.
