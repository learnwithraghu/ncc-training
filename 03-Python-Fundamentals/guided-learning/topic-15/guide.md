# Topic 15: Reporting Scripts

**Time:** 20 minutes

## Goal
Create a simple text report from Python data.

## Commands to Use
```bash
cd ~/ncc-labs/day1
cat > report_demo.py << 'EOF'
report_lines = [
    'Daily Python Report',
    '===================',
    'Files checked: 3',
    'Errors found: 1'
]

with open('python_report.txt', 'w', encoding='utf-8') as file_handle:
    file_handle.write('\n'.join(report_lines))
    file_handle.write('\n')

print('Report written to python_report.txt')
EOF
python3 report_demo.py
cat python_report.txt
```

## Guided Steps
1. Create a list of report lines.
2. Write the lines to a file.
3. Add a final newline.
4. Print a confirmation message.
5. Explain how reports help with automation output.

## Checkpoint
Why is a text report still useful even when you have terminal output?
