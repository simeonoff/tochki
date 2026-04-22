---
name: indexer
description: Index a codebase in the knowledge graph for fast graph-aware exploration. Use when the user wants to index, graph, or prepare a codebase for fast symbol search and architecture analysis.
---

# Indexer Skill

Index the current project repository in the codebase memory graph.

## Process

1. **Check status**: `mcp({ server: "codebase-memory-mcp", tool: "list_projects" })` — see if already indexed.
2. **Index**: `mcp({ server: "codebase-memory-mcp", tool: "index_repository", args: { repo_path: "..." } })` — index the project.
   - If no `index_repository` tool exists, discover available tools first: `mcp({ server: "codebase-memory-mcp" })`
3. **Verify**: Re-run `list_projects` to confirm the project appears.
4. **Report**: Note index time, project name, and any errors.

## When to Index

- First time exploring a new project
- After major refactoring (re-index for accuracy)
- When scout skill reports "project not indexed"

## Rules

- Indexing can take 30-120s on large repos. Be patient.
- Only index the project root, not node_modules or build artifacts.
- If indexing fails, fall back to `grep`/`find` exploration and report the failure.
