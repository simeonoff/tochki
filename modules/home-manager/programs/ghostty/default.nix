{ ... }: {
  programs.ghostty = {
    enable = true;
    settings = {
      theme = "rose-pine";
      font-family = "Iosevka";
      font-size = 12;
      cursor-opacity = 0.7;
      cursor-invert-fg-bg = false;
      window-decoration = true;
      window-padding-x = 10;
      window-padding-y = 10;
      window-padding-balance = true;
      font-thicken = false;
      macos-option-as-alt = true;
      window-colorspace = "display-p3";
      mouse-hide-while-typing = true;
    };
  };
}
