{ pkgs, dotfile_dir, ... }:

{
  home.packages = with pkgs; [
    # starship 跨 shell 提示符
    starship
  ];

  home.file = {
    # fish
    ".config/fish/config.fish" = {
      source = dotfile_dir + /.config/fish/config.fish;
    };
    # 自定义 fish 提示符已被 starship 取代（config.fish 中 starship init fish | source）
    # ".config/fish/functions/fish_prompt.fish" = {
    #   source = dotfile_dir + /.config/fish/functions/fish_prompt.fish;
    # };

    # rebuild 命令：sudo nixos-rebuild switch --flake ".#visionary-computer" --impure
    ".config/fish/functions/rebuild.fish" = {
      source = dotfile_dir + /.config/fish/functions/rebuild.fish;
    };

    # starship 主题（Catppuccin 风格，Nerd Font 图标）
    ".config/starship.toml" = {
      source = dotfile_dir + /.config/starship.toml;
    };
  };
}
