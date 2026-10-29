{ config, ... }: {
  programs.fzf = {
    enable = true;
    # fzf's bundled completion.nu (`**<Tab>`) uses the positional completer
    # input that nushell 0.116 deprecates, warning on every shell start. Load
    # only the key bindings (Ctrl+R, Ctrl+T, Alt+C) instead of the full
    # integration; switch back to the integration once fzf ships a fix.
    enableNushellIntegration = false;
    tmux = {
      enableShellIntegration = true;
    };
  };

  programs.nushell.extraConfig = ''
    source ${config.programs.fzf.package}/share/fzf/key-bindings.nu
  '';
}
