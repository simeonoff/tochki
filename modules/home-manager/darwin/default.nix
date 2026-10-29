# macOS-only programs and packages (ringo).
{ pkgs, ... }:
{
  imports = [
    ../programs/aerospace
    ../programs/karabiner
  ];

  home.packages = with pkgs; [
    _1password-cli
    aerospace
    cmake
    mpv
    openssl
  ];
}
