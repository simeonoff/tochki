## Shell
You are working within a [nushell](https://www.nushell.sh) environment. Use idiomatic commands from the nushell ecosystem for effective interaction with the system.

## Delegation

For non-trivial tasks, delegate to specialized agents and chains instead of doing everything inline:

| Situation | What to use |
|-----------|------------|
| Exploring unfamiliar code | `scout` agent — graph-aware, checks codebase-memory-mcp first |
| Vague or complex requirements | `interviewer` agent — opens interactive form for clarification |
| Full feature implementation | `implement` chain — scout → planner → worker → reviewer |
| Planning only (no implementation) | `explore-plan` chain — scout → planner |
| Interactive discovery then exploration | `discover` chain — interviewer → scout |
| Ignite UI theming | `themer` agent (direct) or `theme-setup` chain (scout → themer) |
| Web research | `researcher` agent |
| Code review with context | `reviewer` agent with `inheritContext` |
| Project not indexed | `indexer` agent |

## Code Navigation

When exploring code directly (not via scout), check the codebase memory graph first:

1. `codebase_memory_mcp_list_projects` — is the current project indexed?
2. If indexed: `get_architecture`, `search_graph`, `trace_call_path`, `get_code_snippet`
3. If not indexed: fall back to grep/find, consider running the `indexer` agent first

## Context Management

Manage context proactively. Do not wait for the user to tell you.

**Always tag** at task boundaries:
- `context_tag({ name: "<task-slug>-start" })` before starting non-trivial work
- `context_tag({ name: "<task-slug>-done" })` when a task is stable
- Naming: `<task-slug>-<phase>` — e.g. `auth-refactor-start`, `db-migration-plan`

**Squash noise** when history gets polluted (long tool output, failed attempts, research):
- `context_checkout({ target: "<tag>", message: "...", backupTag: "<tag>-raw" })`
- Message format: `[Status] + [Reason] + [Important Changes] + [Next Step]`
- Always use `backupTag` — squashing is lossless

**Fail fast**: 3 failures on the same approach → stop, revert to last tag, try a different path.

For detailed recipes and anti-patterns, read the `context-management` skill.

## Conventions
- Commit messages follow: `<type>(<scope>): <description>`
- Prefer graph-aware exploration over blind grep when the project is indexed
