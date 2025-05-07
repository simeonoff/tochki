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
      "nikitabobko/tap/aerospace"
      "raycast"
      "scroll-reverser"
      "sensiblesidebuttons"
      "the-unarchiver"
      "viscosity"
    ];
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
