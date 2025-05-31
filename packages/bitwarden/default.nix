self: super:

let
  version = "2025.5.0";
  rev = "desktop-v${version}";
in
{
  bitwarden-desktop = super.bitwarden-desktop.overrideAttrs (oldAttrs: rec {
    inherit version;

    src = super.fetchFromGitHub {
      owner = "bitwarden";
      repo = "clients";
      rev = rev;
      hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
    };

    npmDepsHash = "sha256-BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB=";
  });
}
