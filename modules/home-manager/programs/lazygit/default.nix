{ ... }: {
  programs.lazygit = {
    enable = true;
    settings = {
      nerdFontsVersion = 3;
      git.overrideGpg = true;
    };
  };
}
