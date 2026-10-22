{ pkgs, ... }:
{
  # Enable fish
  home.packages = with pkgs; [
    git
  ];
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "visionary";
        email = "15282219250@163.com";
      };
      init.defaultBranch = "main";
      pull.rebase = false;
    };
  };

  # TUI Git 客户端（终端内查看提交、分支、暂存与 diff）
  programs.lazygit.enable = true;
}
