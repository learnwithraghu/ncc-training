# Topic 5: Loops and File Patterns

**Time:** 20 minutes

## Goal
Repeat actions across multiple values and files.

## Commands to Use
```bash
cd ~/ncc-labs/day1
for item in one two three; do echo "Item: $item"; done
for file in *.log; do echo "Log file: $file"; done
```

## Guided Steps
1. Write a `for` loop over a short list.
2. Write a `for` loop over files that match a pattern.
3. Print each value as it is processed.
4. Notice how Bash expands wildcards.
5. Talk through what happens if no files match the pattern.

## Example Script
```bash
#!/bin/bash
for item in alpha beta gamma; do
  echo "Processing $item"
done
```

## Checkpoint
What is the difference between looping over words and looping over matching files?
