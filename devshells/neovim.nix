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
    '';
  };
}
