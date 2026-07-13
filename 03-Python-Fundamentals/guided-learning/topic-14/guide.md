# Topic 14: CSV and JSON

**Time:** 20 minutes

## Goal
Read and write structured data formats.

## Commands to Use
```bash
cd ~/ncc-labs/day1
vi data.csv
vi csv_demo.py
python3 csv_demo.py
```

## Guided Steps
1. Open `vi data.csv` and add the sample CSV content below.
2. Open `vi csv_demo.py` and add the script content below.
3. Read it with `csv.DictReader`.
4. Print each row.
5. Explain how structured data differs from plain text.
6. Mention how JSON is often used by APIs.

## Checkpoint
Why is CSV helpful when you want columns with names?

## File Content
`data.csv`
```text
name,role
Alice,Engineer
Bob,Operator
```

## Script Content
```python
import csv

with open('data.csv', 'r', encoding='utf-8') as file_handle:
    reader = csv.DictReader(file_handle)
    for row in reader:
        print(row)
```
