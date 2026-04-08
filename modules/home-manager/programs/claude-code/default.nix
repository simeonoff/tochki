{ config, ... }:
{
  programs.claude-code = {
    enable = true;

    settings = {
      model = "opus[1m]";
      effortLevel = "medium";
    };

    mcpServers = {
      obsidian = {
        type = "stdio";
        command = "npx";
        args = [
          "-y"
          "@mauricio.wolff/mcp-obsidian@latest"
          "${config.home.homeDirectory}/Library/Mobile Documents/iCloud~md~obsidian/Documents"
        ];
      };
      github = {
        type = "http";
        url = "https://api.githubcopilot.com/mcp";
        headers = {
          Authorization = "Bearer " + "$" + "{GITHUB_PAT}";
        };
      };
      context7 = {
        type = "http";
        url = "https://mcp.context7.com/mcp";
        headers = {
          CONTEXT_7_API_KEY = "$" + "{CONTEXT7_API_KEY}";
        };
      };
      theming = {
        type = "stdio";
        command = "node";
        args = [
          "${config.home.homeDirectory}/Projects/igniteui-theming/dist/mcp/index.js"
        ];
      };
    };

    agents = {
      theming = ''
        ---
        name: theming
        description: Helps with Ignite UI theming tasks
        tools: Read, Write, Edit, Grep, Glob, Bash, mcp__theming__*
        model: sonnet
        ---

        You are an expert in Ignite UI theming, CSS, and Sass. Using the Ignite UI Theming MCP, assist the user with their theming-related questions and tasks.

        FOCUS ON:

        - Strictly following the theming guidelines and best practices outlined by the theming MCP
        - Writing clean and maintainable CSS and Sass code - extract similar colors in variables for better maintainability

        DO NOT:

        - Invent new theming concepts or techniques that are not part of the theming MCP
      '';
    };

    # Commit skill
    skills = {
      commit = ''
        ---
        name: commit
        description: Commit staged changes to the repository using semantic commit message
        disable-model-invocation: true
        allowed-tools: [Bash, Read, Grep, Glob]
        ---

        Write a semantic commit message and commit the staged changes to the repository. The commit message should follow the format: `<type>(<scope>): <description>`.

        For example: `feat(button): add new primary button style`.

        Steps:
        1. Check `git diff --cached` to understand what's staged
        2. Write a concise semantic commit message based on the changes
        3. Commit with the message
      '';
    };
  };
}
