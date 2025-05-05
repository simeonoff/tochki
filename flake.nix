{
  description = "Top-level system flake using flake-parts";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, flake-parts, nix-darwin, nix-homebrew, ... }:
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

      mkHomeConfiguration = system: username: hostname:
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs { inherit system; };
          extraSpecialArgs = {
            inherit inputs outputs;
            userConfig = users.${username};
            homeModules = "${self}/modules/home-manager";
          };
          modules = [
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
        in
        {
          devShells = import ./devshells { inherit pkgs; };

          overlayAttrs = {
            inherit (languageServers) some-sass-language-server;
            tmuxPlugins = pkgs.tmuxPlugins // tmuxPlugins;
          };
        };

      flake = {
        nixosConfigurations = {
          kori = mkNixosConfiguration "kori" "iams1mo";
        };

        homeConfigurations = {
          "iams1mo@kori" = mkHomeConfiguration "aarch64-linux" "iams1mo" "kori";
        };
      };
    };
}

