{ inputs, pkgs, ... }:
{
  # Enable fish
  home.packages = with pkgs;  [
    git
  ];
  programs.git = {
      enable = true;
      userName = "visionary";
      userEmail = "15282219250@163.com";
      extraConfig = {
        init.defaultBranch = "main";
        pull.rebase = false;
      };
    };
}