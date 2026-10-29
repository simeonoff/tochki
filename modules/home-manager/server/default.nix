# Headless servers (isogu). No desktop SSH agent, so two dedicated per-host
# keys without passphrase are used (GitHub refuses one key for both roles):
#   ~/.ssh/id_ed25519_github         signs commits (GitHub: Signing Key)
#   ~/.ssh/id_ed25519_tochki_deploy  pushes tochki (repo Deploy key, write)
{ config, lib, ... }:
let
  sshDir = "${config.home.homeDirectory}/.ssh";
in
{
  programs.git.settings.user.signingKey = lib.mkForce "${sshDir}/id_ed25519_github";

  programs.ssh.settings."github.com" = {
    IdentityFile = "${sshDir}/id_ed25519_tochki_deploy";
    IdentitiesOnly = true;
  };
}
