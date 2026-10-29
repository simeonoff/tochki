{ pkgs
, config
, lib
  # , neovim-nightly
, ...
}:

let
  neovimTools = import ../../../../packages/neovim-tools { inherit pkgs; };
in
{
  # Add neovim and tools to packages.
  # We don't use programs.neovim here because it generates its own init.lua
  # which conflicts with our symlink-based config management below.
  # Lean tool set for every machine; workstations add neovimTools.extra
  # through the workstation profile.
  home.packages = [ pkgs.neovim ] ++ neovimTools.core;

  # Keep Neovim config live by linking at activation time.
  # This symlinks the entire nvim directory from the git repo.
  home.activation.neovimConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    $DRY_RUN_CMD mkdir -p "${config.xdg.configHome}"
    $DRY_RUN_CMD ln -sfn "${config.home.homeDirectory}/tochki/modules/home-manager/programs/neovim/config/nvim" "${config.xdg.configHome}/nvim"
  '';
}
