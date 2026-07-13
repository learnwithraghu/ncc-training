# Topic 10: Menu-Driven Automation Challenge

**Time:** 20 minutes

## Goal
Combine your Bash skills into one interactive script.

## Commands to Use
```bash
cd ~/ncc-labs/day1
cat > backup_menu.sh << 'EOF'
#!/bin/bash

while true; do
  echo "Backup Tool"
  echo "1. Run backup"
  echo "2. List backups"
  echo "3. Clean old backups"
  echo "4. Exit"
  read -p "Choose an option: " OPTION

  case "$OPTION" in
    1) ./backup.sh ;;
    2) ls -la backup/ ;;
    3) rm -rf backup/* ;;
    4) echo "Goodbye"; break ;;
    *) echo "Invalid option" ;;
  esac
done
EOF
chmod +x backup_menu.sh
./backup_menu.sh
```

## Guided Steps
1. Build a simple menu.
2. Add options for running the backup and listing backups.
3. Add a cleanup option.
4. Add an exit option.
5. Test the menu end to end.

## Checkpoint
Which Bash feature is best for menu handling, and why?
