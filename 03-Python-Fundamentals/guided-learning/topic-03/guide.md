# Topic 3: Lists and Loops

**Time:** 20 minutes

## Goal
Use lists and loops to process multiple values.

## Commands to Use
```bash
cd ~/ncc-labs/day1
cat > lists.py << 'EOF'
servers = ['web-01', 'web-02', 'db-01']

for server in servers:
    print(f'Checking {server}')
EOF
python3 lists.py
```

## Guided Steps
1. Create a list with three server names.
2. Loop through the list and print each item.
3. Add another server and run the script again.
4. Show how indentation controls the loop body.
5. Explain why loops reduce repeated code.

## Checkpoint
What does the `for` loop do with each item in the list?
