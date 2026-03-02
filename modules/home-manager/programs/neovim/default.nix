{ pkgs, config, lib, ... }:

let
  neovimTools = import ../../../../packages/neovim-tools { inherit pkgs; };
in
{
  # Keep Neovim config live by linking at activation time.
  home.activation.neovimConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    $DRY_RUN_CMD mkdir -p "${config.xdg.configHome}"
    $DRY_RUN_CMD ln -sfn "${config.home.homeDirectory}/tochki/modules/home-manager/programs/neovim/config/nvim" "${config.xdg.configHome}/nvim"
  '';
  programs.neovim = {
    enable = true;
    extraPackages = neovimTools;

    withNodeJs = true;
    extraPython3Packages = ps: with ps; [ pynvim ];
  };
}
