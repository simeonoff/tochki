# Headless servers (isogu). No desktop SSH agent: a dedicated per-host key
# (~/.ssh/id_ed25519_github) signs commits and pushes to GitHub. Register its
# public key on GitHub as a signing key and as a deploy key (write) on tochki.
{ config, lib, ... }:
let
  githubKey = "${config.home.homeDirectory}/.ssh/id_ed25519_github";
in
{
  programs.git.settings.user.signingKey = lib.mkForce githubKey;

  programs.ssh.settings."github.com" = {
    IdentityFile = githubKey;
    IdentitiesOnly = true;
  };
}
