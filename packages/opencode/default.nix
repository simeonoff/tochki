{ lib, pkgs }:

let
  version = "1.3.13";

  sources = {
    "aarch64-darwin" = {
      url = "https://github.com/anomalyco/opencode/releases/download/v${version}/opencode-darwin-arm64.zip";
      hash = "sha256-y72/oZ0Z+VU4kJsK8qSfi65wuk9bb0DRfG67nRnyPzM=";
    };
    "x86_64-darwin" = {
      url = "https://github.com/anomalyco/opencode/releases/download/v${version}/opencode-darwin-x64.zip";
      hash = "sha256-hjAdFXtsFhvQvCZq1eKEWOAeTEyVRKc/6Z+XqtvDV5M=";
    };
    "x86_64-linux" = {
      url = "https://github.com/anomalyco/opencode/releases/download/v${version}/opencode-linux-x64.zip";
      hash = lib.fakeHash;
    };
    "aarch64-linux" = {
      url = "https://github.com/anomalyco/opencode/releases/download/v${version}/opencode-linux-arm64.zip";
      hash = lib.fakeHash;
    };
  };

  source = sources.${pkgs.stdenv.hostPlatform.system};
in

{
  opencode = pkgs.stdenv.mkDerivation {
    pname = "opencode";
    inherit version;

    src = pkgs.fetchurl {
      inherit (source) url hash;
    };

    nativeBuildInputs = [ pkgs.unzip ]
      ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [ pkgs.autoPatchelfHook ];

    sourceRoot = ".";

    installPhase = ''
      runHook preInstall
      install -Dm755 opencode $out/bin/opencode
      runHook postInstall
    '';

    meta = {
      description = "The open source AI coding agent.";
      homepage = "https://opencode.ai/";
      license = lib.licenses.mit;
      changelog = "https://github.com/anomalyco/opencode/releases/tag/v${version}";
      platforms = [ "aarch64-darwin" "x86_64-darwin" "x86_64-linux" "aarch64-linux" ];
      mainProgram = "opencode";
    };
  };
}
