{ pkgs, lib, config, ... }:
let
  commonSettings = {
    theme = "Rose Pine";
    font-family = "Iosevka Term";
    cursor-opacity = 0.7;
    cursor-invert-fg-bg = false;
    window-padding-x = 10;
    window-padding-y = 5;
    window-padding-balance = true;
    font-thicken = false;
    mouse-hide-while-typing = true;
    macos-titlebar-style = "hidden";
    shell-integration = "zsh";
    shell-integration-features = [ "ssh-terminfo" ];
  };

  darwinSettings = {
    font-size = 15;
    macos-option-as-alt = true;
    window-colorspace = "display-p3";
  };

  linuxSettings = {
    font-size = 12;
  };

  platformSettings =
    if pkgs.stdenv.isDarwin
    then commonSettings // darwinSettings
    else commonSettings // linuxSettings;
in
{
  programs.ghostty = {
    enable = true;
    # On Darwin, use null package since we install via Homebrew
    # On Linux, use the default package
    package = lib.mkIf pkgs.stdenv.isDarwin (lib.mkForce null);
    settings = platformSettings;
  };

  # Create a manual XDG config symlink for Darwin if needed
  home.activation = lib.mkIf pkgs.stdenv.isDarwin {
    linkGhosttyConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      # Ensure config dir exists
      $DRY_RUN_CMD mkdir -p "${config.home.homeDirectory}/.config/ghostty"
      
      # Get the path to the generated config
      SRC="${config.xdg.configHome}/ghostty/config"
      DEST="${config.home.homeDirectory}/.config/ghostty/config"
      
      # Create symlink if the source exists and destination doesn't
      if [ -f "$SRC" ] && [ ! -f "$DEST" ]; then
        $DRY_RUN_CMD ln -sf "$SRC" "$DEST"
        echo "Linked Ghostty config to ~/.config/ghostty/config"
      fi
    '';
  };
}
