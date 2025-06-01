{ inputs, pkgs, ... }:

{
  imports = [
    ./nixos/bootloader.nix
    ./nixos/auto-upgrade.nix
    ./nixos/gc.nix
    ./nixos/fonts.nix

    ./base/networking.nix
    ./base/open-ssh.nix
    #./base/nvidia.nix
    ./base/opengl.nix
    ./base/sound.nix
    #./base/usb.nix
    ./base/bluetooth.nix
    ./base/fcitx5.nix

    ./displaymanager/display-manager.nix

    ./program/fish.nix 
    ./program/hyprland.nix 
    ./program/lsp.nix 
    ./program/v2raya.nix
  ];
  # Change runtime directory size
  services.logind.extraConfig = "RuntimeDirectorySize=8G";
}
