{ pkgs, dotfile_dir, ... }:
{
  home.packages = with pkgs; [
    fastfetch # KDE file manager
  ];
  home.file = {
    ".config/fastfetch/config.jsonc" = {
      source = dotfile_dir + /.config/fastfetch/config.jsonc;
    };
    ".config/fastfetch/logo/" = {
      source = dotfile_dir + "/.config/fastfetch/logo/";
      recursive = true;
    };
  };
}
