# Solution: Hello and Files

## Script
```python
with open("sample.txt", "r", encoding="utf-8") as file_handle:
    contents = file_handle.read()

print("Hello from Python")
print(contents)
```

## Notes
- `with open(...)` closes the file automatically.
- `encoding="utf-8"` keeps the example explicit and beginner-friendly.