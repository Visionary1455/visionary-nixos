{ pkgs, dotfile_dir, ... }:

let
  ark = pkgs.kdePackages.ark;
  # Wrap dolphin so it can discover ark's compress/extract KFileItemAction plugins
  dolphin = pkgs.kdePackages.dolphin.overrideAttrs (old: {
    qtWrapperArgs = (old.qtWrapperArgs or [ ]) ++ [
      "--prefix QT_PLUGIN_PATH : ${ark}/lib/qt-6/plugins"
    ];
  });
in

{
  # Enable dolphin
  home.packages = with pkgs.kdePackages; [
    dolphin # KDE file manager
    ark # Archive manager (provides dolphin right-click compress/extract)
    pkgs.p7zip # 7z backend for ark
    qtimageformats # Image format support for Qt5
    ffmpegthumbs # Video thumbnail support
    kde-cli-tools # KDE command line utilities
    kdegraphics-thumbnailers # KDE graphics thumbnails
    kimageformats # Additional image format support for KDE
    qtsvg # SVG support
    kio # KDE I/O framework
    kio-extras # Additional KDE I/O protocols
    kwayland # KDE Wayland integration
  ];

  xdg.mimeApps = {
    defaultApplications = {
      "inode/directory" = [ "org.kde.dolphin.desktop" ];
      "x-scheme-handler/file" = [ "org.kde.dolphin.desktop" ];
      "x-scheme-handler/about" = [ "org.kde.dolphin.desktop" ];
    };
  };

  home.file = {
    ".config/dolphinrc" = {
      source = dotfile_dir + /.config/dolphinrc;
    };
    ".config/baloofilerc" = {
      source = dotfile_dir + /.config/baloofilerc;
    };
    ".config/menus/applications.menu" = {
      source = dotfile_dir + /.config/menus/applications.menu;
    };

    # dolphin theme config, managed declaratively by home-manager
    ".config/kdeglobals" = {
      source = dotfile_dir + /.config/kdeglobals;
      force = true;
    };
  };
}
