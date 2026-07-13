# Solution: Loops and Writing

## Script
```python
files = ["app.log", "backup.txt", "notes.txt"]

with open("report.txt", "w", encoding="utf-8") as report_file:
    for filename in files:
        print(filename)
        report_file.write(filename + "\n")
```

## Notes
- Lists give you a simple way to manage multiple items.
- Writing one item per line keeps the report easy to read.