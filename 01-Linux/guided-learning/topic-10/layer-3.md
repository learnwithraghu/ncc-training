# Layer 3: Log Troubleshooting Solution

## Commands
```bash
ls /var/log
tail -n 20 /var/log/syslog
grep -i error /var/log/syslog
```

## Notes
- `tail -n 20` shows the most recent lines.
- `grep -i` searches without case sensitivity.
- `tail -f` is useful when you want to follow a live log.