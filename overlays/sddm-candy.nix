{ pkgs, ... }:
let 
  commit = "87217f9126f1cda44d5df6b6371a92f974f299a2";
in
pkgs.stdenv.mkDerivation {
  pname = "sddm-candy-theme";
  name = "Candy";
  version = "1.0.0";

  src = pkgs.fetchzip {
    url = "https://github.com/HyDE-Project/HyDE/raw/${commit}/Source/arcs/Sddm_Candy.tar.gz";
    hash = "sha256-uT6UnGACmu6IPD8+cIMRHnF6lR55HZV3CRhEYda/dr8=";
  };

  installPhase = ''
    mkdir -p $out/share/sddm/themes/Candy
    cp -r * $out/share/sddm/themes/Candy
  '';

  meta = with pkgs.lib; {
    description = "Candy theme for SDDM";
    homepage = "https://github.com/HyDE-Project/HyDE";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ ];
  };
}
