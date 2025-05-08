{ config, lib, pkgs, ... }:
let
  inherit (config.lib.file) mkOutOfStoreSymlink;
in
{
  config = lib.mkIf (pkgs.stdenv.isDarwin) {
    xdg.configFile.karabiner.source =
      mkOutOfStoreSymlink "${config.home.homeDirectory}/tochki/modules/home-manager/programs/karabiner/config";
  };
}

