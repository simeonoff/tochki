# NeoVim Configuration

This directory contains a complete NeoVim setup managed through Nix Home Manager. The configuration provides a modern, feature-rich editing experience with LSP support, fuzzy finding, Git integration, and much more.

## Structure Overview

```
neovim/
├── config/               # NeoVim configuration files
│   └── nvim/             # Main NeoVim config directory
│       ├── init.lua      # Entry point; loads mini.nvim and wires up helpers
│       ├── after/        # Filetype-specific overrides (ftplugin/)
│       ├── lsp/          # LSP server configurations (one file per server)
│       ├── lua/          # Utility modules (banners, git_blame, utils, etc.)
│       │   └── vim/lsp/  # Custom LSP health helpers
│       ├── plugin/       # Plugin/feature configs loaded in numeric order
│       │   ├── 10_appearance.lua
│       │   ├── 10_options.lua
│       │   ├── 20_lsp.lua
│       │   ├── 20_views.lua
│       │   ├── 30_treesitter.lua
│       │   ├── 40_completion.lua
│       │   ├── 40_debugging.lua
│       │   ├── 40_editor.lua
│       │   ├── 40_git.lua
│       │   ├── 40_nav.lua
│       │   ├── 40_ui.lua
│       │   └── 50_keymaps.lua
│       ├── spell/        # Spell checking dictionaries
│       └── nvim-pack-lock.json  # Plugin lockfile (vim.pack)
└── default.nix           # Home Manager module
```

## Home Manager Integration

The configuration uses Home Manager to:

1. **Symlink Configuration**: The NeoVim configuration is symlinked from the repo to the config location via an activation script
2. **Install Tools**: LSP servers, formatters, linters, and debuggers are automatically installed via `packages/neovim-tools/default.nix`
3. **Add Dependencies**: Manages runtime dependencies (Node.js, Python packages, etc.)

## Key Components

### `default.nix`

This file defines:
- The NeoVim package itself
- All tools (LSP servers, formatters, debuggers) via `neovimTools` imported from `packages/neovim-tools/`
- The `VSCODE_JS_DEBUG_PATH` env var for JavaScript/TypeScript debugging
- Python `pynvim` package and Node.js support
- The activation script that symlinks this repo's `config/nvim` to `~/.config/nvim`

### Configuration Structure

- **init.lua**: Entry point that bootstraps `mini.nvim`, defines `Config.now`/`Config.later` loading helpers, and sets up global utilities
- **plugin/**: Numbered plugin and feature configs loaded automatically by Neovim
  - **10_options.lua**: Basic editor settings
  - **10_appearance.lua**: Colors and visual settings
  - **20_lsp.lua**: Language Server Protocol configuration
  - **20_views.lua**: Window/view management
  - **30_treesitter.lua**: Treesitter setup
  - **40_*.lua**: Feature plugins (completion, debugging, editor tools, Git, navigation, UI)
  - **50_keymaps.lua**: Key mappings
- **lsp/**: Individual LSP server configuration files (one per server)
- **lua/**: Utility modules (`banners.lua`, `git_blame.lua`, `utils.lua`, etc.)

### LSP Support

This configuration includes built-in support for:
- TypeScript/JavaScript (typescript-language-server, eslint_d)
- Angular, Astro, Svelte
- HTML/CSS/SCSS (vscode-langservers-extracted, emmet, some-sass, stylelint)
- Lua (lua-language-server, selene)
- Go (gopls, gotools)
- Nix (nil, nixpkgs-fmt)
- YAML/JSON
- Markdown (marksman)
- Bash (bash-language-server)
- C# (roslyn-ls)
- Tailwind CSS
- AST grep, Biome, Prettier (formatting)
- GitHub Copilot (copilot-language-server)

All tools are automatically installed via `packages/neovim-tools/default.nix`.

### Plugin Management

Plugins are managed with [`vim.pack`](https://neovim.io/doc/user/pack/#_plugin-manager) — Neovim's built-in plugin manager. The state of installed plugins is recorded in `nvim-pack-lock.json`.

Useful commands:
- `:lua vim.pack.update()` — update all plugins; execute `:write` to confirm
- `:lua vim.pack.del({ ... })` — remove specific plugins

## Usage

### Customizing

To customize this configuration:
1. Edit files in this repo
2. Run `nh home switch` to apply changes
3. Changes are immediately reflected in NeoVim

## Key Features

- Plugin system using `vim.pack` (Neovim built-in) with deferred loading via `mini.nvim`
- Full LSP integration for code intelligence
- Treesitter for improved syntax highlighting
- AI integration (GitHub Copilot)
- Navigation and fuzzy finding via `mini.pick`
- Git integration with signs and status
- Debugging support (DAP, vscode-js-debug, netcoredbg for C#)
- Theme and UI customizations
- Extensive keyboard shortcuts

## Adding New LSP Servers

To add support for a new language:
1. Add the server package to `packages/neovim-tools/default.nix`
2. Create a new file in the `lsp/` directory named after the server
3. Run `nh home switch` to install the server
