# Topic 5: Reading Files

**Time:** 20 minutes

## Goal
Open a file and read its contents.

## Commands to Use
```bash
cd ~/ncc-labs/day1
cat > sample.txt << 'EOF'
line one
line two
line three
EOF
cat > read_file.py << 'EOF'
with open('sample.txt', 'r', encoding='utf-8') as file_handle:
    contents = file_handle.read()

print(contents)
EOF
python3 read_file.py
```

## Guided Steps
1. Create a small text file.
2. Open it with `with open(...)`.
3. Read the entire file at once.
4. Print the result.
5. Explain why `with` is safer than opening files manually.

## Checkpoint
What does `encoding='utf-8'` help you control?
