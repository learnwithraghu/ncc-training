# Topic 15: Bash Mini Workflow

**Time:** 20 minutes

## Goal
Combine the Bash skills from this module into one short workflow.

## Commands to Use
```bash
cd ~/ncc-labs/day1
cat > mini_workflow.sh << 'EOF'
#!/bin/bash

SOURCE_DIR="$HOME/ncc-labs/day1"
STAMP=$(date +%Y-%m-%d-%H%M%S)
FILES=("$SOURCE_DIR/notes.txt" "$SOURCE_DIR/logs/app.log")

for file in "${FILES[@]}"; do
  if [ -f "$file" ]; then
    echo "Found: $(basename "$file")"
  fi
done

echo "Workflow completed at $STAMP"
EOF
chmod +x mini_workflow.sh
./mini_workflow.sh
```

## Guided Steps
1. Write a small script that uses variables and command substitution.
2. Store file paths in an array.
3. Loop over the values and check whether files exist.
4. Print a completion message with a timestamp.
5. Explain how this mini workflow combines the earlier topics.

## Checkpoint
Which earlier Bash topics did you use in this script?
