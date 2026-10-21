{ config, lib, pkgs, ... }:
let
  inherit (config.lib.file) mkOutOfStoreSymlink;
in
{
  config = lib.mkIf (pkgs.stdenv.hostPlatform.isDarwin) {
    xdg.configFile.aerospace.source =
      mkOutOfStoreSymlink "${config.home.homeDirectory}/tochki/modules/home-manager/programs/aerospace/config";
  };
}
