{ ... }:
{
  programs.ssh = {
    enable = true;
    extraConfig = /* bash */ ''
      Host *
          IdentityAgent ~/.bitwarden-ssh-agent.sock
    '';
  };
}
