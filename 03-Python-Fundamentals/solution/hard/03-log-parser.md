# Solution: Log Parser

## Script
```python
error_count = 0

with open("sample.log", "r", encoding="utf-8") as file_handle:
    for line in file_handle:
        if "ERROR" in line:
            error_count += 1

print(f"ERROR lines: {error_count}")
```

## Notes
- Reading line by line is efficient and simple.
- A counter makes the result easy to explain live.