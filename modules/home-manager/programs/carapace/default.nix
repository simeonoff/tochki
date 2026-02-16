{ pkgs, lib, config, ... }:
let
  bin = lib.getExe config.programs.carapace.package;
in
{
  programs.carapace = {
    enable = true;
    # Disable the default nushell integration because the home-manager module
    # runs `carapace _carapace nushell` at build time inside the nix sandbox
    # where HOME=/homeless-shelter. On macOS this produces a PATH entry with
    # "Library/Application Support" (contains a space) which breaks `env`.
    enableNushellIntegration = false;
  };

  # Provide our own nushell integration with XDG_CONFIG_HOME set at build time
  # so carapace outputs a space-free path (~/.config/carapace/bin instead of
  # ~/Library/Application Support/carapace/bin).
  programs.nushell.extraConfig = ''
    source ${
      pkgs.runCommand "carapace-nushell-config.nu" {
        HOME = "/homeless-shelter";
        XDG_CONFIG_HOME = "/homeless-shelter/.config";
      } ''
        ${bin} _carapace nushell | sed 's|"/homeless-shelter|$"($env.HOME)|g' >> "$out"
      ''
    }
  '';
}
