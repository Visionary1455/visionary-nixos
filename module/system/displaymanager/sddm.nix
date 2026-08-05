{ pkgs, ... }:
let
  sddm-candy = pkgs.callPackage ../../../overlays/sddm-candy.nix { };
  Bibata-Modern-Ice = pkgs.callPackage ../../../overlays/Bibata-Modern-Ice.nix { };
in
{
  environment.systemPackages = [
    sddm-candy
    Bibata-Modern-Ice
  ];

  # Add this section to ensure cursor theme is properly loaded
  environment.sessionVariables = {
    XCURSOR_THEME = "Bibata-Modern-Ice";
    XCURSOR_SIZE = "24";
  };

  services.displayManager.sddm = {
    enable = true;
    # nixos-26.05 起 nixpkgs 的 sddm 已切换为 Qt6 构建（kdePackages.sddm），
    # libsForQt5.sddm 已被移除，因此无法再使用 Qt5 版 SDDM。
    # Candy 主题为 Qt5 QML 编写，已在 overlays/sddm-candy.nix 中适配 Qt6
    # （补充 metadata.desktop 的 QtVersion=6，并将 QtGraphicalEffects 换成 Qt5Compat）。
    theme = sddm-candy.name;
    wayland = {
      enable = true;
    };
    extraPackages = with pkgs; [
      sddm-candy
      Bibata-Modern-Ice
      # Candy 主题（Qt5 QML）移植到 Qt6 后所需的 QML 模块：
      qt6Packages.qt5compat # 提供 Qt5Compat.GraphicalEffects（替代 QtGraphicalEffects）
      qt6Packages.qtvirtualkeyboard # 提供 QtQuick.VirtualKeyboard 虚拟键盘
      qt6Packages.qtsvg # 主题中的 .svgz 图标
    ];
    settings = {
      Theme = {
        ThemeDir = "/run/current-system/sw/share/sddm/themes";
        CursorTheme = "Bibata-Modern-Ice";
        CursorSize = "24";
      };
      Wayland = {
        EnableHiDPI = true;
      };
    };
  };

  # 默认会话：本机实际使用的桌面环境为 niri（hyprland 未启用）
  services.displayManager.defaultSession = "niri";
}
