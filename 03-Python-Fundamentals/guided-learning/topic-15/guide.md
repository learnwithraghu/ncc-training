# Topic 15: Reporting Scripts

**Time:** 20 minutes

## Goal
Create a simple text report from Python data.

## Commands to Use
```bash
cd ~/ncc-labs/day1
vi report_demo.py
python3 report_demo.py
cat python_report.txt
```

## Guided Steps
1. Open `vi report_demo.py` and add the script content below.
2. Create a list of report lines.
3. Write the lines to a file.
4. Add a final newline.
5. Print a confirmation message.
6. Explain how reports help with automation output.

## Checkpoint
Why is a text report still useful even when you have terminal output?

## Script Content
```python
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
```
