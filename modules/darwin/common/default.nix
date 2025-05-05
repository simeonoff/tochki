{ pkgs, userConfig, outputs, ... }:
{
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
    };
    optimise.automatic = true;
    package = pkgs.nix;
  };

  # Nixpkgs configuration
  nixpkgs = {
    config = {
      allowUnfree = true;
    };

    overlays = [ outputs.overlays.default ];
    hostPlatform = "aarch64-darwin";
  };

  environment.shells = [
    pkgs.bash
    pkgs.zsh
  ];

  # Zsh configuration
  programs.zsh.enable = true;

  # Define the user more explicitly
  users.users.${userConfig.name} = {
    name = userConfig.fullName;
    home = "/Users/${userConfig.name}";
    shell = pkgs.zsh;
  };

  # Add ability to use TouchID for sudo
  security.pam.services.sudo_local.touchIdAuth = true;

  # WARN: Do I need this anymore?
  environment.variables = {
    XDG_CONFIG_HOME = "$HOME/.config";
  };

  fonts.packages = [
    pkgs.maple-mono.truetype
    pkgs.iosevka
  ];

  # Adjust system settings
  system = {
    defaults = {
      dock = {
        autohide = true;
        minimize-to-application = true;
      };
    };
  };
}

