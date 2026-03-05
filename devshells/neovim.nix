# Neovim nightly development shell
# Provides neovim nightly alongside all LSP servers, formatters, and linters.
#
# Usage:
#   nix develop .#neovim-nightly
#
{ pkgs, neovim-nightly }:

let
  neovimTools = import ../packages/neovim-tools { inherit pkgs; };
in

{
  neovim-nightly = pkgs.mkShell {
    buildInputs = [ neovim-nightly ] ++ neovimTools;

    shellHook = ''
      echo "Neovim nightly $(nvim --version | head -1)"
      echo "LSP servers and tools available on PATH"

      # Re-exec into nushell instead of bash
      if [ -z "$__NIX_SHELL_REEXEC" ] && command -v nu > /dev/null 2>&1; then
        export __NIX_SHELL_REEXEC=1
        exec nu
      fi
    '';
  };
}
