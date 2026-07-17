# Lab 03: Permissions and Ownership

## Why this lab
Learners need to understand why files sometimes cannot be read, edited, or executed.

## Scenario details
The learner sees one script that fails to run and one file that is too open or too restricted. They must inspect the permissions, decide what is wrong, and apply a safe fix.

## Lab setup
- A private file and a shared file
- At least one script that is not yet executable
- A scenario that requires permission fixes

## Suggested engineer setup
```bash
mkdir -p ~/ncc-labs/day1/permissions-lab
cat > ~/ncc-labs/day1/permissions-lab/run-report.sh <<'EOF'
#!/usr/bin/env bash
echo "report generated"
EOF
chmod 644 ~/ncc-labs/day1/permissions-lab/run-report.sh
printf 'top secret\n' > ~/ncc-labs/day1/permissions-lab/private.txt
chmod 600 ~/ncc-labs/day1/permissions-lab/private.txt
```

## Success criteria
- Read `ls -l` output
- Change permissions with `chmod`
- Recognize when ownership or execute bits matter
