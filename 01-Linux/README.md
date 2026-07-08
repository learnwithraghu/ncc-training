# Day 1, Part 1: Linux Fundamentals

This module is the first part of **Day 1** of the NCC DevOps Bootcamp. It covers the essential Linux command-line skills every DevOps engineer needs.

## What You Will Learn

By the end of this module, you will be able to:

- Navigate the Linux filesystem using the terminal
- Create, copy, move, and delete files and directories
- Edit files with `vim` and `nano`
- Monitor system resources and manage processes
- Understand file permissions and how to change them

## Time Estimate

Approximately **2 hours** (including hands-on exercises).

## Prerequisites

- Access to a terminal (Linux, macOS, or WSL on Windows)
- A text editor (`nano`, `vim`, or VS Code)
- No prior Linux experience required

## Guide Sequence

Follow these guides in order:

| Guide | File | Topic | Duration |
|-------|------|-------|----------|
| Guide 1 | [guide_01_intro_and_navigation.md](guide_01_intro_and_navigation.md) | Terminal basics, `pwd`, `ls`, `cd`, `man` | 20 min |
| Guide 2 | [guide_02_file_management.md](guide_02_file_management.md) | Files, directories, permissions | 25 min |
| Guide 3 | [guide_03_text_editors.md](guide_03_text_editors.md) | Vim basics | 15 min |
| Guide 4 | [guide_04_system_management.md](guide_04_system_management.md) | Processes, monitoring, logs | 20 min |

## Day 1 Narrative

The commands and workspace you create in this module feed directly into the next modules:

- In **02-Bash-Scripting**, you will write scripts that use these Linux commands.
- In **03-Python-Fundamentals**, you will write Python programs that read and process files you create here.
- On **Day 2**, the entire `~/ncc-labs/day1/` folder will be committed to GitHub.

## Setup Instructions

1. Open your terminal.
2. Create the Day 1 workspace:
   ```bash
   mkdir -p ~/ncc-labs/day1
   cd ~/ncc-labs/day1
   ```
3. Follow the guides in order above.

## Additional Resources

- [00-OVERVIEW.md](00-OVERVIEW.md) — Comprehensive Linux theory
- [instructor-guide.md](instructor-guide.md) — Notes for instructors
- [07-challenges/](07-challenges/) — Extra hands-on challenges
