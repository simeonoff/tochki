{ pkgs
, config
, lib
# , neovim-nightly
, ...
}:

let
  neovimTools = import ../../../../packages/neovim-tools { inherit pkgs; };
in
{
  # Keep Neovim config live by linking at activation time.
  home.activation.neovimConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    $DRY_RUN_CMD mkdir -p "${config.xdg.configHome}"
    $DRY_RUN_CMD ln -sfn "${config.home.homeDirectory}/tochki/modules/home-manager/programs/neovim/config/nvim" "${config.xdg.configHome}/nvim"
  '';
  programs.neovim = {
    # package = neovim-nightly;
    enable = true;
    extraPackages = neovimTools;
    extraWrapperArgs = [
      "--set"
      "VSCODE_JS_DEBUG_PATH"
      "${pkgs.vscode-js-debug}/lib/node_modules/js-debug/dist/src/dapDebugServer.js"
    ];
    withNodeJs = true;
    extraPython3Packages = ps: with ps; [ pynvim ];
  };
}
