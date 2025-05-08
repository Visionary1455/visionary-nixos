{ inputs, pkgs, ... }:
{
  # Enable fish
  programs.git = {
    enable = true;
    userName  = "Visionary";
    userEmail = "15282219250@163.com";
  };
}
