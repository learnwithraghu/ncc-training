# Topic 9: Dictionaries and Counting

**Time:** 20 minutes

## Goal
Use dictionaries to count repeated items.

## Commands to Use
```bash
cd ~/ncc-labs/day1
vi count_levels.py
python3 count_levels.py
```

## Guided Steps
1. Open `vi count_levels.py` and add the script content below.
2. Create a dictionary with counters.
2. Loop through sample values.
3. Increment the matching counter.
4. Print the final counts.
5. Explain why dictionaries are useful for lookups.

## Checkpoint
Why is a dictionary a good fit for counting log levels?

## Script Content
```python
counts = {'INFO': 0, 'WARN': 0, 'ERROR': 0}
levels = ['INFO', 'WARN', 'ERROR', 'INFO', 'ERROR']

for level in levels:
    counts[level] += 1

print(counts)
```
