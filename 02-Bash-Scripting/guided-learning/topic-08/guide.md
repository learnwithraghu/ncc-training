# Topic 8: Backup Script Build

**Time:** 20 minutes

## Goal
Build a backup script that copies files into a timestamped folder.

## Commands to Use
```bash
cd ~/ncc-labs/day1
cat > backup.sh << 'EOF'
#!/bin/bash
set -e

SOURCE_DIR="$HOME/ncc-labs/day1"
BACKUP_DIR="$SOURCE_DIR/backup"
DATE=$(date +%Y-%m-%d-%H%M%S)

mkdir -p "$BACKUP_DIR"

if [ -f "$SOURCE_DIR/notes.txt" ]; then
  cp "$SOURCE_DIR/notes.txt" "$BACKUP_DIR/notes.txt.$DATE"
fi

for file in "$SOURCE_DIR"/*.txt "$SOURCE_DIR"/logs/*.log; do
  if [ -f "$file" ]; then
    cp "$file" "$BACKUP_DIR/$(basename "$file").$DATE"
  fi
done

echo "Backup complete at $DATE"
EOF
chmod +x backup.sh
./backup.sh
```

## Guided Steps
1. Create the backup script.
2. Add a timestamp to the backup name.
3. Copy `.txt` and `.log` files.
4. Run the script and inspect the backup folder.
5. Explain how the timestamp prevents overwriting old backups.

## Checkpoint
Why is `set -e` useful in automation scripts?
