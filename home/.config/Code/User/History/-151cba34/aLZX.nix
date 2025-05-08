{ pkgs, ... }:

{
  # Enable Display Manager
  services.xserver.displayManager.gdm.enable = true;
}
