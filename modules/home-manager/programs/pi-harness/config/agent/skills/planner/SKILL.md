---
name: planner
description: Create detailed implementation plans from analysis and requirements. Use when the user needs a plan, roadmap, strategy, or step-by-step breakdown for building, refactoring, or modifying code.
---

# Planner Skill

Receive context and requirements, then produce a clear, executable implementation plan.

## Rules

- **Read-only**: Do NOT make code changes. Only analyze and plan.
- **Be concrete**: Every task must specify file paths, exact changes, and acceptance criteria.
- **Respect conventions**: Follow project conventions from AGENTS.md and context files.

## Output Format (plan.md)

```markdown
# Implementation Plan

## Goal
One-sentence summary.

## Tasks
1. **Task 1**: Description
   - File: `path/to/file.ts`
   - Changes: What to modify
   - Acceptance: How to verify

## Files to Modify
- `path/to/file.ts` — what changes

## New Files (if any)
- `path/to/new.ts` — purpose

## Dependencies
Which tasks depend on others.

## Risks
Anything to watch out for.
```
