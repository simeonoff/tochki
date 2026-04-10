---
name: theme-setup
description: Scout for existing theme context then create or modify Ignite UI theme
---

## scout
output: context.md

Analyze the project structure — find existing theme/Sass files, Ignite UI component usage, design system configuration, and current palette: {task}

## themer
reads: context.md
output: theme-output.md
progress: true

Based on the codebase context, detect the platform and create or modify the theme: {previous}
