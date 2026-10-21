{ lib, pkgs }:

let
  version = "0.84.2";

  sources = {
    "aarch64-darwin" = {
      url = "https://github.com/earendil-works/pi-mono/releases/download/v${version}/pi-darwin-arm64.tar.gz";
      hash = "sha256-yZboiLf33ORLzyT2kXasZGxEE505Fr1JprKOWoxeOmU=";
    };
    "x86_64-darwin" = {
      url = "https://github.com/earendil-works/pi-mono/releases/download/v${version}/pi-darwin-x64.tar.gz";
      hash = lib.fakeHash;
    };
    "x86_64-linux" = {
      url = "https://github.com/earendil-works/pi-mono/releases/download/v${version}/pi-linux-x64.tar.gz";
      hash = lib.fakeHash;
    };
    "aarch64-linux" = {
      url = "https://github.com/earendil-works/pi-mono/releases/download/v${version}/pi-linux-arm64.tar.gz";
      hash = lib.fakeHash;
    };
  };

  source = sources.${pkgs.stdenv.hostPlatform.system};
in

{
  pi-mono = pkgs.stdenv.mkDerivation {
    pname = "pi-mono";
    inherit version;

    src = pkgs.fetchurl {
      inherit (source) url hash;
    };

    nativeBuildInputs = [ pkgs.gzip ]
      ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [ pkgs.autoPatchelfHook ];

    sourceRoot = ".";

    installPhase = ''
      runHook preInstall
      mkdir -p $out/bin
      cp -R pi/. $out/bin/
      chmod +x $out/bin/pi
      runHook postInstall
    '';

    meta = {
      description = "A minimal terminal AI coding harness.";
      homepage = "https://pi.dev";
      license = lib.licenses.mit;
      changelog = "https://github.com/earendil-works/pi-mono/releases/tag/v${version}";
      platforms = [ "aarch64-darwin" "x86_64-darwin" "x86_64-linux" "aarch64-linux" ];
      mainProgram = "pi";
    };
  };
}
