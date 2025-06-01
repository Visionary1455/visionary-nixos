{ inputs, pkgs, ... }:

{
  # Enable thunar
  services.gvfs.enable = true; # Mount, trash, and other functionalities
  environment.systemPackages = with pkgs; [
    kdePackages.dolphin
    kdePackages.qtsvg
    kdePackages.kio-fuse #to mount remote filesystems via FUSE
    kdePackages.kio-extras #extra protocols support (sftp, fish and more)
  ];
}
