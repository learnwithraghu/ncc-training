# Module 4: System Management (20 Minutes)

## Goal
Learn how to monitor system resources, manage processes, and check logs.

## 1. Disk Space

### Checking Usage
*   `df -h`: Disk Free (human-readable). Shows total space, used, and available on mounted filesystems.
*   `du -sh foldername`: Disk Usage. Shows the size of a specific directory.

### Understanding the Filesystem
*   `/`: Root directory.
*   `/home`: User home directories.
*   `/bin` & `/usr/bin`: User binaries (commands like `ls`, `cp`).
*   `/etc`: Configuration files.
*   `/var`: Variable data (logs, websites).
*   `/tmp`: Temporary files (deleted on reboot).

## 2. CPU and Memory

### `top` / `htop`
Shows real-time system stats.
*   **CPU:** Usage percentage.
*   **MEM:** RAM usage.
*   **PID:** Process ID.
*   *Press `q` to exit.*

### `free -h`
Shows free and used memory (RAM) in a human-readable format.

## 3. Processes

### Viewing Processes
*   `ps aux`: Lists all running processes.
*   `ps aux | grep name`: Search for a specific process.

### Killing Processes
If a program is stuck, you can stop it.
*   `kill PID`: Ask the process (PID) to stop gracefully.
*   `kill -9 PID`: Force kill the process immediately.

## 4. Logging
Linux logs are usually stored in `/var/log`.

### Common Log Files
*   `/var/log/syslog` or `/var/log/messages`: General system messages.
*   `/var/log/auth.log`: Authentication logs (logins, sudo usage).

### Viewing Logs
*   `cat /var/log/syslog`: Print the whole file (too long!).
*   `tail -f /var/log/syslog`: Follow the log in real-time (Ctrl+C to stop).
*   `grep "error" /var/log/syslog`: Search for errors.

## Hands-on Exercise 4
1.  Check your available disk space (`df -h`).
2.  Run `top` and see which process is using the most CPU.
3.  Start a "sleep" process in the background: `sleep 1000 &`.
4.  Find its PID using `ps aux | grep sleep`.
5.  Kill the process using `kill PID`.
6.  Check the last 10 lines of the system log (`tail /var/log/syslog` or `/var/log/messages`).
