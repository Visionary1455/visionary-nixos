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
      # 默认合成器 weston(--shell=kiosk) 不渲染光标且输入投递异常，
      # 导致登录界面光标不可见、鼠标点击无响应。改用 kwin_wayland：
      # kwin 自行渲染光标（含 XCURSOR_THEME/PATH 主题加载）并正常处理输入。
      compositor = "kwin";
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
      # 模块在 compositor=kwin 时会自动设置 GreeterEnvironment=layer-shell；
      # 这里覆盖该值并补充 XCURSOR_PATH，使 sddm-greeter-qt6 能加载 Bibata 光标主题。
      # （sddm.conf 用逗号分隔多个环境变量，XCURSOR_PATH 内含冒号不影响解析）
      General = {
        GreeterEnvironment = "QT_WAYLAND_SHELL_INTEGRATION=layer-shell,XCURSOR_PATH=/run/current-system/sw/share/icons";
      };
    };
  };

  # environment.sessionVariables 不会注入系统服务，而 sddm 守护进程（display-manager.service）
  # 默认环境里没有 XCURSOR_* 变量，kwin 合成器（由 sddm-helper 继承该环境）将无法解析光标主题。
  # 因此把光标主题变量显式注入 display-manager.service 环境。
  systemd.services.display-manager.environment = {
    XCURSOR_THEME = "Bibata-Modern-Ice";
    XCURSOR_SIZE = "24";
    XCURSOR_PATH = "/run/current-system/sw/share/icons";
  };

  # 默认会话：本机实际使用的桌面环境为 niri（hyprland 未启用）
  services.displayManager.defaultSession = "niri";
}
