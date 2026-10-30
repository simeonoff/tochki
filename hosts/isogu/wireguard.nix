# WireGuard link to home, routing only the NAS.
# Keys and endpoint (host:port) are kept outside the repo, root-only:
#   /etc/wireguard/wg-home.{key,psk,endpoint}
{ pkgs, ... }:
let
  peerKey = "SV2XJSN1LSDVWQBn/PLLRmlN4VFwzlmQAFpEvuZ2cUA=";
in
{
  networking.wireguard.interfaces.wg-home = {
    ips = [ "172.16.16.5/32" ];
    privateKeyFile = "/etc/wireguard/wg-home.key";

    peers = [
      {
        name = "home";
        publicKey = peerKey;
        presharedKeyFile = "/etc/wireguard/wg-home.psk";
        allowedIPs = [ "10.15.21.77/32" ];
        persistentKeepalive = 25;
      }
    ];
  };

  systemd.services.wg-home-endpoint = {
    description = "Set wg-home peer endpoint";
    after = [ "wireguard-wg-home.service" "wireguard-wg-home-peer-home.service" ];
    requires = [ "wireguard-wg-home.service" ];
    wantedBy = [ "wireguard-wg-home.service" ];
    path = [ pkgs.wireguard-tools ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      wg set wg-home peer ${peerKey} endpoint "$(cat /etc/wireguard/wg-home.endpoint)"
    '';
  };
}
