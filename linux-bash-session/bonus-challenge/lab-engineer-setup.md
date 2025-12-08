# Lab Engineer Setup Instructions

## Goal
Prepare the student environments with the "Phantom Process" challenge.

## Instructions

1.  **Create the Script:**
    *   On each student machine (or the shared server), create a file named `/usr/local/bin/hidden_miner.sh` (or any hidden location).
    *   Paste the content of the "Malicious Script" from `bonus-cpu-challenge.md`.
    *   Make it executable: `chmod +x /usr/local/bin/hidden_miner.sh`

2.  **Start the Process:**
    *   Before the "System Management" module begins (or during the break), run the script in the background:
        ```bash
        /usr/local/bin/hidden_miner.sh &
        ```
    *   *Tip:* You can run it multiple times to create more load if needed, but be careful not to crash the system.

3.  **Verify:**
    *   Check that the log file is being written to: `tail -f /tmp/system_monitor.log`
    *   Check CPU usage: `top`

4.  **Cleanup (Post-Session):**
    *   Ensure all instances are killed: `pkill -f hidden_miner.sh`
    *   Remove the script and log file:
        ```bash
        rm /usr/local/bin/hidden_miner.sh
        rm /tmp/system_monitor.log
        ```
