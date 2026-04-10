{ config, ... }:
let
  inherit (config.lib.file) mkOutOfStoreSymlink;
in
{
  home.file.".pi".source =
    mkOutOfStoreSymlink "${config.home.homeDirectory}/tochki/modules/home-manager/programs/pi-harness/config";
}

