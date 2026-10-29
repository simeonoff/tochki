{ config, lib, pkgs, ... }:

{
  programs.nh = {
    enable = true;
    clean = {
        enable = true;
        dates = "weekly";
        extraArgs = "--keep-since 14d --keep 3 --nogcroots";
    };
    flake = "${config.home.homeDirectory}/tochki";
  };

  systemd.user.services.nh-clean.Service.Environment =
    "PATH=${lib.makeBinPath [ pkgs.nix pkgs.coreutils ]}";
}
