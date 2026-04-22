## Skills

For non-trivial tasks, load the relevant skill instead of improvising. Use `/skill:name` or let me auto-detect from your request.

| Situation                         | Load Skill    | Trigger                                 |
| --------------------------------- | ------------- | --------------------------------------- |
| Exploring unfamiliar code         | `scout`       | "explore", "analyze", "discover"        |
| Vague/underspecified requirements | `interviewer` | "clarify", "not sure", vague requests   |
| Implementation work               | `worker`      | "implement", "refactor", "fix", "build" |
| Planning before implementation    | `planner`     | "plan", "roadmap", "how should I"       |
| Code review / audit               | `reviewer`    | "review", "audit", "check quality"      |
| Ignite UI theming                 | `themer`      | "theme", "palette", "style", "color"    |
| Web research                      | `researcher`  | "research", "find docs", "what is"      |
| Verify/test/lint                  | `verifier`    | "verify", "test", "lint", "check"       |
| Learn a concept                   | `learner`     | "teach me", "explain", "how does"       |
| Index for graph search            | `indexer`     | "index", "graph", "codebase memory"     |

**Pipeline pattern:** For full feature work, load skills sequentially in one session:

1. `/skill:interviewer` → clarify requirements
2. `/skill:scout` → explore codebase
3. `/skill:planner` → create plan
4. `/skill:worker` → implement
5. `/skill:reviewer` → review

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

**FAIL FAST**: 3 failures on the same approach → stop, revert to last tag, try a different path.

For detailed recipes and anti-patterns, read the `context-management` skill.

## Conventions

- Commit messages follow: `<type>(<scope>): <description>`
- Prefer graph-aware exploration over blind grep when the project is indexed
