{ pkgs }:

{
  some-sass-language-server = pkgs.stdenv.mkDerivation rec {
    pname = "some-sass-language-server";
    version = "2.2.0";

    src = pkgs.fetchurl {
      url = "https://registry.npmjs.org/${pname}/-/${pname}-${version}.tgz";
      sha256 = "sha256-9u17ToFVyvdmpLOJpdTnBLFTOklgIgkaAw74tD8PSHE=";
    };

    unpackPhase = ''
      mkdir source
      tar --strip-components=1 -xzf $src -C source
    '';

    installPhase = ''
      cd source

      mkdir -p $out/lib/node_modules/${pname}
      cp -r . $out/lib/node_modules/${pname}

      mkdir -p $out/bin
      ln -s $out/lib/node_modules/${pname}/bin/some-sass-language-server $out/bin/some-sass-language-server
    '';

    meta = {
      description = "A Sass/SCSS language server with module and LSP support";
      homepage = "https://github.com/wkillerud/some-sass";
      license = pkgs.lib.licenses.mit;
      maintainers = with pkgs.lib.maintainers; [ simeonoff ];
    };
  };
}
