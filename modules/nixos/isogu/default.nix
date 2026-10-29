{ outputs, pkgs, userConfig, ... }: {
  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;

  nix.optimise.automatic = true;

  # Nix settings
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
  };

  # Set your time zone.
  time.timeZone = "Europe/Sofia";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "bg_BG.UTF-8";
    LC_IDENTIFICATION = "bg_BG.UTF-8";
    LC_MEASUREMENT = "bg_BG.UTF-8";
    LC_MONETARY = "bg_BG.UTF-8";
    LC_NAME = "bg_BG.UTF-8";
    LC_NUMERIC = "bg_BG.UTF-8";
    LC_PAPER = "bg_BG.UTF-8";
    LC_TELEPHONE = "bg_BG.UTF-8";
    LC_TIME = "bg_BG.UTF-8";
  };

  virtualisation.docker = {
    enable = true;
    daemon= {
        settings = {
            "log-driver"= "json-file";
            "log-opts" = {
                "max-size" = "50m";
                "max-file" = "3";
            };
        };
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${userConfig.name} = {
    isNormalUser = true;
    description = userConfig.fullName;
    extraGroups = [ "wheel" "docker" ];
    shell = pkgs.zsh;
    openssh = {
      authorizedKeys = {
        keys = [ ''ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDDPqhMTJAhICrnYYeUizGG7KCml0MFTXIylhzJeFiUuYpD4AEg9eK/ygKtDCW8uizjjYxMaLQS42pGtcZ752Ka4qt8c1DbO9JcZBEJsiVt2FnsztakcpRnm7ja5ZQGH2LB9WRQaaVrl0kC/IpP4FP5t0ZWxAJvF6xdgDSLnl1v3M/OmjDwUHNBXab57sPSMbvdrsZwLSn5i7nlhecFk1XG88Gcxkt2EFeXo3NnsGr5Kh0XeQ51oKOPLwII1VgYv+7j7Y4sGmz3brytXQDB149z9llNMy5B20gIEzFdz+w+GCfV6ijuXM2iMGhbhwZO0IWqCgPH9wvwWTfo3lr1UqeI5OyWL+28rvsRBieRQXOycyTfJ9Zqu331lFz43/0XYafol8efJKPDwnljA0cMeo+jOkH86moHtQ0MyFEWyUrVCaFD4XJ6Fq6tD3Geu+h/HhHbD6GH7cJ6NzDyZpHEB4+IcTQY0gFcg7NiRmp24Wzmt4nJQTtoXbkN9fZH8jeEv16Fap3S0kmliBE10j9pGZOwQXf3CL/LPCR/kUs8qs6UE/kiw5V/1j0P9mcYR6GatqfjG8DHoph339TaBkvlJi4RxManQXDAJPhU+wfR+UysJBJV0g7MukwGhQcjwg+55IQ7VUsPaYRzKLOOHVZU6uYgk3xdZkuANOhpiSmKYyVdGw=='' userConfig.sshKey];
      };
    };
  };

  # Nixpkgs configuration
  nixpkgs = {
    config = {
      allowUnfree = true;
    };

    overlays = [ outputs.overlays.default ];
  };

  programs.zsh.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # C build tools, order is important
    clang-tools
    clang
    gnumake
    bear

    # Docker
    docker-compose

    #Networking
    mosh
  ];

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;

    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Allow mosh related ports
  networking.firewall.allowedUDPPortRanges = [
    { from = 60000; to = 61000; }
  ];

  system.autoUpgrade = {
    enable = false;
    allowReboot = true;
  };

  systemd.services.app-db-backups = {
    description = "Consistent database copies for Vaultwarden and tuwunel";
    path = [ pkgs.docker pkgs.findutils ];
    serviceConfig.Type = "oneshot";
    script = ''
      docker exec vaultwarden /vaultwarden backup
      docker kill -s USR2 tuwunel
      find /home/iams1mo/docker/apps/vaultwarden -maxdepth 1 -name 'db_*.sqlite3' -mtime +2 -delete
    '';
  };

  systemd.timers.app-db-backups = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "*-*-* 02,08,14,20:50:00";
      Persistent = true;
    };
  };
}
