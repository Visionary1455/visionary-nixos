# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  # Set your time zone.
  time.timeZone = "Asia/Shanghai";

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
     vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
     wget
     neofetch
     git
     curl
     lshw
   
     v2raya
     
     grc

     wl-clipboard
     kitty
     mako
     networkmanager
     unzip
     (microsoft-edge.override {    
       commandLineArgs = [
        "--enable-wayland-ime"
       ];
     })
     (vscode.override {
       commandLineArgs = [
        "--enable-wayland-ime"
        "--ozone-platform-hint=wayland"
       ];
     })
     (chromium.override {
       enableWideVine = true;
       commandLineArgs = [
          "--enable-features=AcceleratedVideoEncoder,VaapiOnNvidiaGPUs,VaapiIgnoreDriverChecks,Vulkan,DefaultANGLEVulkan,VulkanFromANGLE"
          "--enable-features=VaapiIgnoreDriverChecks,VaapiVideoDecoder,PlatformHEVCDecoderSupport"
          "--enable-features=UseMultiPlaneFormatForHardwareVideo"
          "--ignore-gpu-blocklist"
          "-enable-features=UseOzonePlatform"
          "--ozone-platform=wayland"
          "--enable-wayland-ime"
        ];
      })
    #jetbrains.clion
    wechat-uos
    # unzip
    xarchiver
    feh
  ];
  
  nix.settings = {
    substituters = [
      "https://mirrors.ustc.edu.cn/nix-channels/store"
      "https://cache.nixos.org"
    ];
    experimental-features = [ "nix-command" "flakes" ];
  };

  system.stateVersion = "24.11"; # Did you read the comment?
}
