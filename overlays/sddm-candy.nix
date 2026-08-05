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
    cd $out/share/sddm/themes/Candy

    # nixos-26.05 的 sddm 为 Qt6 构建（sddm-greeter-qt6）。
    # 声明主题的 Qt 版本，否则 SDDM 会去找已被移除的 Qt5 sddm-greeter，
    # 导致主题无法显示（回退到默认主题）。
    cat > metadata.desktop <<'EOF'
[SddmGreeterTheme]
QtVersion=6
EOF

    # Qt6 中 QtGraphicalEffects 已废弃，改用 Qt5Compat.GraphicalEffects
    # （由 qt6Packages.qt5compat 提供）。
    sed -i 's/^import QtGraphicalEffects 1\.0$/import Qt5Compat.GraphicalEffects/' \
      Main.qml Components/Input.qml Components/SessionButton.qml Components/UserList.qml

    # Qt6 的 QtQuick.VirtualKeyboard 不再提供 2.3 版本号，去掉版本号使用默认版本。
    sed -i 's/^import QtQuick\.VirtualKeyboard 2\.3$/import QtQuick.VirtualKeyboard/' \
      Components/VirtualKeyboard.qml
  '';

  meta = with pkgs.lib; {
    description = "Candy theme for SDDM";
    homepage = "https://github.com/HyDE-Project/HyDE";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ ];
  };
}
