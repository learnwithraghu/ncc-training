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

Approximately **6-7 hours** total, split into 20 guided topics at about 20 minutes each.

## Prerequisites

- Completion of [01-Linux](../01-Linux/README.md) and [02-Bash-Scripting](../02-Bash-Scripting/README.md)
- Python 3 installed (verify with `python3 --version`)
- Working directory: `~/ncc-labs/day1/`

## Guided Learning Topics

Work through the topics in `guided-learning/` in order:

| Topic | Folder | Focus |
|-------|--------|-------|
| Topic 1 | [guided-learning/topic-01/](guided-learning/topic-01/) | Python setup and first script |
| Topic 2 | [guided-learning/topic-02/](guided-learning/topic-02/) | Variables and data types |
| Topic 3 | [guided-learning/topic-03/](guided-learning/topic-03/) | Lists and loops |
| Topic 4 | [guided-learning/topic-04/](guided-learning/topic-04/) | Conditionals and comparisons |
| Topic 5 | [guided-learning/topic-05/](guided-learning/topic-05/) | Reading files |
| Topic 6 | [guided-learning/topic-06/](guided-learning/topic-06/) | Writing files |
| Topic 7 | [guided-learning/topic-07/](guided-learning/topic-07/) | Command-line arguments |
| Topic 8 | [guided-learning/topic-08/](guided-learning/topic-08/) | Functions and scope |
| Topic 9 | [guided-learning/topic-09/](guided-learning/topic-09/) | Dictionaries and counting |
| Topic 10 | [guided-learning/topic-10/](guided-learning/topic-10/) | Log parsing basics |
| Topic 11 | [guided-learning/topic-11/](guided-learning/topic-11/) | Error handling |
| Topic 12 | [guided-learning/topic-12/](guided-learning/topic-12/) | Paths and file system work |
| Topic 13 | [guided-learning/topic-13/](guided-learning/topic-13/) | subprocess and shell commands |
| Topic 14 | [guided-learning/topic-14/](guided-learning/topic-14/) | CSV and JSON |
| Topic 15 | [guided-learning/topic-15/](guided-learning/topic-15/) | Reporting scripts |
| Topic 16 | [guided-learning/topic-16/](guided-learning/topic-16/) | Config file validation |
| Topic 17 | [guided-learning/topic-17/](guided-learning/topic-17/) | Log parser build |
| Topic 18 | [guided-learning/topic-18/](guided-learning/topic-18/) | Disk usage reporting |
| Topic 19 | [guided-learning/topic-19/](guided-learning/topic-19/) | Day 1 orchestrator |
| Topic 20 | [guided-learning/topic-20/](guided-learning/topic-20/) | Python mini workflow |

## Day 1 Narrative

The Python `log_parser.py` you build here reads the log files created by your Bash scripts. A single `run_day1.sh` orchestrator ties Linux, Bash, and Python together. On Day 2, this entire `day1/` folder becomes your first Git commit.

## Labs

The engineer-facing lab scenarios now live in [labs/](labs/).

- `lab-01-...` through `lab-05-...` hold the lab scenarios
- each lab is split into a description, step flow, and code assets
- the lab engineer can wire the UI, starter state, and validation from these folders

## Additional Resources

- [guided-learning/](guided-learning/) — Python topics and walkthroughs
