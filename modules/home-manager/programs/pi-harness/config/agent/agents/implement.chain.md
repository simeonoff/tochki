---
name: implement
description: Full pipeline — scout, plan, implement, review
---

## scout
output: context.md

Analyze the codebase for: {task}

## planner
reads: context.md
output: plan.md

Create an implementation plan based on: {previous}

## worker
reads: context.md, plan.md
progress: true

Execute the plan.

## reviewer
reads: plan.md, progress.md
progress: true

Review the implementation against the plan.
