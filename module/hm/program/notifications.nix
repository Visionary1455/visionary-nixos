{ config, lib, pkgs, dotfile_dir, ... }:

{
  home.packages = with pkgs; [
    dunst # notification daemon
  ];

  home.file = {
    # stateful file for themes
    ".config/dunst/dunstrc" = {
      source = dotfile_dir + "/.config/dunst/dunstrc";
      force = true;
      mutable = true;
    };
    ".config/dunst/dunst.conf" = {
      source = dotfile_dir + "/.config/dunst/dunst.conf";
      force = true;
      mutable = true;
    };
  };
}
