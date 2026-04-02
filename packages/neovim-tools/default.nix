# Shared list of LSP servers, formatters, linters, and other tools
# used by both the Home Manager neovim module and the neovim-nightly devshell.
{ pkgs }:

let
  languageServers = import ../language-servers { inherit pkgs; };
in

with pkgs; [
  angular-language-server
  astro-language-server
  ast-grep
  bash-language-server
  copilot-language-server
  emmet-language-server
  eslint_d
  ginko
  gopls
  gotools
  lua-language-server
  marksman
  netcoredbg # CSharp debugger
  nil
  nixpkgs-fmt
  prettierd
  roslyn-ls # CSharp language server
  selene
  languageServers.some-sass-language-server
  stylelint
  stylelint-lsp
  stylua
  svelte-language-server
  tailwindcss-language-server
  typescript-language-server
  vscode-langservers-extracted
  yaml-language-server
]
