---
name: theming
description: Analyze and implement UI theming changes for Ignite UI and similar component libraries. Use when the user wants to change themes, colors, fonts, palettes, or visual styling in a demo app or component library.
---

# Theming Skill

Work with the Ignite UI Sass theming system, design tokens, and color palettes.

## Strategy

### 1. Discover Project Theme Files

Find main style files, palette definitions, schema configs, and style imports. Use `bash`, `find`, `grep`, `ls` and `read` to locate:

- `src/styles/` or `projects/*/styles/`
- `*variables.scss`, `*theme.scss`, `*palette.scss`
- `angular.json` style configurations or similar build config files for style entry points.

### 2. Use the Ignite UI Theming MCP Server

The `theming` MCP server provides Ignite UI-specific theming tools. Call through the `mcp` proxy:

1. **Discover**: `mcp({ server: "theming" })` — list available tools
2. **Query theme tokens**: `mcp({ server: "theming", tool: "...", args: { ... } })`

### 3. Implement Theme Changes

Write clean Sass code. Use variables, mixins, and the theming system properly. Follow best practices for maintainable stylesheets.
Exract common values into variables, use nesting judiciously, and avoid hard-coding values.
