# Everything every machine gets: shell, editor, git, terminal tooling.
# Machines compose this with the workstation / darwin / linux-desktop /
# server profiles in home/<user>/<host>/default.nix.
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
    ../programs/ssh
    ../programs/starship
    ../programs/tmux
    ../programs/zoxide
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;
      # stylelint-lsp pulls in pnpm 9.15.9 at build time, which recent nixpkgs
      # flags insecure (CVE-2026-48995 et al.). It's only a build dependency.
      permittedInsecurePackages = [ "pnpm-9.15.9" ];
    };

    overlays = [ outputs.overlays.default ];
  };

  home = {
    username = userConfig.name;
    homeDirectory =
      if pkgs.stdenv.hostPlatform.isDarwin
      then "/Users/${userConfig.name}"
      else "/home/${userConfig.name}";
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

  home.packages = with pkgs; [
    curl
    eza
    fd
    git
    just
    lua51Packages.lua
    lua51Packages.luarocks
    lynx
    mosh
    nh # Nix helper
    nodejs
    pkg-config
    ripgrep
    tree
    tree-sitter
    wget
    xz
  ];
}
