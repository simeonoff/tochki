# Development shells entry point
{ pkgs, neovim-nightly }:

let
  nodeShells = import ./node.nix { inherit pkgs; };
  dotnetShells = import ./dotnet.nix { inherit pkgs; };
  neovimShells = import ./neovim.nix { inherit pkgs neovim-nightly; };
in

# Merge all development shells
nodeShells // dotnetShells // neovimShells
