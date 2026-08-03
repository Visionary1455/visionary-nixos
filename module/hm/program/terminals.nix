{ pkgs, dotfile_dir, ... }:

{
  home.packages = with pkgs; [
    kitty
  ];

  home.file = {
    #kitty
    ".config/kitty/kitty.conf" = {
      source = dotfile_dir + /.config/kitty/kitty.conf;
    };
    # stateful file for kitty wallbash

    ".config/kitty/theme.conf" = {
      source = dotfile_dir + /.config/kitty/theme.conf;
      force = true;
      mutable = true;
    };
  };
}
