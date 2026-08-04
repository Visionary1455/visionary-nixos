{ pkgs, ... }:
{
  # niri 设置
  programs.niri.enable = true;

  # 启用 XWayland：v2rayN 等 Avalonia/X11 应用不支持原生 Wayland，
  # 必须通过 XWayland 运行。niri 25.08+ 已移除内嵌 XWayland，
  # 改为内置集成 xwayland-satellite（需在 PATH 中）。
  programs.xwayland.enable = true;

  environment.systemPackages = with pkgs; [
    bibata-cursors
    xwayland-satellite
    snixembed
  ];

  environment.variables = {
    XCURSOR_THEME = "Bibata-Modern-Ice";
    XCURSOR_SIZE = "24";
  };
}
