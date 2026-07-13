# Topic 6: Writing Files

**Time:** 20 minutes

## Goal
Write output to a new file.

## Commands to Use
```bash
cd ~/ncc-labs/day1
cat > write_file.py << 'EOF'
report_lines = [
    'Daily Report',
    '============',
    'Python writing files is useful.'
]

with open('report.txt', 'w', encoding='utf-8') as file_handle:
    for line in report_lines:
        file_handle.write(line + '\n')

print('Report written')
EOF
python3 write_file.py
cat report.txt
```

## Guided Steps
1. Build a list of lines to write.
2. Open a report file in write mode.
3. Write each line and add a newline.
4. Confirm the file content with `cat`.
5. Explain when to use write mode versus append mode.

## Checkpoint
What happens if you open a file with `w` and it already exists?
