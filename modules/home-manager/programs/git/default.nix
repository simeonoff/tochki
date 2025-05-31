{ userConfig, ... }:
{
  programs.git = {
    enable = true;
    extraConfig = {
      gpg = {
        format = "ssh";
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
