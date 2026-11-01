# Heartbeat to an external monitor; alerts when this host goes silent.
# Ping URL is kept outside the repo, root-only: /etc/healthchecks/isogu.url
{ pkgs, ... }:
{
  systemd.services.heartbeat = {
    description = "Heartbeat ping";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    path = [ pkgs.curl ];
    serviceConfig.Type = "oneshot";
    script = ''
      curl -fsS -m 10 --retry 3 -o /dev/null "$(cat /etc/healthchecks/isogu.url)"
    '';
  };

  systemd.timers.heartbeat = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "1min";
      OnUnitActiveSec = "5min";
    };
  };
}
