# The inputs and nixosModules can be used later on to further split the configuration
{ hostname, nixosModules, pkgs, ... }: {

  imports = [
    ./hardware-configuration.nix
    "${nixosModules}/common"
  ];

  # Set hostname
  networking.hostName = hostname; # Define your hostname.

  # This is a virtual machine, add the parallel tools for it.
  environment.systemPackages = with pkgs; [
    linuxKernel.packages.linux_6_6.prl-tools
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
