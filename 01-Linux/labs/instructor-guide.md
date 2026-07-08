# Instructor Guide - Linux & Bash Scripting Session

## Session Overview
*   **Duration:** 1.5 Hours (90 Minutes)
*   **Audience:** Beginners with little to no Linux experience.
*   **Goal:** Demystify the command line and show the power of automation.

## Timeline Breakdown

| Time | Module | Key Concepts | Notes |
| :--- | :--- | :--- | :--- |
| **0:00 - 0:15** | **Module 1: Intro & Navigation** | `pwd`, `ls`, `cd`, `man` | Focus on the "mental model" of the file tree. |
| **0:15 - 0:30** | **Module 2: File Management** | `mkdir`, `cp`, `mv`, `rm`, `chmod` | Emphasize `rm` danger. Explain permissions simply. |
| **0:30 - 0:40** | **Module 3: Text Editors (Vim)** | `i`, `Esc`, `:wq`, `:q!` | Just basics. Mention `nano` as easier alternative. |
| **0:40 - 0:55** | **Module 4: System Mgmt** | `df`, `top`, `ps`, `kill`, `logs` | Show real-time monitoring. Kill a dummy process. |
| **0:55 - 1:10** | **Challenge Part 1** | **Levels 1-3** | **Students solve Levels 1-3 independently.** |
| **1:10 - 1:25** | **Module 5: Bash Basics** | Scripts, Variables, Input, `if` | Make sure everyone gets their first "Hello World" running. |
| **1:25 - 1:35** | **Module 6: Advanced** | Loops, Backup Script | Quick demo of loops. |
| **1:35 - 1:50** | **Challenge Part 2** | **Levels 4-5** | **Students solve Levels 4-5 independently.** |
| **1:50+** | **Bonus Challenge** | **CPU Debugging** | **"The Phantom Process" (See `bonus-challenge/bonus-cpu-challenge.md`)** |

## Preparation Checklist
*   [ ] Ensure all students have a working terminal.
*   [ ] Verify internet access (if needed for installing tools, though standard tools should be pre-installed).
*   [ ] Have the PDF/Markdown materials accessible to students.

## Common Pitfalls & Tips
1.  **Case Sensitivity:** Remind students that `File.txt` and `file.txt` are different.
2.  **Spaces in Filenames:** Avoid them for beginners, or teach quoting (`"my file.txt"`).
3.  **Permissions:** If a script says "Permission denied", remind them of `chmod +x`.
4.  **Shebang:** Explain that `#!/bin/bash` is magic that tells the computer how to run the file.

## Engagement Questions
*   "Why would we use the command line instead of a GUI?" (Speed, automation, servers).
*   "What happens if you delete a file in the terminal? Is it in the Trash?" (No, it's gone forever usually).
