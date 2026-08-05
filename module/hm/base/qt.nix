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
    colloid-icon-theme # modern icon theme (light/dark variants)
    catppuccin-kvantum # optional dark Kvantum theme
    kvmarwaita # light Kvantum theme
    nerd-fonts.caskaydia-cove # user's preferred mono font (icon-capable)
    nerd-fonts.monaspace # modern mono font
  ];

  # Make icon theme and KDE color scheme discoverable via XDG_DATA_HOME
  xdg.dataFile = {
    "icons/Colloid" = {
      source = "${pkgs.colloid-icon-theme}/share/icons/Colloid";
    };
    "icons/Colloid-Dark" = {
      source = "${pkgs.colloid-icon-theme}/share/icons/Colloid-Dark";
    };
    "color-schemes/Catppuccin.colors" = {
      source = dotfile_dir + /.local/share/color-schemes/Catppuccin.colors;
    };
    "color-schemes/Catppuccin-Latte.colors" = {
      source = dotfile_dir + /.local/share/color-schemes/Catppuccin-Latte.colors;
    };
  };

  home.file = {
    ".config/qt5ct/qt5ct.conf" = {
      source = dotfile_dir + /.config/qt5ct/qt5ct.conf;
    };
    ".config/qt6ct/qt6ct.conf" = {
      source = dotfile_dir + /.config/qt6ct/qt6ct.conf;
    };
    ".config/Kvantum/KvMarwaita" = {
      source = "${pkgs.kvmarwaita}/share/Kvantum/KvMarwaita";
    };
    ".config/Kvantum/catppuccin-frappe-blue" = {
      source = "${pkgs.catppuccin-kvantum}/share/Kvantum/catppuccin-frappe-blue";
    };
    ".config/Kvantum/wallbash/wallbash.kvconfig" = {
      source = dotfile_dir + /.config/Kvantum/wallbash/wallbash.kvconfig;
      force = true;
    };
    ".config/Kvantum/wallbash/wallbash.svg" = {
      source = dotfile_dir + /.config/Kvantum/wallbash/wallbash.svg;
      force = true;
    };
    ".config/Kvantum/kvantum.kvconfig" = {
      source = dotfile_dir + /.config/Kvantum/kvantum.kvconfig;
      force = true;
    };
    ".config/qt5ct/colors.conf" = {
      source = dotfile_dir + /.config/qt5ct/colors.conf;
      force = true;
    };
    ".config/qt6ct/colors.conf" = {
      source = dotfile_dir + /.config/qt6ct/colors.conf;
      force = true;
    };
    # Nerd Fonts linked into XDG_DATA_HOME so fontconfig picks them up immediately
    ".local/share/fonts/CaskaydiaCove" = {
      source = "${pkgs.nerd-fonts.caskaydia-cove}/share/fonts";
    };
    ".local/share/fonts/Monaspace" = {
      source = "${pkgs.nerd-fonts.monaspace}/share/fonts";
    };
  };
}
