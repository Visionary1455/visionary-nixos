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
    ".config/swaylock/config" = {
      source = dotfile_dir + /.config/swaylock/config;
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
    # fish
    ".config/fish/config.fish" = {
      source = dotfile_dir + /.config/fish/config.fish;
    };
    ".config/fish/functions/fish_prompt.fish" = {
      source = dotfile_dir + /.config/fish/functions/fish_prompt.fish;
    };
    #kitty
    ".config/kitty/kitty.conf" = {
      source = dotfile_dir + /.config/kitty/kitty.conf;
    };
    #wofi
    ".config/wofi/config" = {
      source = dotfile_dir + /.config/wofi/config;
    };
    ".config/wofi/style.css" = {
      source = dotfile_dir + /.config/wofi/style.css;
    };
  };
}
