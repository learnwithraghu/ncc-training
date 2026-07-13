# Topic 5: Reading Files

**Time:** 20 minutes

## Goal
Open a file and read its contents.

## Commands to Use
```bash
cd ~/ncc-labs/day1
vi sample.txt
vi read_file.py
python3 read_file.py
```

## Guided Steps
1. Open `vi sample.txt` and add three lines of text.
2. Open `vi read_file.py` and add the script content below.
3. Read the entire file at once.
4. Print the result.
5. Explain why `with` is safer than opening files manually.

## Checkpoint
What does `encoding='utf-8'` help you control?

## File Content
`sample.txt`
```text
line one
line two
line three
```

## Script Content
```python
with open('sample.txt', 'r', encoding='utf-8') as file_handle:
    contents = file_handle.read()

print(contents)
```
