---
name: workflow
description: Task tracking and subagent delegation for non-trivial multi-step work. Use when a task has 3 or more distinct steps, requires parallel execution, or benefits from specialized subagents (Explore, Plan, general-purpose).
---

# Workflow: Task Tracking & Subagents

## Task Tracking

For any non-trivial task (3 or more distinct steps), use `TaskCreate` to break the work into structured tasks before starting. Mark each task `in_progress` before working on it and `completed` when done. Use `TaskList` to check for next available work after completing a task.

## Subagents

Use the `Agent` tool to delegate work to specialized subagents when tasks are:
- **Parallelizable** — independent work that can run concurrently (use `run_in_background: true`)
- **Exploratory** — codebase searches and code understanding (use `subagent_type: "Explore"`)
- **Architectural** — planning and design before implementation (use `subagent_type: "Plan"`)
