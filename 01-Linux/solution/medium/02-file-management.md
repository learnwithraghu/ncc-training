# Solution: File Management

## Commands
```bash
mkdir practice
cd practice
touch notes.txt todo.txt
cp notes.txt notes-backup.txt
mv todo.txt tasks.txt
rm notes-backup.txt
chmod u+rw .
```

## Notes
- Use `chmod u+rw .` to keep the directory usable by the owner while reinforcing permissions.
- Be careful with `rm`; it deletes immediately.