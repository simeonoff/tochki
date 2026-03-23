{ userConfig, ... }:
{
  programs.git = {
    enable = true;
    signing.format = null;
    settings = {
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
