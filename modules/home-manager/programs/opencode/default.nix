{ config, ... }:
let
  inherit (config.lib.file) mkOutOfStoreSymlink;
in
{
  programs.opencode = {
    enable = true;
  };

  xdg.configFile.opencode.source =
    mkOutOfStoreSymlink "${config.home.homeDirectory}/tochki/modules/home-manager/programs/opencode/config";
}
