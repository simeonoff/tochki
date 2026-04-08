{ config, ... }:
let
  inherit (config.lib.file) mkOutOfStoreSymlink;
in
{
  xdg.configFile.pi.source =
    mkOutOfStoreSymlink "${config.home.homeDirectory}/tochki/modules/home-manager/programs/pi-harness/config";
}

