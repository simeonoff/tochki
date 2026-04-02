{ lib, pkgs }:

let
  version = "0.5.7";

  sources = {
    "aarch64-darwin" = {
      url = "https://github.com/DeusData/codebase-memory-mcp/releases/download/v${version}/codebase-memory-mcp-darwin-arm64.tar.gz";
      hash = "sha256-sOZJodUmgL4teEherr/N0Qd6mu81EQE6L36OpTlkvK0=";
    };
    "x86_64-darwin" = {
      url = "https://github.com/DeusData/codebase-memory-mcp/releases/download/v${version}/codebase-memory-mcp-darwin-amd64.tar.gz";
      hash = "sha256-dW1P4GWZnnUUAOFESP/28vNajmlBoup1An8V2COAx08=";
    };
    "x86_64-linux" = {
      url = "https://github.com/DeusData/codebase-memory-mcp/releases/download/v${version}/codebase-memory-mcp-linux-amd64.tar.gz";
      hash = "sha256-/UcDT20r/LDXd2DDq1kmjBHAcI3AsM9S6WHuxHqXGNI=";
    };
    "aarch64-linux" = {
      url = "https://github.com/DeusData/codebase-memory-mcp/releases/download/v${version}/codebase-memory-mcp-linux-arm64.tar.gz";
      hash = "sha256-CDzGl6ANXTvtfpgTilPs/HK+MmSav+w7EGOkvlGPZW8=";
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
