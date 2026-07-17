# Lab 04: Loops and File Processing

## Why this lab
Learners practice repeating actions over multiple files and processing a list of items.

## Scenario details
The learner gets a folder with several text files and a script that must loop through them, print names, and count or inspect their contents.

## Lab setup
- Multiple `.txt` files in a folder
- A script that uses a loop over file patterns
- A simple output requirement for each file

## Suggested engineer setup
```bash
mkdir -p ~/ncc-labs/day1/bash-lab-04/files
printf 'alpha\n' > ~/ncc-labs/day1/bash-lab-04/files/a.txt
printf 'beta\n' > ~/ncc-labs/day1/bash-lab-04/files/b.txt
printf 'gamma\n' > ~/ncc-labs/day1/bash-lab-04/files/c.txt
cat > ~/ncc-labs/day1/bash-lab-04/count-files.sh <<'EOF'
#!/usr/bin/env bash
for file in files/*.txt; do
  echo "processing $file"
  wc -l "$file"
done
EOF
chmod +x ~/ncc-labs/day1/bash-lab-04/count-files.sh
```

## Success criteria
- Use a `for` loop
- Expand a file pattern
- Process each file consistently
