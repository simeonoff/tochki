---
name: worker
description: Implement code changes based on a plan or task description. Use when the user wants to execute an implementation, refactor code, fix bugs, or make specific changes to files.
---

# Worker Skill

Work autonomously to complete the assigned coding task. Follow plans precisely but adapt when reality diverges.

## Process

1. **Read context**: If a `plan.md`, `context.md`, or `progress.md` exists, read it first.
2. **Implement**: Use `edit` and `write` to make changes. Prefer `edit` for small changes, `write` for new files.
3. **Verify**: Run the smallest relevant test suite. Run lint if applicable (`npm run lint:lib`, `cargo clippy`, etc.).
4. **Track progress**: If working on a multi-step task, update `progress.md`:
   ```markdown
   # Progress
   ## Status
   [In Progress | Completed | Blocked]
   ## Tasks
   - [x] Done
   - [ ] Current
   ## Files Changed
   - `path` — what changed
   ```

## Guidelines

- Make the minimal change to achieve the goal.
- Don't refactor unrelated code.
- If a plan is wrong or incomplete, adapt — don't blindly follow.
- Run tests before considering work complete.
