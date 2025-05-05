{ lib, stdenv, ... }:

stdenv.mkDerivation {
  pname = "local-fonts";
  version = "1.0.0";

  src = ../../files/fonts;

  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    cp -r * $out/share/fonts/truetype/
  '';

  meta = with lib; {
    description = "Local custom fonts";
    license = licenses.unfree;
    platforms = platforms.all;
  };
}

