{ outputs, config, userConfig, lib, pkgs, ... }:
{
  imports = [
    ../programs/carapace
    ../programs/direnv
    ../programs/fzf
    ../programs/git
    ../programs/lazygit
    ../programs/neovim
    ../programs/nh
    ../programs/nushell
    ../programs/sesh
    ../programs/starship
    ../programs/tmux
    ../programs/zoxide
  ];

  # Nixpkgs configuration
  nixpkgs = {
    config = {
      allowUnfree = true;
    };

    overlays = [ outputs.overlays.default ];
  };

  home = {
    username = userConfig.name;
    homeDirectory = "/home/${userConfig.name}";
  };

  home.activation = {
    createNpmGlobalDir = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      mkdir -p "${config.home.homeDirectory}/.npm-global"
    '';
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    NPM_CONFIG_PREFIX = "${config.home.homeDirectory}/.npm-global";
    FLAKE = "${config.home.homeDirectory}/tochki";
  };

  xdg.enable = true;

  # Ensure common packages are installed
  home.packages = with pkgs; [
    curl
    eza
    fd
    git
    just
    lua51Packages.lua
    lua51Packages.luarocks
    lynx
    nh # Nix helper
    nodePackages.nodejs
    pkg-config
    ripgrep
    silver-searcher
    tree
    tree-sitter
    wget
    xz
  ];
}
