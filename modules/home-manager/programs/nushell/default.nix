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
      LG_CONFIG_FILE = "${config.home.homeDirectory}/.config/lazygit/config.yml,${config.home.homeDirectory}/.config/lazygit/theme.yml";
    };
    extraEnv = ''
      $env.GITHUB_PAT = (open "${config.sops.secrets.github_pat.path}" | str trim)
      $env.CONTEXT7_API_KEY = (open "${config.sops.secrets.context7_api_key.path}" | str trim)
    '';
  };
}
