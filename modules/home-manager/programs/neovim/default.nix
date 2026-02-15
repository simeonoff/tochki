{ pkgs, config, lib, ... }:
{
  # Keep Neovim config live by linking at activation time.
  home.activation.neovimConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    $DRY_RUN_CMD mkdir -p "${config.xdg.configHome}"
    $DRY_RUN_CMD ln -sfn "${config.home.homeDirectory}/tochki/modules/home-manager/programs/neovim/config/nvim" "${config.xdg.configHome}/nvim"
  '';
  programs.neovim = {
    enable = true;
    extraPackages = with pkgs; [
      angular-language-server
      astro-language-server
      bash-language-server
      emmet-language-server
      eslint_d
      ginko
      gopls
      gotools
      lua-language-server
      marksman
      netcoredbg # CSharp debugger
      nil
      nixpkgs-fmt
      prettierd
      roslyn-ls # CSharp language server
      selene
      some-sass-language-server
      stylelint
      stylelint-lsp
      stylua
      tailwindcss-language-server
      typescript-language-server
      vscode-langservers-extracted
      yaml-language-server
    ];

    withNodeJs = true;
    extraPython3Packages = ps: with ps; [ pynvim ];
  };
}
