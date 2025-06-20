{ ... }:

{
  homebrew = {
    enable = true;
    brews = [
      "mas"
      "ninja"
    ];
    taps = [ ];
    casks = [
      "1password"
      "android-platform-tools"
      "bartender"
      "betterdisplay"
      "bitwarden"
      "brave-browser"
      "firefox"
      "font-symbols-only-nerd-font"
      "ghostty"
      "gpg-suite"
      "karabiner-elements"
      "raycast"
      "scroll-reverser"
      "sensiblesidebuttons"
      "the-unarchiver"
      "vesktop"
      "viscosity"
    ];
    masApps = {
      "Color Picker" = 1545870783;
      "Parcel" = 639968404;
      "Unsplash Wallpapers" = 1284863847;
      "Wipr 2" = 1662217862;
      "WireGuard" = 1451685025;
    };
    onActivation = {
      cleanup = "zap";
      autoUpdate = true;
      upgrade = true;
    };
    # Ensure applications are linked to /Applications
    caskArgs.appdir = "/Applications";
  };
}
