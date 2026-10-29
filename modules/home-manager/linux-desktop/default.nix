# Desktop Linux machines (kori): GUI apps that macOS gets elsewhere.
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    bitwarden-desktop
    brave
    vesktop
    vivaldi
    wl-clipboard
  ];
}
