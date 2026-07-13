# NCC Training Agent Instructions

## Purpose

Use this repository as a teaching workspace for the NCC DevOps Bootcamp. Any time a module changes, keep the learner-facing practice content and the instructor-facing solution content in sync.

## Core Rule

When you change any folder in a training module, update the related challenge, exercise, and solution material in the same module at the same time.

That means:

- if you add a new topic, create matching practice files
- if you rename or move a guide, update the linked exercise and solution README files
- if you change one side of the practice flow, adjust the other side too
- if a module uses `exercise/` and `solution/`, keep the folder structure mirrored

## Repository Pattern

Each numbered module should follow the same practice layout:

```text
module-name/
  exercise/
    easy/
    medium/
    hard/
  solution/
    easy/
    medium/
    hard/
```

## Content Rules

- Aim for about 10 exercises per section when the module depth supports it.
- Keep the difficulty split simple and predictable: `easy`, `medium`, and `hard`.
- Make the solution folders mirror the exercise folders so live demonstration stays simple.
- Keep naming consistent so the learner version and solution version are easy to compare.

## Scope

- Start with the numbered course folders, especially `01-Linux` through `11-Capstone-Document-Search`.
- Preserve the existing guide and README structure.
- Use one module at a time when expanding content so the repo stays easy to review.

## Teaching Flow

1. Show the exercise on screen.
2. Let learners implement it.
3. Review the matching solution after the attempt.
4. Keep the folder layout identical across modules.

## Tool Compatibility

This file is intended to be useful in Cursor, GitHub Copilot, and OpenCode-style workflows.

- Keep the instructions direct and repository-focused.
- Prefer small, consistent edits over broad rewrites.
- When in doubt, keep exercises, challenge files, and solutions aligned.
