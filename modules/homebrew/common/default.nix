{ ... }:

{
  homebrew = {
    enable = true;
    brews = [
      "mas"
      "ninja"
    ];
    casks = [
      "1password"
      "nikitabobko/tap/aerospace"
      "bartender"
      "firefox"
      "font-symbols-only-nerd-font"
      "ghostty"
      "raycast"
      "the-unarchiver"
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
