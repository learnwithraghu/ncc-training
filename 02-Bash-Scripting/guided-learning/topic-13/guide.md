# Topic 13: Arrays and Iterating Values

**Time:** 20 minutes

## Goal
Store multiple values in an array and loop over them.

## Commands to Use
```bash
cd ~/ncc-labs/day1
cat > array_demo.sh << 'EOF'
#!/bin/bash

files=(notes.txt todo.txt logs/app.log)

for file in "${files[@]}"; do
  echo "Item: $file"
done
EOF
chmod +x array_demo.sh
./array_demo.sh
```

## Guided Steps
1. Create an array with three sample values.
2. Loop through the array and print each item.
3. Change one value and run the script again.
4. Explain how arrays differ from simple strings.
5. Use the array idea in a real script context.

## Checkpoint
Why do Bash arrays help when you have several related values to process?
