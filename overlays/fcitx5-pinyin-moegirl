{ lib
, stdenvNoCC
, fetchurl
}:

stdenvNoCC.mkDerivation {
  pname = "fcitx5-pinyin-moegirl";
  version = "20240309";

  src = fetchurl {
    url = "https://github.com/outloudvi/mw2fcitx/releases/download/20240309/moegirl.dict";
    hash = "sha256-ir9WQA2cz8VLL46/GaLTFAnL/H5vKWq3sbywHTcAKb8=";
  };

  dontUnpack = true;

  installPhase = ''
    install -Dm644 $src $out/share/fcitx5/pinyin/dictionaries/fcitx5-pinyin-moegirl.dict
  '';

  meta = with lib; {
    description = " Fcitx 5 pinyin dictionary generator for MediaWiki instances. Releases for dict of zh.moegirl.org.cn. (auto update)";
    homepage = "https://github.com/outloudvi/mw2fcitx";
    license = licenses.unlicense;
  };
}
