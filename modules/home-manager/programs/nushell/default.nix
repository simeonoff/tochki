{ pkgs, config, ... }: {

  # Use zsh only as a login shell and immediately load nushell
  programs.zsh = {
    enable = true;
    dotDir = "${config.xdg.configHome}/zsh";
    initContent = /* bash */ ''
      exec ${pkgs.nushell}/bin/nu
    '';
  };

  # Use nushell as the default shell
  programs.nushell = {
    enable = true;
    # Keep the pre-26.11 behaviour (session variables are not auto-loaded);
    # setting it explicitly silences the Home Manager evaluation warning.
    loadSessionVariables = false;
    configFile.source = ./config/config.nu;
    envFile.source = ./config/env.nu;
    environmentVariables = {
      NPM_CONFIG_PREFIX = "${config.home.homeDirectory}/.npm-global";
      LG_CONFIG_FILE = "${config.home.homeDirectory}/.config/lazygit/config.yml,${config.home.homeDirectory}/.config/lazygit/theme.yml";
    };
  };
}
