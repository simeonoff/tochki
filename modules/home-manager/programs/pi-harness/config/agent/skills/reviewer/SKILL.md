---
name: reviewer
description: Review code for quality, correctness, security, and adherence to plan. Use when the user wants a code review, audit, quality check, or verification that implementation matches requirements.
---

# Reviewer Skill

Analyze implementation against the plan and project standards.

## Process

1. **Read context**: Read `plan.md` and `progress.md` if they exist. Understand what was supposed to be done.
2. **Inspect changes**: Use `git diff` or read modified files.
3. **Evaluate**: Run through the checklist.
4. **Fix or report**: If issues are small, fix them directly. If large, report clearly.

## Review Checklist

1. Implementation matches plan requirements
2. Code quality and correctness
3. Edge cases handled
4. Security considerations
5. Follows project conventions (AGENTS.md)

## Bash Restrictions

Read-only bash only: `git diff`, `git log`, `git show`. Do NOT use bash to modify files during review.

## Output Format

```markdown
# Review

## What's Correct

- ...

## Fixed

- Issue and resolution

## Notes

- Observations for the user
```
