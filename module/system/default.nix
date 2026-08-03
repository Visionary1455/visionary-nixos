{ inputs, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    curl
    lshw
    grc
    btop
  
    wl-clipboard
    networkmanager
    unzip
    swaynotificationcenter
    libnotify
    (vscode.override {
      commandLineArgs = [
      "--enable-wayland-ime"
      "--ozone-platform-hint=wayland"
      ];
    })
    #  (chromium.override {
    #    enableWideVine = true;
    #    commandLineArgs = [
    #       "--enable-features=AcceleratedVideoEncoder,VaapiOnNvidiaGPUs,VaapiIgnoreDriverChecks,Vulkan,DefaultANGLEVulkan,VulkanFromANGLE"
    #       "--enable-features=VaapiIgnoreDriverChecks,VaapiVideoDecoder,PlatformHEVCDecoderSupport"
    #       "--enable-features=UseMultiPlaneFormatForHardwareVideo"
    #       "--ignore-gpu-blocklist"
    #       "-enable-features=UseOzonePlatform"
    #       "--ozone-platform=wayland"
    #       "--enable-wayland-ime"
    #     ];
    #   })
    #jetbrains.clion
    xarchiver
    feh
    cliphist
    clash-verge-rev
    opencode
  ];  

  imports = [
    ./nixos/bootloader.nix
    ./nixos/auto-upgrade.nix
    ./nixos/gc.nix
    ./nixos/fonts.nix
    ./nixos/nix.nix

    ./base/networking.nix
    ./base/open-ssh.nix
    #./base/nvidia.nix
    ./base/opengl.nix
    ./base/audio.nix
    #./base/usb.nix
    ./base/bluetooth.nix
    ./base/fcitx5.nix
    ./base/gaming.nix
    ./base/hardware.nix

    ./displaymanager/display-manager.nix
    # ./displaymanager/sddm.nix

    ./program/shell.nix 
    # ./program/hyprland.nix 
    ./program/lsp.nix 
    ./program/niri.nix
    
    # 新增
    # ./program/dms.nix
    # ./program/flatpak-module.nix
    # ./program/virtualization.nix
  ];
}
