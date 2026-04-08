## Shell
You are working within a [nushell](https://www.nushell.sh) environment. Use idiomatic commands from the nushell ecosystem for effective interaction with the system.

## Code Navigation

When exploring or understanding the codebase, always check the codebase memory MCP first:

1. Call `codebase-memory-mcp_list_projects` to see if the project is indexed
2. If indexed, use `codebase-memory-mcp_get_architecture`, `search_graph`, `trace_call_path`, etc.
