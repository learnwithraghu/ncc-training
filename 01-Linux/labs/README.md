# Linux Labs

This folder contains engineer-facing lab scenarios for the Linux module.

## Lab Design

Each lab is built for a split-screen experience:
- **Left panel**: why the lab matters, the scenario details, the step-by-step instructions, and any setup notes the engineer needs
- **Right panel**: terminal where learners run commands

## Left Panel Content

The left side of each lab should answer:
- what problem the learner is solving
- what the prebuilt starting state looks like
- what command flow the learner should follow
- which setup commands or scripts the lab engineer can use to create the state

## Scenario Set

1. `lab-01-basic-navigation` — Beginner
2. `lab-02-file-management` — Beginner
3. `lab-03-permissions-ownership` — Beginner to intermediate
4. `lab-04-search-redirection-log-filtering` — Intermediate
5. `lab-05-process-troubleshooting` — Intermediate

## Folder Pattern

Each lab folder should stay small and easy to implement:

- `description.md` — why the lab exists and the setup context
- `steps.md` — the learner workflow, command by command
- `code/` — files, scripts, sample data, or hidden setup assets for the lab engineer

Keep the lab state predictable so the engineer can reset it quickly.
