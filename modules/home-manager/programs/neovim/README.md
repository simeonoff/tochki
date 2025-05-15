# NeoVim Configuration

This directory contains a complete NeoVim setup managed through Nix Home Manager. The configuration provides a modern, feature-rich editing experience with LSP support, fuzzy finding, Git integration, and much more.

## Structure Overview

```
neovim/
├── config/               # NeoVim configuration files
│   └── nvim/             # Main NeoVim config directory
│       ├── init.lua      # Entry point for NeoVim
│       ├── lsp/          # LSP server configurations
│       ├── lua/          # Lua modules
│       │   ├── config/   # Core configuration
│       │   │   ├── plugins/  # Plugin configurations
│       │   │   └── ...   # Other config modules
│       │   └── ...       # Utility modules
│       └── spell/        # Spell checking dictionaries
└── default.nix           # Home Manager module
```

## Home Manager Integration

The configuration uses Home Manager to:

1. **Symlink Configuration**: The NeoVim configuration is symlinked from the repo to the config location
2. **Install Language Servers**: LSP servers are automatically installed via Nix packages
3. **Add Dependencies**: Manages runtime dependencies for plugins (Node.js, Python packages, etc.)

## Key Components

### `default.nix`

This file defines:
- The NeoVim package itself
- All language servers installed for LSP support
- Additional dependencies like Python and Node.js packages
- The symlink from this repo to the `.config/nvim` directory

### Configuration Structure

- **init.lua**: Minimal entry point that loads the main configuration
- **config/**: Core settings and initializations
  - **set.lua**: Basic editor settings
  - **lazy.lua**: Plugin manager setup
  - **lsp.lua**: Language Server Protocol configuration
  - **mappings.lua**: Key mappings
  - **ui.lua**: User interface settings
  - **plugins/**: Individual plugin configurations

### LSP Support

This configuration includes built-in support for:
- TypeScript/JavaScript
- HTML/CSS
- Lua
- Go
- Nix
- YAML/JSON
- Markdown
- Bash
- And more

All language servers are automatically installed through Home Manager.

### Plugin Management

Plugins are managed with [lazy.nvim](https://github.com/folke/lazy.nvim) and automatically installed on first launch. The plugin specifications are in the `lua/config/plugins/` directory.

## Usage

### Customizing

To customize this configuration:
1. Edit files in this repo
2. Run `nh home switch` to apply changes
3. Changes are immediately reflected in NeoVim

## Key Features

- Modern plugin system with lazy loading
- Full LSP integration for code intelligence
- Treesitter for improved syntax highlighting
- AI integration
- Telescope for fuzzy finding
- Git integration with signs and status
- Theme and UI customizations
- Extensive keyboard shortcuts

## Adding New LSP Servers

To add support for a new language:
1. Add the server package to `extraPackages` in `default.nix`
2. Create a new file in the `lsp/` directory named after the server
3. Run `nh home switch` to install the server
