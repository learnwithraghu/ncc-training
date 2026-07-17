# Lab 05: Process and Troubleshooting Basics

## Why this lab
Learners need to inspect running processes and recognize simple resource or service issues.

## Scenario details
The learner is given a harmless mock service that is already running or has stopped unexpectedly. They must find it, identify its process ID, and bring it back to the expected state.

## Lab setup
- A background process or mock service
- A visible issue the learner can investigate
- A safe environment for process inspection

## Suggested engineer setup
```bash
mkdir -p ~/ncc-labs/day1/process-lab/bin ~/ncc-labs/day1/process-lab/state
cat > ~/ncc-labs/day1/process-lab/bin/mock-service.sh <<'EOF'
#!/usr/bin/env bash
while true; do
  echo "$(date '+%F %T') service ok" >> "$HOME/ncc-labs/day1/process-lab/state/service.log"
  sleep 30
done
EOF
chmod +x ~/ncc-labs/day1/process-lab/bin/mock-service.sh
nohup ~/ncc-labs/day1/process-lab/bin/mock-service.sh >/dev/null 2>&1 &
echo $! > ~/ncc-labs/day1/process-lab/state/mock-service.pid
```

## Success criteria
- Use `ps`, `top`, or `pgrep`
- Identify a running process
- Stop or restart a harmless training process
- Explain what changed
