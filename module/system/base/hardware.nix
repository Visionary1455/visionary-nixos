{ inputs, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    brightnessctl # screen brightness control
    udiskie # manage removable media
    ntfs3g # ntfs support
    exfat # exFAT support
    libinput-gestures # actions touchpad gestures using libinput
    libinput # libinput library
    lm_sensors # system sensors
    pciutils # pci utils
  ];
}
