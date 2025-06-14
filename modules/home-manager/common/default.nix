{ outputs, config, userConfig, lib, pkgs, ... }:
{
  imports = [
    ../programs/aerospace
    ../programs/carapace
    ../programs/direnv
    ../programs/fzf
    ../programs/ghostty
    ../programs/git
    ../programs/karabiner
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

  # Nixpkgs configuration
  nixpkgs = {
    config = {
      allowUnfree = true;
    };

    overlays = [ outputs.overlays.default ];
  };

  home = {
    username = userConfig.name;
    homeDirectory =
      if pkgs.stdenv.isDarwin
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

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;
    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Ensure common packages are installed
  home.packages = with pkgs; [
    curl
    dart-sass
    docfx
    dotnet-sdk_9
    eza
    fd
    git
    go
    just
    lua51Packages.lua
    lua51Packages.luarocks
    lynx
    mosh
    nh # Nix helper
    nodePackages.nodejs
    pkg-config
    python313
    python313Packages.west
    ripgrep
    silver-searcher
    tree
    tree-sitter
    wezterm
    wget
    xz

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ]
  ++ lib.optionals (!stdenv.isDarwin) [
    bitwarden-desktop
    brave
    vesktop
    vivaldi
    wl-clipboard
  ]
  ++ lib.optionals stdenv.isDarwin [
    _1password-cli
    aerospace
    cmake
    openssl
  ];
}
