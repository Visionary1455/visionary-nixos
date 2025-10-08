{ inputs, pkgs,dotfile_dir, ... }:
{
  # home.activation.createHyprConfigs = lib.hm.dag.entryAfter [ "mutableGeneration" ] ''
  #   mkdir -p "$HOME/.config/hypr/animations"
  #   mkdir -p "$HOME/.config/hypr/themes"

  #   touch "$HOME/.config/hypr/animations/theme.conf"
  #   touch "$HOME/.config/hypr/themes/colors.conf"
  #   touch "$HOME/.config/hypr/themes/theme.conf"
  #   touch "$HOME/.config/hypr/themes/wallbash.conf"

  #   chmod 644 "$HOME/.config/hypr/animations/theme.conf"
  #   chmod 644 "$HOME/.config/hypr/themes/colors.conf"
  #   chmod 644 "$HOME/.config/hypr/themes/theme.conf"
  #   chmod 644 "$HOME/.config/hypr/themes/wallbash.conf"
  # '';

  home.file = {
    ".config/hypr/hyprland.conf" = {
      source = dotfile_dir + /.config/hypr/hyprland.conf;
      force = true;
    };
    ".config/hypr/hyprpaper.conf" = {
      source = dotfile_dir + /.config/hypr/hyprpaper.conf;
    };
    # wlogout
    ".config/wlogout/colors-waybar.css" = {
      source = dotfile_dir + /.config/wlogout/colors-waybar.css;
    };
    ".config/wlogout/layout" = {
      source = dotfile_dir + /.config/wlogout/layout;
    };
    ".config/wlogout/style.css" = {
      source = dotfile_dir + /.config/wlogout/style.css;
    };
    ".config/wlogout/icons/hibernate.png" = {
      source = dotfile_dir + /.config/wlogout/icons/hibernate.png;
    };
    ".config/wlogout/icons/hibernate-hover.png" = {
      source = dotfile_dir + /.config/wlogout/icons/hibernate-hover.png;
    };
    ".config/wlogout/icons/hibernate-hover1.png" = {
      source = dotfile_dir + /.config/wlogout/icons/hibernate-hover1.png;
    };
    ".config/wlogout/icons/lock.png" = {
      source = dotfile_dir + /.config/wlogout/icons/lock.png;
    };
    ".config/wlogout/icons/lock-hover.png" = {
      source = dotfile_dir + /.config/wlogout/icons/lock-hover.png;
    };
    ".config/wlogout/icons/logout.png" = {
      source = dotfile_dir + /.config/wlogout/icons/logout.png;
    };
    ".config/wlogout/icons/logout-hover.png" = {
      source = dotfile_dir + /.config/wlogout/icons/logout-hover.png;
    };
    ".config/wlogout/icons/power.png" = {
      source = dotfile_dir + /.config/wlogout/icons/power.png;
    };
    ".config/wlogout/icons/power-hover.png" = {
      source = dotfile_dir + /.config/wlogout/icons/power-hover.png;
    };
    ".config/wlogout/icons/restart.png" = {
      source = dotfile_dir + /.config/wlogout/icons/restart.png;
    };
    ".config/wlogout/icons/restart-hover.png" = {
      source = dotfile_dir + /.config/wlogout/icons/restart-hover.png;
    };
        ".config/wlogout/icons/sleep.png" = {
      source = dotfile_dir + /.config/wlogout/icons/sleep.png;
    };
    ".config/wlogout/icons/sleep-hover.png" = {
      source = dotfile_dir + /.config/wlogout/icons/sleep-hover.png;
    };
    #wofi
    ".config/wofi/config" = {
      source = dotfile_dir + /.config/wofi/config;
    };
    ".config/wofi/style.css" = {
      source = dotfile_dir + /.config/wofi/style.css;
    };
    #waybar
    ".config/waybar/config" = {
      source = dotfile_dir + /.config/waybar/config;
    };
    ".config/waybar/style.css" = {
      source = dotfile_dir + /.config/waybar/style.css;
    };
  };
}
