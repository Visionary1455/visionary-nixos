{ pkgs, dotfile_dir, ... }:
{
  home.packages = with pkgs; [
    libsForQt5.qt5ct
    libsForQt5.qt5.qtbase
    libsForQt5.qtstyleplugin-kvantum
    libsForQt5.qtimageformats
    libsForQt5.qtsvg
    libsForQt5.qt5.qtwayland
    kdePackages.qtbase
    kdePackages.qtwayland
    kdePackages.qtstyleplugin-kvantum
    kdePackages.breeze-icons
    kdePackages.qtimageformats
    kdePackages.qtsvg
    kdePackages.qtwayland
  ];

  home.file = {
    ".config/qt5ct/qt5ct.conf" = {
      source = dotfile_dir + /.config/qt5ct/qt5ct.conf;
    };
    ".config/qt6ct/qt6ct.conf" = {
      source = dotfile_dir + /.config/qt6ct/qt6ct.conf;
    };
    ".config/Kvantum/wallbash/wallbash.kvconfig" = {
      source = dotfile_dir + /.config/Kvantum/wallbash/wallbash.kvconfig;
      force = true;
      mutable = true;
    };
    ".config/Kvantum/wallbash/wallbash.svg" = {
      source = dotfile_dir + /.config/Kvantum/wallbash/wallbash.svg;
      force = true;
      mutable = true;
    };
    ".config/Kvantum/kvantum.kvconfig" = {
      source = dotfile_dir + /.config/Kvantum/kvantum.kvconfig;
      force = true;
      mutable = true;
    };
    ".config/qt5ct/colors.conf" = {
      source = dotfile_dir + /.config/qt5ct/colors.conf;
      force = true;
      mutable = true;
    };
    ".config/qt6ct/colors.conf" = {
      source = dotfile_dir + /.config/qt6ct/colors.conf;
      force = true;
      mutable = true;
    };
  };
}
