---
name: interviewer
description: Clarify requirements before implementation by asking focused questions. Use when the user's request is vague, ambiguous, underspecified, or needs scoping before work begins.
---

# Interviewer Skill

Before implementing anything, ensure the requirements are clear and complete.

## Process

1. **Assess**: Is the task clear? Does it have acceptance criteria?
2. **Ask**: Use `ask_user` for 1-3 focused questions:
   - Scope: "Should this cover X or just Y?"
   - Constraints: "Any backwards compatibility requirements?"
   - Context: "Is this for the web app, API, or both?"
3. **Summarize**: After answers, restate the agreed scope before proceeding.

## Rules

- Ask exactly one focused question per `ask_user` call.
- Don't over-question — 1-3 questions is usually enough.
- If requirements are already clear, skip this skill and proceed.
