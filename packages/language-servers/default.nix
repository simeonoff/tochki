{ pkgs }:

{
  mdx-language-server = pkgs.buildNpmPackage rec {
    pname = "mdx-language-server";
    version = "0.6.3";

    src = pkgs.fetchurl {
      url = "https://registry.npmjs.org/@mdx-js/language-server/-/language-server-${version}.tgz";
      sha256 = "sha256-rNYJYQjnA7u02nP4a7EL/yJbjGdwP0RLQpAhr/I9xLs=";
    };

    # The published tarball doesn't include a package-lock.json (the upstream
    # monorepo doesn't commit one). We generate it from the tarball's package.json
    # and store it alongside this derivation.
    postPatch = ''
      cp ${./mdx-language-server-0.6.3-package-lock.json} package-lock.json
    '';
    npmDepsHash = "sha256-Hgzp7HJnMmB6IWruxwahJ8dod/JmndSAFTBrDW1tCVw=";

    dontNpmBuild = true;    meta = {
      description = "A language server for MDX";
      homepage = "https://github.com/mdx-js/mdx-analyzer";
      license = pkgs.lib.licenses.mit;
      maintainers = with pkgs.lib.maintainers; [ simeonoff ];
      mainProgram = "mdx-language-server";
    };
  };

  some-sass-language-server = pkgs.stdenv.mkDerivation rec {
    pname = "some-sass-language-server";
    version = "2.3.8";

    src = pkgs.fetchurl {
      url = "https://registry.npmjs.org/${pname}/-/${pname}-${version}.tgz";
      sha256 = "sha256-dTNM1MBb5RLwySTMZZWvHtwlpoSdlRQnG6hzaYpVXaw=";
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
