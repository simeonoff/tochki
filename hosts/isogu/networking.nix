{ lib, ... }: {
  # This file was populated at runtime with the networking
  # details gathered from the active system.
  networking = {
    nameservers = [
      "8.8.8.8"
    ];
    # The interface must be named: since NixOS 26.11 the scripted networking
    # only sets gateways per interface (network-setup.service is gone), and a
    # bare address leaves the box without an IPv4 default route.
    defaultGateway = {
      address = "172.31.1.1";
      interface = "eth0";
    };
    defaultGateway6 = {
      address = "fe80::1";
      interface = "eth0";
    };
    dhcpcd.enable = false;
    usePredictableInterfaceNames = lib.mkForce false;
    interfaces = {
      eth0 = {
        ipv4.addresses = [
          { address = "157.180.89.153"; prefixLength = 32; }
        ];
        ipv6.addresses = [
          { address = "2a01:4f9:c013:19f6::1"; prefixLength = 64; }
          { address = "fe80::9400:4ff:fe55:f03b"; prefixLength = 64; }
        ];
        ipv4.routes = [{ address = "172.31.1.1"; prefixLength = 32; }];
        ipv6.routes = [{ address = "fe80::1"; prefixLength = 128; }];
      };

    };
  };
  services.udev.extraRules = ''
    ATTR{address}=="96:00:04:55:f0:3b", NAME="eth0"
  '';
}
