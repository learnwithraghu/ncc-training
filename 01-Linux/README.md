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

## Guided Learning Topics

Work through the topics in `guided-learning/` in order:

| Topic | Folder | Focus |
|-------|--------|-------|
| Topic 1 | [guided-learning/topic-01/](guided-learning/topic-01/) | Basic navigation |
| Topic 2 | [guided-learning/topic-02/](guided-learning/topic-02/) | Directory structure |
| Topic 3 | [guided-learning/topic-03/](guided-learning/topic-03/) | Help and man pages |
| Topic 4 | [guided-learning/topic-04/](guided-learning/topic-04/) | Hidden files and globbing |
| Topic 5 | [guided-learning/topic-05/](guided-learning/topic-05/) | File management |
| Topic 6 | [guided-learning/topic-06/](guided-learning/topic-06/) | File permissions |
| Topic 7 | [guided-learning/topic-07/](guided-learning/topic-07/) | Editing with Nano and Vim |
| Topic 8 | [guided-learning/topic-08/](guided-learning/topic-08/) | Text editor practice |
| Topic 9 | [guided-learning/topic-09/](guided-learning/topic-09/) | Process management |
| Topic 10 | [guided-learning/topic-10/](guided-learning/topic-10/) | Log troubleshooting |

## Day 1 Narrative

The commands and workspace you create in this module feed directly into the next modules:

- In **02-Bash-Scripting**, you will write scripts that use these Linux commands.
- In **03-Python-Fundamentals**, you will write Python programs that read and process files you create here.
- On **Day 2**, the entire `~/ncc-labs/day1/` folder will be committed to GitHub.

## Guided Learning

The practice material for this module now lives in [guided-learning/](guided-learning/).

- `topic-01/` through `topic-10/` hold the learning topics
- each topic has `layer-1.md`, `layer-2.md`, and `layer-3.md`
- layer 1 is the learner task, layer 2 is the checkpoint, and layer 3 is the solution/demo

This module now carries a 10-topic guided-learning set with a balanced mix of easy, medium, and hard material.

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
- [guided-learning/](guided-learning/) — Practice topics and layered walkthroughs
