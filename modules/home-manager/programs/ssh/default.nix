{ ... }:
let
  onePassPath =
    if pkgs.stdenv.isDarwin
    then "/Users/${config.home.username}/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
    else "~/.1password/agent.sock";
in
{
  programs.ssh = {
    enable = true;
    extraConfig = ''
      Host *
          IdentityAgent ${onePassPath}
    '';
  };
}
