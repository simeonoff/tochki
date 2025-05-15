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
      "bartender"
      "betterdisplay"
      "firefox"
      "font-symbols-only-nerd-font"
      "ghostty"
      "karabiner-elements"
      "raycast"
      "scroll-reverser"
      "sensiblesidebuttons"
      "the-unarchiver"
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
      # Uncomment after a new install
      # cleanup = "zap";
      autoUpdate = true;
      upgrade = true;
    };
    # Ensure applications are linked to /Applications
    caskArgs.appdir = "/Applications";
  };
}
