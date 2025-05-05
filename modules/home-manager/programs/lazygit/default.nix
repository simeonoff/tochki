{ ... }: {
  programs.lazygit = {
    enable = true;
    settings = {
      gui.theme = {
        selectedLineBgColor = [ "black" ];
      };
      nerdFontsVersion = 3;
    };
  };
}
