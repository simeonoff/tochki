{ pkgs, config, ... }:
let
  inherit (config.lib.file) mkOutOfStoreSymlink;
in
{
  xdg.configFile.nvim.source = mkOutOfStoreSymlink "${config.home.homeDirectory}/tochki/modules/home-manager/programs/neovim/config/nvim";

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
      tailwindcss-language-server
      typescript-language-server
      vscode-langservers-extracted
      yaml-language-server
    ];

    # Set environment variables for Neovim to find the tiktoken_core module
    extraLuaPackages = ps: with ps; [ tiktoken_core ];
    withNodeJs = true;
    extraPython3Packages = ps: with ps; [ pynvim ];
  };
}
