{ config, lib, pkgs, userConfig, outputs, ... }:
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

  environment.variables = {
    XDG_CONFIG_HOME = "$HOME/.config";
  };

  fonts.packages = [
    pkgs.maple-mono.truetype
    pkgs.local-fonts
  ];

  # Adjust system settings
  system = {
    defaults = {
      CustomUserPreferences = {
        NSGlobalDomain."com.apple.mouse.linear" = true;
      };
      NSGlobalDomain = {
        AppleInterfaceStyle = "Dark";
        ApplePressAndHoldEnabled = false;
        AppleShowAllExtensions = true;
        AppleKeyboardUIMode = 3;
        KeyRepeat = 2;
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticDashSubstitutionEnabled = false;
        NSAutomaticQuoteSubstitutionEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;
        NSAutomaticWindowAnimationsEnabled = false;
        NSDocumentSaveNewDocumentsToCloud = false;
        NSNavPanelExpandedStateForSaveMode = true;
        NSTableViewDefaultSizeMode = 2;
        PMPrintingExpandedStateForPrint = true;
      };
      WindowManager = {
        AppWindowGroupingBehavior = true;
      };
      hitoolbox = {
        AppleFnUsageType = "Do Nothing";
      };
      trackpad = {
        TrackpadRightClick = true;
        TrackpadThreeFingerDrag = true;
        Clicking = true;
      };
      finder = {
        AppleShowAllFiles = false;
        CreateDesktop = false;
        FXDefaultSearchScope = "SCcf";
        FXEnableExtensionChangeWarning = false;
        FXPreferredViewStyle = "Nlsv";
        ShowPathbar = true;
        ShowStatusBar = true;
        _FXShowPosixPathInTitle = true;
        _FXSortFoldersFirst = true;
      };
      dock = {
        autohide = true;
        tilesize = 42;
        show-recents = false;
        showhidden = true;
        expose-animation-duration = 0.15;
        minimize-to-application = true;
        wvous-tl-corner = 1;
        wvous-tr-corner = 1;
        wvous-bl-corner = 1;
        wvous-br-corner = 1;
      };
      screencapture = {
        location = "/Users/${userConfig.name}/Downloads/tmp";
        type = "png";
        disable-shadow = false;
      };
    };

    # Set up system-level Nix apps in /Applications
    activationScripts.applications.text =
      let
        env = pkgs.buildEnv {
          name = "system-applications";
          paths = config.environment.systemPackages;
          pathsToLink = "/Applications";
        };
      in
      lib.mkForce ''
        #Set up applications.
        echo "setting up /Applications..." >&2
        rm -rf /Applications/Nix\ Apps
        mkdir -p /Applications/Nix\ Apps
        find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
        while read -r src; do
            app_name=$(basename "$src")
            echo "copying $src" >&2
            ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
        done
      '';
  };
}

