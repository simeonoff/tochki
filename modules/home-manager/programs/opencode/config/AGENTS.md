## Code Navigation

When exploring or understanding the codebase, always check the codebase memory MCP first:

1. Call `mcp_codebase-memory-mcp_list_projects` to see if the project is indexed
2. If indexed, use `mcp_codebase-memory-mcp_get_architecture`, `search_graph`, `trace_call_path`, etc.
3. Only fall back to the `explore` subagent if the project is not indexed
