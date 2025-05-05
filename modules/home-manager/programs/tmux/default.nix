{ pkgs, ... }: {

  programs.tmux = {
    enable = true;
    shortcut = "space";
    escapeTime = 0;
    mouse = true;
    keyMode = "vi";
    baseIndex = 1;
    terminal = "tmux-256color";

    plugins = with pkgs; [
      tmuxPlugins.yank
      tmuxPlugins.vim-tmux-navigator
      {
        plugin = tmuxPlugins.minimal-tmux-status;
        extraConfig = /* bash */ ''
          # Minimal Tmux Status configuration
          set -g @minimal-tmux-theme 'rose-pine'
          set -g @minimal-tmux-justify 'center'
          set -g @minimal-tmux-indicator true
          set -g @minimal-tmux-status 'top'
          set -g @minimal-tmux-show-expanded-icon-for-all-tabs true

          # Set the window status format
          set -g @minimal-tmux-window-status-format "#I: #W"

          # Enables or disables the left and right status bar
          set -g @minimal-tmux-right false
          set -g @minimal-tmux-status-right " %I:%M %p "
        '';
      }
    ];

    extraConfig = /* bash */ ''
      set -ga terminal-overrides ',*256col*:Tc'
      set -g detach-on-destroy off
      set -g allow-rename off
      setw -g automatic-rename off
      set -g set-titles on
      set-option -g focus-events on
      set -g pane-base-index 1
      set-window-option -g pane-base-index 1

      # Enable undercurl support
      set -ga terminal-features ",*:usstyle"
      set -gs terminal-overrides ",*:RGB"

      bind P paste-buffer

      bind | split-window -h
      bind - split-window -v
      unbind '"'
      unbind %

      bind-key x kill-pane

      # Vim Keybindings
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
      bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel

      # Relaod TMUX config
      unbind r
      bind r source-file ~/.tmux.conf \; display-message "Config reloaded!"

      # Resize panes
      bind -r Left resize-pane -L 5 # Resize pane 10 cells to the left
      bind -r Down resize-pane -D 5 # Resize pane 10 cells down
      bind -r Up resize-pane -U 5 # Resize pane 10 cells up
      bind -r Right resize-pane -R 5 # Resize pane 10 cells to the right

      set-window-option -g pane-border-status top
      set-window-option -g pane-border-format ""

      # Run lazygit in a new window named "Lazygit" when G is pressed
      bind g new-window -n "Lazygit" lazygit
      bind c new-window -n "Nushell"

    '';
  };
}
