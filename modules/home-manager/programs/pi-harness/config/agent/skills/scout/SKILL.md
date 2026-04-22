---
name: scout
description: Explore and analyze a codebase systematically. Use when the user asks to explore, scan, analyze, understand, discover, or get an overview of a project, codebase, directory, or set of files.
---

# Scout Skill

Quickly investigate a codebase and return structured findings.

## Strategy: Graph-First, Grep-Second

### 1. Check the Graph (via MCP)

The `codebase-memory-mcp` server provides graph-aware code exploration. All calls go through the `mcp` proxy tool — `directTools` is disabled.

1. **Discover tools**: `mcp({ server: "codebase-memory-mcp" })` — lists available tools and schemas
2. **List projects**: `mcp({ server: "codebase-memory-mcp", tool: "list_projects" })`
3. **Architecture**: `mcp({ server: "codebase-memory-mcp", tool: "get_architecture", args: { project: "..." } })`
4. **Search symbols**: `mcp({ server: "codebase-memory-mcp", tool: "search_graph", args: { ... } })`
5. **Call paths**: `mcp({ server: "codebase-memory-mcp", tool: "trace_call_path", args: { ... } })`
6. **Code snippets**: `mcp({ server: "codebase-memory-mcp", tool: "get_code_snippet", args: { ... } })`

If the project is **not indexed**, skip graph tools and use filesystem search below. Note this in output.

### 2. Fill Gaps with Filesystem Search

Use `bash`, `grep`, `find`, `ls` for anything the graph didn't cover:

- Recent changes, config files, tests, build scripts
- String literals, error messages, env vars
- Files not yet indexed

### 3. Read Critically

Follow imports, read key files. Don't read everything — be selective.

## Thoroughness

- **Quick**: Targeted lookups, key files only
- **Medium** (default): Follow imports, read critical sections
- **Thorough**: Trace dependencies, check tests/types

## Output Format

```markdown
# Code Context

## Graph Status

Whether the project is indexed. Key architectural insights from the graph.

## Files Retrieved

List with exact line ranges:

1. `path/to/file.ts` (lines 10-50) — Description

## Key Code

Critical types, interfaces, or functions with actual code snippets.

## Architecture

Brief explanation of how the pieces connect.

## Start Here

Which file to look at first and why.
```
