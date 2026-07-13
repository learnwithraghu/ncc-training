# Topic 10: Process Management

**Time:** 20 minutes

## Goal
Inspect and stop running processes.

## Commands to Use
```bash
sleep 300 &
ps aux | grep sleep
pgrep sleep
kill <PID>
top
```

## Guided Steps
1. Start a safe background process.
2. Find its PID with `ps` or `pgrep`.
3. Look at it in `top`.
4. Stop it with `kill`.
5. Confirm that it is no longer running.

## Checkpoint
Why do you need the PID before you can stop a process?
