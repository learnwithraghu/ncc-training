# Solution: Backup Automation

## Script
```bash
#!/bin/bash

source_dir="$1"
timestamp=$(date +%Y%m%d_%H%M%S)
backup_dir="backup/$timestamp"

mkdir -p "$backup_dir"
cp "$source_dir"/*.txt "$backup_dir" 2>/dev/null
cp "$source_dir"/*.log "$backup_dir" 2>/dev/null

echo "Backup created at $backup_dir"
```

## Notes
- `$(date +%Y%m%d_%H%M%S)` creates a unique timestamp.
- `cp` errors are redirected so missing file types do not stop the demo.