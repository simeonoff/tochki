# Dotnet development shells
{ pkgs }:

{
  dotnet8 = pkgs.mkShell {
    buildInputs = with pkgs; [
      dotnet-sdk_8
      netcoredbg
      roslyn-ls
    ];
    shellHook = ''
      export DOTNET_ROOT="${pkgs.dotnet-sdk_8}/share/dotnet"
    '';
  };

  dotnet9 = pkgs.mkShell {
    buildInputs = with pkgs; [
      dotnet-sdk_9
      netcoredbg
      roslyn-ls
    ];
    shellHook = ''
      export DOTNET_ROOT="${pkgs.dotnet-sdk_9}/share/dotnet"
    '';
  };

  dotnet10 = pkgs.mkShell {
    buildInputs = with pkgs; [
      dotnet-sdk_10
      netcoredbg
      roslyn-ls
    ];
    shellHook = ''
      export DOTNET_ROOT="${pkgs.dotnet-sdk_10}/share/dotnet"
    '';
  };
}

