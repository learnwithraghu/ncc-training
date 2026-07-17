# Lab 05: Backup and Reporting Automation

## Why this lab
Learners bring together variables, conditions, loops, and command substitution to build a useful script.

## Scenario details
The learner must create a simple backup/report workflow that copies selected files into a timestamped directory and prints a summary of what was handled.

## Lab setup
- A folder containing `.txt` and `.log` files
- A destination backup folder
- A script skeleton for basic automation

## Suggested engineer setup
```bash
mkdir -p ~/ncc-labs/day1/bash-lab-05/source ~/ncc-labs/day1/bash-lab-05/backup
printf 'note 1\n' > ~/ncc-labs/day1/bash-lab-05/source/a.txt
printf 'log 1\n' > ~/ncc-labs/day1/bash-lab-05/source/app.log
printf 'ignore me\n' > ~/ncc-labs/day1/bash-lab-05/source/readme.md
cat > ~/ncc-labs/day1/bash-lab-05/backup.sh <<'EOF'
#!/usr/bin/env bash
stamp=$(date +%F-%H%M%S)
outdir="backup/$stamp"
mkdir -p "$outdir"
for file in source/*.{txt,log}; do
  [[ -e "$file" ]] || continue
  cp "$file" "$outdir/"
done
echo "backup created at $outdir"
EOF
chmod +x ~/ncc-labs/day1/bash-lab-05/backup.sh
```

## Success criteria
- Use command substitution for a timestamp
- Create a dated output directory
- Copy selected files with a loop
- Print a simple report at the end
