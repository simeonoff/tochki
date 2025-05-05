{ userConfig, lib, pkgs, ... }:
let
  opSSHSignExe =
    if pkgs.stdenv.isDarwin
    then "/Applications/1Password.app/Contents/MacOS/op-ssh-sign"
    else "${lib.getExe' pkgs._1password-gui "op-ssh-sign"}";
in
{
  programs.git = {
    enable = true;
    extraConfig = {
      gpg = {
        format = "ssh";
      };

      "gpg \"ssh\"" = {
        program = opSSHSignExe;
      };

      commit = {
        gpgsign = true;
      };

      user = {
        email = userConfig.email;
        name = userConfig.fullName;
        signingKey = userConfig.sshKey;
      };
    };
  };
}
