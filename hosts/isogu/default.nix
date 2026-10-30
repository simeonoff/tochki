# The inputs and nixosModules can be used later on to further split the configuration
{ hostname, nixosModules, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./networking.nix
    ./wireguard.nix
    "${nixosModules}/isogu"
  ];

  # Set hostname
  networking.hostName = hostname;
  networking.domain = "";

  system.stateVersion = "23.11";
}
