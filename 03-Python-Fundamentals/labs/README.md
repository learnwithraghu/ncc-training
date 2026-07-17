# Python Labs

This folder contains engineer-facing lab scenarios for the Python module.

## Lab Design

Each lab is built for a split-screen experience:
- **Left panel**: why the lab matters, the scenario details, step-by-step instructions, and setup notes for the engineer
- **Right panel**: terminal where learners run commands

## Left Panel Content

The left side of each lab should answer:
- what problem the learner is solving
- what files or folders are already prepared
- what command flow the learner should follow
- which setup commands or scripts the engineer can use to create the state

## Scenario Set

1. `lab-01-python-setup-and-first-script` — Beginner
2. `lab-02-variables-and-data-processing` — Beginner
3. `lab-03-file-reading-and-reporting` — Beginner to intermediate
4. `lab-04-log-parsing-and-counting` — Intermediate
5. `lab-05-day1-orchestrator-and-validation` — Intermediate

## Folder Pattern

Each lab folder should stay small and easy to implement:

- `description.md` — why the lab exists and the setup context
- `steps.md` — the learner workflow, command by command
- `code/` — files, scripts, sample data, or hidden setup assets for the lab engineer

Keep the lab state predictable so the engineer can reset it quickly.
