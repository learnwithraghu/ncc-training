# Topic 6: Writing Files

**Time:** 20 minutes

## Goal
Write output to a new file.

## Commands to Use
```bash
cd ~/ncc-labs/day1
vi write_file.py
python3 write_file.py
cat report.txt
```

## Guided Steps
1. Open `vi write_file.py` and add the script content below.
2. Build a list of lines to write.
3. Open a report file in write mode.
4. Write each line and add a newline.
5. Confirm the file content with `cat`.

## Checkpoint
What happens if you open a file with `w` and it already exists?

## Script Content
```python
report_lines = [
    'Daily Report',
    '============',
    'Python writing files is useful.'
]

with open('report.txt', 'w', encoding='utf-8') as file_handle:
    for line in report_lines:
        file_handle.write(line + '\n')

print('Report written')
```
