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
}
