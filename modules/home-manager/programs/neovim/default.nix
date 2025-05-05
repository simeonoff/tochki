{ pkgs, config, ... }:
let
  inherit (config.lib.file) mkOutOfStoreSymlink;
in
{
  xdg.configFile.nvim.source = mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/nvim/.config/nvim";

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
      nil
      nixpkgs-fmt
      prettierd
      selene
      some-sass-language-server
      stylelint
      stylelint-lsp
      stylua
      vscode-langservers-extracted
      typescript-language-server
      yaml-language-server
    ];
  };
}
