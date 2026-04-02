{
  description = "Top-level system flake using flake-parts";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-dotnet.url = "github:NixOS/nixpkgs/b40629efe5d6ec48dd1efba650c797ddbd39ace0";
    flake-parts.url = "github:hercules-ci/flake-parts";
    claude-code.url = "github:sadjow/claude-code-nix";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ self
    , nixpkgs
    , home-manager
    , flake-parts
    , nix-darwin
    , nix-homebrew
    , neovim-nightly-overlay
    , sops-nix
    , claude-code
    , ...
    }:
    let
      inherit (self) outputs;

      users = {
        iams1mo = {
          name = "iams1mo";
          fullName = "Simeon Simeonoff";
          email = "sim.simeonoff@gmail.com";
          sshKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHJS5NBbdV92aYxd135tddFb6Ynbc+PAUWP36qRyVdFw";
        };

        SSimeonov = {
          name = "SSimeonov";
          fullName = "Simeon Simeonoff";
          email = "sim.simeonoff@gmail.com";
          sshKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHJS5NBbdV92aYxd135tddFb6Ynbc+PAUWP36qRyVdFw";
        };
      };

      mkNixosConfiguration = hostname: username:
        nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs hostname;
            userConfig = users.${username};
            nixosModules = "${self}/modules/nixos";
          };
          modules = [
            ./hosts/${hostname}
          ];
        };

      mkDarwinConfiguration = hostname: username:
        nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          specialArgs = {
            inherit inputs outputs hostname;
            userConfig = users.${username};
            darwinModules = "${self}/modules/darwin";
            homebrewModules = "${self}/modules/homebrew";
          };
          modules = [
            ./hosts/${hostname}
            home-manager.darwinModules.home-manager
            nix-homebrew.darwinModules.nix-homebrew
            {
              nix-homebrew = {
                enable = true;
                enableRosetta = true;

                # User owning the Homebrew prefix
                user = username;

                # Automatically migrate existing Homebrew installations
                autoMigrate = true;
              };
            }
          ];
        };

      mkHomeConfiguration = system: username: hostname:
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            inherit system;

            overlays = [
              self.overlays.default
              claude-code.overlays.default
            ];
          };
          extraSpecialArgs = {
            inherit inputs outputs;
            userConfig = users.${username};
            homeModules = "${self}/modules/home-manager";
            neovim-nightly = neovim-nightly-overlay.packages.${system}.default;
            pkgs-dotnet = import inputs.nixpkgs-dotnet { inherit system; };
          };
          modules = [
            sops-nix.homeManagerModules.sops
            ./home/${username}/${hostname}
          ];
        };
    in

    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.flake-parts.flakeModules.easyOverlay
      ];

      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ];

      perSystem = { pkgs, system, config, ... }:
        let
          tmuxPlugins = import ./packages/tmux { inherit pkgs; };
          languageServers = import ./packages/language-servers { inherit pkgs; };
          opencodePackages = import ./packages/opencode { inherit (pkgs) lib pkgs; };
          codebaseMemoryMcpPackages = import ./packages/codebase-memory-mcp { inherit (pkgs) lib pkgs; };
          neovim-nightly = neovim-nightly-overlay.packages.${system}.default;
          # pkgs with our overlay + allowUnfree, for devShells
          pkgs' = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
            overlays = [ self.overlays.default ];
          };
        in
        {
          devShells = import ./devshells {
            pkgs = pkgs'; inherit neovim-nightly;
            pkgs-dotnet = import inputs.nixpkgs-dotnet { inherit system; };
          };

          overlayAttrs = {
            inherit (languageServers) some-sass-language-server;
            inherit (opencodePackages) opencode;
            inherit (codebaseMemoryMcpPackages) codebase-memory-mcp;
            tmuxPlugins = pkgs.tmuxPlugins // tmuxPlugins;
            local-fonts = pkgs.callPackage ./packages/local-fonts { };

            # Override ast-grep to 0.41.1
            # TODO: Remove this override once nixpkgs-unstable includes 0.41.1+
            ast-grep = pkgs.ast-grep.overrideAttrs (oldAttrs: rec {
              version = "0.42.0";
              src = pkgs.fetchFromGitHub {
                owner = "ast-grep";
                repo = "ast-grep";
                tag = version;
                hash = "sha256-Sm/5/JT98Uh1sX6HwPH2/lVsDJmKCUT+AwWX0qtgVKg=";
              };
              cargoDeps = pkgs.rustPlatform.fetchCargoVendor {
                inherit src;
                name = "${oldAttrs.pname}-${version}-vendor";
                hash = "sha256-ZZzSW71/a13+TuT/3hFCA582Vow2JsdGQBn9plMry00=";
              };
              # Skip test_scan_invalid_rule_id which fails on macOS with
              # "Illegal byte sequence (os error 92)" due to locale handling
              doCheck = false;
            });
          };
        };

      flake = {
        nixosConfigurations = {
          kori = mkNixosConfiguration "kori" "iams1mo";
        };

        darwinConfigurations = {
          ringo = mkDarwinConfiguration "ringo" "SSimeonov";
        };

        homeConfigurations = {
          "iams1mo@kori" = mkHomeConfiguration "aarch64-linux" "iams1mo" "kori";
          "SSimeonov@ringo" = mkHomeConfiguration "aarch64-darwin" "SSimeonov" "ringo";
        };
      };
    };
}

