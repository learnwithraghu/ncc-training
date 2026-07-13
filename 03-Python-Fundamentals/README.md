# Day 1, Part 3: Python Fundamentals for DevOps

This module is the third part of **Day 1** of the NCC DevOps Bootcamp. It introduces Python as a DevOps automation language.

## What You Will Learn

By the end of this module, you will be able to:

- Write basic Python scripts
- Work with variables, lists, loops, and conditionals
- Read and write files
- Parse log files and generate reports
- Combine Python with Bash scripts

## Time Estimate

Approximately **2 hours** (including hands-on exercises).

## Prerequisites

- Completion of [01-Linux](../01-Linux/README.md) and [02-Bash-Scripting](../02-Bash-Scripting/README.md)
- Python 3 installed (verify with `python3 --version`)
- Working directory: `~/ncc-labs/day1/`

## Guide Sequence

Follow these guides in order:

| Guide | File | Topic | Duration |
|-------|------|-------|----------|
| Guide 7 | [guide_01_python_for_devops.md](guide_01_python_for_devops.md) | Python basics, file I/O, log parsing | 75 min |
| Guide 8 | [guide_02_python_automation_lab.md](guide_02_python_automation_lab.md) | Combine Python with Bash orchestration | 60 min |

## Labs

- [labs/lab_01_python_challenge.md](labs/lab_01_python_challenge.md) — Practice challenges
- [labs/sample.log](labs/sample.log) — Sample log file for exercises

## Practice Materials

Use these folders during the live session:

- [exercise/](exercise/) — learner tasks split into `easy/`, `medium/`, and `hard/`
- [solution/](solution/) — matching instructor solutions for live demonstration

## Day 1 Narrative

The Python `log_parser.py` you build here reads the log files created by your Bash scripts. A single `run_day1.sh` orchestrator ties Linux, Bash, and Python together. On Day 2, this entire `day1/` folder becomes your first Git commit.

## Additional Resources

- [exercise/](exercise/) — Practice tasks for learners
- [solution/](solution/) — Reference solutions for instructors
