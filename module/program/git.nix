{ inputs, pkgs, ... }:
{
  # Enable fish
  environment.systemPackages = with pkgs; [
    git
    ugit
  ];
  programs.git = {
    enable = true;
  };
}