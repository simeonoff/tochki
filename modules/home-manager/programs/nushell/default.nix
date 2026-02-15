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
    configFile.source = ./config/config.nu;
    envFile.source = ./config/env.nu;
    environmentVariables = {
      NPM_CONFIG_PREFIX = "${config.home.homeDirectory}/.npm-global";
      SSH_AUTH_SOCK = "${config.home.homeDirectory}/.bitwarden-ssh-agent.sock";
    };
  };
}
