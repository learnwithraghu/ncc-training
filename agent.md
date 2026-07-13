# NCC Training Agent Instructions

## Purpose

Use this repository as a teaching workspace for the NCC DevOps Bootcamp. Any time a module changes, keep the learner-facing practice content and the instructor-facing solution content in sync.

## Core Rule

When you change any folder in a training module, update the related guided-learning material in the same module at the same time.

That means:

- if you add a new topic, create matching guided-learning topic files
- if you rename or move a guide, update the linked module README and guided-learning README files
- if you change one lesson, adjust the surrounding lessons so the sequence still flows
- if a module uses `guided-learning/`, keep the topic flow mirrored and self-contained

## Repository Pattern

Each numbered module should follow the same guided-learning layout:

```text
module-name/
  guided-learning/
    topic-01/
      guide.md
    topic-02/
      guide.md
```

## Content Rules

- Aim for about 15 topics in the Linux module and about 10 topics in the Bash module unless there is a strong reason to keep fewer.
- Keep each topic self-contained so it can be completed in about 20 minutes.
- Include commands, explanation, and checkpoint prompts inside the same guide.
- Keep naming consistent so the learning path is easy to scan.

## Scope

- Start with the numbered course folders, especially `01-Linux` through `11-Capstone-Document-Search`.
- Preserve the existing module README structure.
- Use one module at a time when expanding content so the repo stays easy to review.

## Teaching Flow

1. Open the topic guide.
2. Walk through the commands with the learner.
3. Pause at the checkpoint prompts.
4. Finish with the same lesson flow every time.
5. Keep each topic self-contained and time-boxed.

## Tool Compatibility

This file is intended to be useful in Cursor, GitHub Copilot, and OpenCode-style workflows.

- Keep the instructions direct and repository-focused.
- Prefer small, consistent edits over broad rewrites.
- When in doubt, keep guided-learning topics aligned and self-contained.
