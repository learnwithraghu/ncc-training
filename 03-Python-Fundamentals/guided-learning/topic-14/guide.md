# Topic 14: CSV and JSON

**Time:** 20 minutes

## Goal
Read and write structured data formats.

## Commands to Use
```bash
cd ~/ncc-labs/day1
cat > data.csv << 'EOF'
name,role
Alice,Engineer
Bob,Operator
EOF
cat > csv_demo.py << 'EOF'
import csv

with open('data.csv', 'r', encoding='utf-8') as file_handle:
    reader = csv.DictReader(file_handle)
    for row in reader:
        print(row)
EOF
python3 csv_demo.py
```

## Guided Steps
1. Create a small CSV file.
2. Read it with `csv.DictReader`.
3. Print each row.
4. Explain how structured data differs from plain text.
5. Mention how JSON is often used by APIs.

## Checkpoint
Why is CSV helpful when you want columns with names?
