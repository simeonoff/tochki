# Development shells entry point
{ pkgs, neovim-nightly, pkgs-dotnet }:

let
  nodeShells = import ./node.nix { inherit pkgs; };
  dotnetShells = import ./dotnet.nix { inherit pkgs pkgs-dotnet; };
  neovimShells = import ./neovim.nix { inherit pkgs neovim-nightly; };
in

# Merge all development shells
nodeShells // dotnetShells // neovimShells
