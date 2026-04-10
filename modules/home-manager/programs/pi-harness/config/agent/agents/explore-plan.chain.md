---
name: explore-plan
description: Scout the codebase then create an implementation plan
---

## scout
output: context.md

Analyze the codebase for: {task}

## planner
reads: context.md
output: plan.md

Create an implementation plan based on: {previous}
