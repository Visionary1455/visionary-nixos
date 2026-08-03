{ pkgs, dotfile_dir, ... }:

{
  home.file = {
    # fish
    ".config/fish/config.fish" = {
      source = dotfile_dir + /.config/fish/config.fish;
    };
    ".config/fish/functions/fish_prompt.fish" = {
      source = dotfile_dir + /.config/fish/functions/fish_prompt.fish;
    };
  };
}
