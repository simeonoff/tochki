{ ... }: {
  programs.direnv = {
    enable = true;
    enableNushellIntegration = true;
    nix-direnv.enable = true;
    config = {
      global = {
        log_format = "-";
        log_filter = "^$";
      };
    };
  };
}
