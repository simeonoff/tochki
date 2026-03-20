# Dotnet development shells
{ pkgs, pkgs-dotnet }:

{
  dotnet8 = pkgs.mkShell {
    buildInputs = [
      pkgs-dotnet.dotnet-sdk_8
      pkgs.netcoredbg
      pkgs.roslyn-ls
    ];
    shellHook = ''
      export DOTNET_ROOT="${pkgs-dotnet.dotnet-sdk_8}/share/dotnet"
    '';
  };

  dotnet9 = pkgs.mkShell {
    buildInputs = [
      pkgs-dotnet.dotnet-sdk_9
      pkgs.netcoredbg
      pkgs.roslyn-ls
    ];
    shellHook = ''
      export DOTNET_ROOT="${pkgs-dotnet.dotnet-sdk_9}/share/dotnet"
    '';
  };

  dotnet10 = pkgs.mkShell {
    buildInputs = [
      pkgs-dotnet.dotnet-sdk_10
      pkgs.netcoredbg
      pkgs.roslyn-ls
    ];
    shellHook = ''
      export DOTNET_ROOT="${pkgs-dotnet.dotnet-sdk_10}/share/dotnet"
    '';
  };
}

