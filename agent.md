# NCC Training Agent Instructions

## Purpose

Use this repository as a teaching workspace for the NCC DevOps Bootcamp. Any time a module changes, keep the learner-facing practice content and the instructor-facing solution content in sync.

## Core Rule

When you change any folder in a training module, update the related guided-learning material in the same module at the same time.

That means:

- if you add a new topic, create matching guided-learning topic files
- if you rename or move a guide, update the linked module README and guided-learning README files
- if you change one layer of a topic, adjust the other layers too
- if a module uses `guided-learning/`, keep the topic and layer structure mirrored

## Repository Pattern

Each numbered module should follow the same guided-learning layout:

```text
module-name/
  guided-learning/
    topic-01/
      layer-1.md
      layer-2.md
      layer-3.md
    topic-02/
      layer-1.md
      layer-2.md
      layer-3.md
```

## Content Rules

- Aim for about 10 topics per section when the module depth supports it.
- Keep the three layers consistent and predictable: learner task, checkpoint, and solution/demo.
- Make the guided-learning layers mirror each other so live demonstration stays simple.
- Keep naming consistent so the learner version and solution version are easy to compare.

## Scope

- Start with the numbered course folders, especially `01-Linux` through `11-Capstone-Document-Search`.
- Preserve the existing module README structure.
- Use one module at a time when expanding content so the repo stays easy to review.

## Teaching Flow

1. Show layer 1 on screen.
2. Let learners implement the task.
3. Review layer 2 as the checkpoint.
4. Review layer 3 as the solution/demo.
5. Keep the topic layout identical across modules.

## Tool Compatibility

This file is intended to be useful in Cursor, GitHub Copilot, and OpenCode-style workflows.

- Keep the instructions direct and repository-focused.
- Prefer small, consistent edits over broad rewrites.
- When in doubt, keep guided-learning topics and layers aligned.
