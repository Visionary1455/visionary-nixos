{ inputs, pkgs, ... }:
{
  # Enable fish
  environment.systemPackages = with pkgs; [
    git
  ];
  programs.git = {
    enable = true;
  };
}
