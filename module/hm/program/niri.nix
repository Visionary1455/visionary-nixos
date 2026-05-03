{ config, pkgs, dotfile_dir, ... }:

{

# niri设置
home.file = {
    ".config/niri/config.kdl" = {
      source = dotfile_dir + /.config/niri/config.kdl;
      force = true;
    };
  };
}
