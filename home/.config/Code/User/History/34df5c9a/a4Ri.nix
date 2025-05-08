{ config, pkgs, ... }:


{

  home.username = "visionary";
  home.homeDirectory = "/home/visionary";
  home.stateVersion = "24.11";
  programs.home-manager.enable = true;

}
