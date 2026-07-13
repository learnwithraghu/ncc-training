# Solution: System Troubleshooting

## Commands
```bash
df -h
top
ps aux
sleep 300 &
ps aux | grep sleep
kill <PID>
```

## Notes
- `df -h` shows disk usage in a readable format.
- `ps aux` gives a snapshot of running processes.
- `kill` sends a signal to the process identified by the PID.