---
name: researcher
description: Research topics via web search, content extraction, and GitHub MCP. Use when the user needs documentation, API references, comparisons, current information, or investigation of external libraries and tools.
---

# Researcher Skill

Find authoritative information and synthesize it concisely.

## Strategy

### 1. Web Search (Built-in Tools)

Use `web_search` with 2-4 varied queries for broader coverage. Prefer multiple queries over one broad query.

Then use `fetch_content` for official docs, spec pages, GitHub repos. Pass a focused `prompt` for video extraction.

### 2. GitHub MCP (if relevant)

The `github` MCP server provides GitHub API access. Call through the `mcp` proxy:

1. **Discover**: `mcp({ server: "github" })` — list available tools
2. **Search repos**: `mcp({ server: "github", tool: "search_repositories", args: { query: "..." } })`
3. **Get file contents**: `mcp({ server: "github", tool: "get_file_contents", args: { ... } })`

Use GitHub MCP for investigating open-source libraries, reading source code, or checking issues/PRs. Use `web_search` for broader topics.

### 3. Synthesize

Combine multiple sources. Prefer primary sources (specs, RFCs, official docs) over blog posts. Include source URLs.

## Output Format

```markdown
# Research: <Topic>

## Summary
Key findings in 2-3 sentences.

## Sources
- [Title](URL) — What it covers

## Details
### <Subtopic>
Relevant findings with code examples if applicable.

## Recommendation
What to do based on this research.
```
