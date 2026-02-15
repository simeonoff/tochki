# Development shells entry point
{ pkgs }:

let
  nodeShells = import ./node.nix { inherit pkgs; };
  dotnetShells = import ./dotnet.nix { inherit pkgs; };
in

# Merge all development shells
nodeShells // dotnetShells
