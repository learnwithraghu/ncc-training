# Topic 11: Error Handling

**Time:** 20 minutes

## Goal
Handle common file and input errors cleanly.

## Commands to Use
```bash
cd ~/ncc-labs/day1
cat > error_handling.py << 'EOF'
try:
    with open('missing.txt', 'r', encoding='utf-8') as file_handle:
        print(file_handle.read())
except FileNotFoundError:
    print('File not found')
EOF
python3 error_handling.py
```

## Guided Steps
1. Wrap risky code in `try` and `except`.
2. Trigger a `FileNotFoundError`.
3. Print a clear error message.
4. Explain why failures should be handled intentionally.
5. Mention where this matters in automation scripts.

## Checkpoint
Why is a specific exception better than a bare `except`?
