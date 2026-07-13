# Topic 12: Log Troubleshooting

**Time:** 20 minutes

## Goal
Read logs and search for useful clues.

## Commands to Use
```bash
ls /var/log
tail -n 20 /var/log/syslog
grep -i error /var/log/syslog
tail -f /var/log/syslog
```

## Guided Steps
1. Inspect the log folders on the system.
2. Open a log file and read the newest lines.
3. Search for error keywords.
4. Follow the log live if you have permission.
5. Describe what changed in the log while you watched it.

## Checkpoint
When would you use `tail -f` instead of `tail -n 20`?
