# Module 1: Introduction & Basic Navigation (20 Minutes)

## Goal
Understand the Linux file system structure and learn how to move around using the command line.

## 1. The Terminal
The terminal is your interface to the underlying operating system. Instead of clicking icons, you type commands.
*   **Prompt:** Usually looks like `user@hostname:~$`. The `~` indicates you are in your home directory.

## 2. Basic Commands

### `pwd` - Print Working Directory
Tells you where you currently are in the file system.
```bash
pwd
# Output example: /home/student/linux-session
```

### `ls` - List Directory Contents
Shows files and folders in the current directory.
```bash
ls          # Simple list
ls -l       # Long listing (shows permissions, size, owner)
ls -a       # Show all files (including hidden files starting with .)
ls -la      # Combine flags
```

### `cd` - Change Directory
Moves you to a different folder.
```bash
cd ..       # Go up one level
cd ~        # Go to your home directory
cd /        # Go to the root of the file system
cd -        # Go back to the previous directory
```

### `man` - Manual Pages
Get help for any command.
```bash
man ls      # Read the manual for ls (Press 'q' to quit)
```

## Hands-on Exercise 1
1.  Open your terminal.
2.  Run `pwd` to see where you are.
3.  List all files, including hidden ones.
4.  Navigate to the root directory (`/`) and list its contents.
5.  Return to your home directory.
