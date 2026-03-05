{ ... }: {
  programs.starship = {
    enable = true;
    enableNushellIntegration = true;
    settings = {
      add_newline = true;
      command_timeout = 1000;
      git_branch = {
        symbol = "󰘬 ";
        truncation_symbol = "";
      };
      nodejs = {
        format = "via [Node.js $version](bold green) ";
      };
      package = {
        disabled = true;
      };
      battery = {
        disabled = true;
      };
    };
  };
}
