# Shared list of LSP servers, formatters, linters, and other tools used by the
# Home Manager neovim module and the neovim-nightly devshell.
#
# - core:  lean set installed on every machine (servers included)
# - extra: heavy tooling for workstations only (.NET, web frameworks, ...)
# - all:   everything, used by the devshell
{ pkgs }:

let
  languageServers = import ../language-servers { inherit pkgs; };

  core = with pkgs; [
    ast-grep
    bash-language-server
    lua-language-server
    marksman
    nil
    nixpkgs-fmt
    prettierd
    selene
    stylua
    typescript-language-server
    vscode-langservers-extracted # html, css, json, eslint
    yaml-language-server
  ];

  extra = with pkgs; [
    angular-language-server
    astro-language-server
    biome
    copilot-language-server
    emmet-language-server
    eslint_d
    ginko
    gopls
    languageServers.mdx-language-server
    netcoredbg # CSharp debugger
    oxfmt
    oxlint
    roslyn-ls # CSharp language server
    languageServers.some-sass-language-server
    stylelint
    stylelint-lsp
    svelte-language-server
    tailwindcss-language-server
    tsgolint
    vscode-js-debug
  ];
in
{
  inherit core extra;
  all = core ++ extra;
}
