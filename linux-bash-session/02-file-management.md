# Module 2: File Management & Permissions (25 Minutes)

## Goal
Learn how to create, copy, move, and delete files, and understand file permissions.

## 1. Managing Files and Directories

### Creating
```bash
touch file.txt          # Create an empty file
mkdir myfolder          # Create a directory
mkdir -p a/b/c          # Create nested directories
```

### Copying and Moving
```bash
cp file.txt copy.txt    # Copy a file
cp -r myfolder backup   # Copy a directory recursively
mv file.txt newname.txt # Rename a file
mv file.txt myfolder/   # Move a file
```

### Deleting (Be Careful!)
```bash
rm file.txt             # Remove a file
rm -r myfolder          # Remove a directory
rm -rf myfolder         # Force remove (very dangerous!)
```

### Viewing Content
```bash
cat file.txt            # Print whole file content
less file.txt           # Scroll through file (q to quit)
head file.txt           # Show first 10 lines
tail file.txt           # Show last 10 lines
```

## 2. Permissions
Linux permissions control who can read, write, or execute a file.
Run `ls -l` to see permissions (e.g., `-rw-r--r--`).
*   **r:** Read
*   **w:** Write
*   **x:** Execute

### Changing Permissions (`chmod`)
```bash
chmod +x script.sh      # Make a file executable
chmod 755 script.sh     # rwx for owner, rx for others
chmod 600 secret.txt    # rw for owner, nothing for others
```

## Hands-on Exercise 2
1.  Create a directory named `lab2`.
2.  Inside `lab2`, create a file named `notes.txt`.
3.  Add some text to `notes.txt` (you can use `echo "hello" > notes.txt`).
4.  Copy `notes.txt` to `notes_backup.txt`.
5.  Rename `notes.txt` to `final_notes.txt`.
6.  Try to remove the `lab2` directory without the `-r` flag, then fix it.
