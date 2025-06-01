{ inputs, pkgs, dotfile_dir, lib, ... }:

{
  home.activation.createHyprConfigs = lib.hm.dag.entryAfter [ "mutableGeneration" ] ''
      mkdir -p "$HOME/.config/menus"
    '';
  # Enable dolphin
  home.packages = with pkgs.kdePackages; [
      dolphin # KDE file manager
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

      # stateful file for themes
      ".config/kdeglobals" = {
        source = dotfile_dir + /.config/kdeglobals;
        # force = true;
        # mutable = true;
      };
    };
}
