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

    # --- Qt6 下用户图标错位修复（参考维护者 eucalyptus-drop 分支） ---
    # QQC2 的 ComboBox 默认会把当前用户名作为 displayText 画在框内（ForceLastUser=true
    # 时显示"visionary"），首字母会与 User 图标重叠/露在图标一侧，看起来像图标错位。
    # 清空 displayText，只保留用户图标。
    sed -i '/^            id: selectUser$/a\            displayText: ""' Components/Input.qml
    # Qt6 的 Button 默认带背景（圆角矩形色块），flat: true 去掉该背景，
    # 使 User 图标按主题设计干净地显示在输入框左侧。
    sed -i '/^                    enabled: false$/a\                    flat: true' Components/Input.qml
    sed -i '/^                enabled: false$/a\                flat: true' Components/UserList.qml

    # 修复 SystemButtons.qml 已知 bug：index=0 时 children[index-1]=children[-1] 为
    # undefined，会打印 "Unable to assign [undefined] to QQuickItem*"。改为首尾循环。
    sed -i 's/^            KeyNavigation.left: parent\.children\[index-1\]$/            KeyNavigation.left: parent.children[index > 0 ? index - 1 : parent.children.length - 1]/' \
      Components/SystemButtons.qml
  '';

  meta = with pkgs.lib; {
    description = "Candy theme for SDDM";
    homepage = "https://github.com/HyDE-Project/HyDE";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ ];
  };
}
