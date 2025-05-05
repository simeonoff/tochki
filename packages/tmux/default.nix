{ pkgs, ... }:

{
  vim-tmux-navigator = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "vim-tmux-navigator";
    version = "unstable";

    src = pkgs.fetchFromGitHub {
      owner = "simeonoff";
      repo = "vim-tmux-navigator";
      rev = "c771a01cf8b28faaca6cf0dd091c6b05da182977";
      hash = "sha256-fpxqJtSilKFznrhvxQmqNN7nCRncp9qN8+cLy6FIBUM=";
    };
    rtpFilePath = "vim-tmux-navigator.tmux";
  };

  minimal-tmux-status = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "minimal-tmux-status";
    version = "unstable";

    src = pkgs.fetchFromGitHub {
      owner = "simeonoff";
      repo = "minimal-tmux-status";
      rev = "5ddc926d9cddc6c4f76029eed7b08e60b9fb813b";
      hash = "sha256-W3ReFDJ2IrLSn+Lw4c5/AwqC7N8sACr7ilZfST3STrA=";
    };
    rtpFilePath = "minimal.tmux";
  };
}
