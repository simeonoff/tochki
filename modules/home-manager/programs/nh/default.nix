{ config, ... }:

{
  programs.nh = {
    enable = true;
    clean.enable = false;
    flake = "${config.home.homeDirectory}/tochki";
  };
}
