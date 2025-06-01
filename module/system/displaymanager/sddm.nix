{ inputs, pkgs, ... }:
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
    package = pkgs.libsForQt5.sddm;
    theme = sddm-candy.name;
    wayland = {
      enable = true;
    };
    extraPackages = with pkgs; [
      libsForQt5.sddm
      libsForQt5.sddm-kcm
      libsForQt5.qtsvg
      libsForQt5.qtmultimedia
      libsForQt5.qtvirtualkeyboard
      libsForQt5.qtquickcontrols2
      libsForQt5.qtgraphicaleffects
      libsForQt5.layer-shell-qt
      libsForQt5.qt5.qtwayland
      sddm-candy
      Bibata-Modern-Ice
    ];
    settings = {
      Theme = {
        ThemeDir = "/run/current-system/sw/share/sddm/themes";
        CursorTheme = "Bibata-Modern-Ice";
        CursorSize = "24";
      };
      General = {
        # Set default session globally
        DefaultSession = "hyprland.desktop";
      };
      Wayland = {
        EnableHiDPI = true;
      };
    };
  };
}
