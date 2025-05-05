{ pkgs, config, ... }:
{
  programs.ssh = {
    enable = true;
    extraConfig = 
      if pkgs.stdenv.isDarwin then  /* bash */ ''
        Host *
            # On macOS, we need quotes around the path because it contains spaces
            IdentityAgent "/Users/${config.home.username}/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
      '' else /* bash */ ''
        Host *
            IdentityAgent ~/.1password/agent.sock
      '';
  };
}
