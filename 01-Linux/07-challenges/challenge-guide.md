# Linux & Bash Challenge

This challenge is designed to test your skills in 5 levels.
*   **Part 1:** Complete Levels 1-3 after Module 4.
*   **Part 2:** Complete Levels 4-5 after Module 6.

---

## Part 1: System Master (Levels 1-3)

### Level 1: The Architect
**Goal:** Create a specific directory structure.
1.  Create a directory named `challenge_lab`.
2.  Inside `challenge_lab`, create three folders: `data`, `scripts`, and `logs`.
3.  Inside `data`, create an empty file named `raw.txt`.
4.  **Check:** Run `tree challenge_lab` (or `ls -R challenge_lab`) to show your work.

### Level 2: The Security Guard
**Goal:** Manage permissions and file content.
1.  Inside `challenge_lab/scripts`, create a file named `secret.sh`.
2.  Add the text `echo "I am a secret"` to `secret.sh`.
3.  Make `secret.sh` executable by the owner ONLY (no one else should read/write/execute).
    *   *Hint: The permission code starts with 7...*
4.  **Check:** Run `ls -l challenge_lab/scripts/secret.sh`.

### Level 3: The Investigator
**Goal:** System monitoring and Vim.
1.  Use `vim` to create a file named `report.txt` inside `challenge_lab/logs`.
2.  In this file, write the answers to these questions (use commands to find them):
    *   "What is the current disk usage of your home directory?" (Hint: `du`)
    *   "What is the PID of your current shell?" (Hint: `echo $$` or `ps`)
3.  Save and quit `vim`.
4.  **Check:** `cat challenge_lab/logs/report.txt`.

---

## Part 2: The Automator (Levels 4-5)

### Level 4: The Scripter
**Goal:** Basic automation with variables and conditions.
1.  Create a script `challenge_lab/scripts/check_user.sh`.
2.  The script should:
    *   Ask the user for their username.
    *   Check if the input matches the current system user (`whoami`).
    *   If it matches, print "Welcome, [User]!".
    *   If not, print "Intruder detected!".
3.  **Check:** Run the script twice (once with correct name, once with wrong name).

### Level 5: The Engineer
**Goal:** Loops and real-world logic.
1.  Create a script `challenge_lab/scripts/archive_logs.sh`.
2.  The script should:
    *   Create 5 dummy log files in `challenge_lab/logs` (e.g., `log1.txt`, `log2.txt`...).
    *   Loop through all `.txt` files in `challenge_lab/logs`.
    *   Rename each file to add a `.backup` extension (e.g., `log1.txt.backup`).
    *   Print "Archived [filename]" for each file.
3.  **Check:** Run the script and list the files in `challenge_lab/logs`.
