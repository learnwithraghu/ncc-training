# Bonus Challenge: The Phantom Process

## Scenario
**"Help! The server is running extremely slow!"**

A user has reported that the server is sluggish. Your job is to investigate the system, identify the cause of the high CPU usage, and terminate the rogue process.

## The "Malicious" Script (For Setup Only)
*Note: This script simulates a high load. It is safe but will consume CPU.*

```bash
#!/bin/bash
# hidden_miner.sh

# Log file location
LOG_FILE="/tmp/system_monitor.log"

echo "Starting system monitor service..." > "$LOG_FILE"

# Infinite loop to consume CPU
while true; do
    # Write to log to give a clue
    echo "$(date): System check OK. Process ID $$ is running normally." >> "$LOG_FILE"
    
    # Busy wait to consume CPU
    for i in {1..5000}; do :; done
    
    # Sleep briefly to allow other processes to run (prevent total freeze)
    sleep 0.1
done
```

## Student Instructions

1.  **Investigate:** Use your system monitoring tools (`top`, `htop`, `ps`) to find the process consuming the most CPU.
2.  **Check Logs:** The user mentioned "logs". Check `/tmp/system_monitor.log` to see if there are any clues about the process ID (PID).
3.  **Terminate:** Once you have identified the PID of the rogue process, use the `kill` command to stop it.
4.  **Verify:** Run `top` again to ensure the CPU usage has returned to normal.

## Solution

1.  **Find the Process:**
    *   Run `top`. Look for a process named `bash` or `hidden_miner.sh` with high `%CPU`.
    *   *Alternative:* Run `tail -f /tmp/system_monitor.log`. You will see lines like: `... Process ID 12345 is running normally.`

2.  **Kill the Process:**
    *   Note the PID (e.g., `12345`).
    *   Run: `kill 12345`
    *   If it doesn't stop, use force kill: `kill -9 12345`

3.  **Verify:**
    *   Run `top` or `ps aux | grep hidden_miner` to confirm it's gone.
