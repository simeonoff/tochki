{ lib, pkgs }:

let
  version = "0.9.0";

  sources = {
    "aarch64-darwin" = {
      url = "https://github.com/DeusData/codebase-memory-mcp/releases/download/v${version}/codebase-memory-mcp-darwin-arm64.tar.gz";
      hash = "sha256-+qAvBAQjDEUamBIjA5RIGUj4AYOAH6W/ZwRLQcLyXtQ=";
    };
    "x86_64-darwin" = {
      url = "https://github.com/DeusData/codebase-memory-mcp/releases/download/v${version}/codebase-memory-mcp-darwin-amd64.tar.gz";
      hash = "sha256-avPQKif1iZAfp2PTlxCJM3vIyYOLvtXQz1Q8qfGp5UM=";
    };
    "x86_64-linux" = {
      url = "https://github.com/DeusData/codebase-memory-mcp/releases/download/v${version}/codebase-memory-mcp-linux-amd64.tar.gz";
      hash = "sha256-4oMqjSB8Jr6qMO+mIi7Uo3yz9SbKS+4GC/vzNu1vxnk=";
    };
    "aarch64-linux" = {
      url = "https://github.com/DeusData/codebase-memory-mcp/releases/download/v${version}/codebase-memory-mcp-linux-arm64.tar.gz";
      hash = "sha256-aKNF2aaELwKjywfhh7KLw4xPOiKWf0f6280HV7qTpoA=";
    };
  };

  source = sources.${pkgs.stdenv.hostPlatform.system};
in

{
  codebase-memory-mcp = pkgs.stdenv.mkDerivation {
    pname = "codebase-memory-mcp";
    inherit version;

    src = pkgs.fetchurl {
      inherit (source) url hash;
    };

    nativeBuildInputs =
      lib.optionals pkgs.stdenv.hostPlatform.isLinux [ pkgs.autoPatchelfHook ];

    # The tarball extracts a single binary at the root
    unpackPhase = ''
      tar -xzf $src
    '';

    installPhase = ''
      runHook preInstall
      install -Dm755 codebase-memory-mcp $out/bin/codebase-memory-mcp
      runHook postInstall
    '';

    meta = {
      description = "Fast, offline MCP server that builds a semantic knowledge graph of your codebase";
      homepage = "https://github.com/DeusData/codebase-memory-mcp";
      license = lib.licenses.mit;
      changelog = "https://github.com/DeusData/codebase-memory-mcp/releases/tag/v${version}";
      platforms = [ "aarch64-darwin" "x86_64-darwin" "x86_64-linux" "aarch64-linux" ];
      mainProgram = "codebase-memory-mcp";
    };
  };
}
