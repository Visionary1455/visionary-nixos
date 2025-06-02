{ inputs, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    curl
    lshw
    grc
  
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
    wechat-uos
    xarchiver
    feh
    cliphist
  ];  

  imports = [
    ./nixos/bootloader.nix
    ./nixos/auto-upgrade.nix
    ./nixos/gc.nix
    ./nixos/fonts.nix

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

    #./displaymanager/display-manager.nix
    ./displaymanager/sddm.nix

    ./program/fish.nix 
    ./program/hyprland.nix 
    ./program/lsp.nix 
    ./program/v2raya.nix
  ];
  # Change runtime directory size
  services.logind.extraConfig = "RuntimeDirectorySize=8G";
}
