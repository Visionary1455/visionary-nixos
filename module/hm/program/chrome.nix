{
  pkgs,
  lib,
  ...
}:
{
  home.packages = with pkgs; [
    google-chrome
  ];

  # Chrome Wayland 支持：通过 Ozone 后端实现原生 Wayland 渲染
  # --ozone-platform-hint=auto：自动检测 Wayland/X11
  # --enable-wayland-ime：启用 Wayland 输入法协议（fcitx5）
  home.sessionVariables = {
    CHROME_FLAGS = "--ozone-platform-hint=auto --enable-wayland-ime";
  };
}
