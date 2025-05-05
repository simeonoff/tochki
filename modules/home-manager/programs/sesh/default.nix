{ ... }: {
  programs.sesh = {
    enable = true;
    enableAlias = false;
    icons = false;
    enableTmuxIntegration = true;
    tmuxKey = "t";
    settings = {
      default_session = {
        startup_command = "tmux rename-window 'Neovim'; tmux send-keys 'vim' Enter";
      };
    };
  };
}
