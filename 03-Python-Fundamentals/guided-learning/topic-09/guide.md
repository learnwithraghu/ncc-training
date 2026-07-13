# Topic 9: Dictionaries and Counting

**Time:** 20 minutes

## Goal
Use dictionaries to count repeated items.

## Commands to Use
```bash
cd ~/ncc-labs/day1
cat > count_levels.py << 'EOF'
counts = {'INFO': 0, 'WARN': 0, 'ERROR': 0}
levels = ['INFO', 'WARN', 'ERROR', 'INFO', 'ERROR']

for level in levels:
    counts[level] += 1

print(counts)
EOF
python3 count_levels.py
```

## Guided Steps
1. Create a dictionary with counters.
2. Loop through sample values.
3. Increment the matching counter.
4. Print the final counts.
5. Explain why dictionaries are useful for lookups.

## Checkpoint
Why is a dictionary a good fit for counting log levels?
