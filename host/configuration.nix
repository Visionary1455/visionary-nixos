# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ inputs, pkgs, ... }:

{
   imports = [ 
    # === GPU-specific configurations ===

    /*
      For drivers, we are leveraging nixos-hardware
      Most common drivers are below, but you can see more options here: https://github.com/NixOS/nixos-hardware
    */

    #! EDIT THIS SECTION
    # For NVIDIA setups
    # inputs.nixos-hardware.nixosModules.common-gpu-nvidia

    # For AMD setups
   inputs.nixos-hardware.nixosModules.common-gpu-amd

    # === CPU-specific configurations ===
    # For AMD CPUs
    inputs.nixos-hardware.nixosModules.common-cpu-amd

    # For Intel CPUs
    #inputs.nixos-hardware.nixosModules.common-cpu-intel

    # === Other common modules ===
    inputs.nixos-hardware.nixosModules.common-pc
    inputs.nixos-hardware.nixosModules.common-pc-ssd

    inputs.home-manager.nixosModules.home-manager
  ];
  # Set your time zone.
  time.timeZone = "Asia/Shanghai";

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
     vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
     wget
     neofetch
     curl
     lshw
     grc
    
     wl-clipboard
     kitty
     mako
     networkmanager
     unzip
    #  (microsoft-edge.override {    
    #    commandLineArgs = [
    #     "--enable-wayland-ime"
    #    ];
    #  })
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
    xarchiver
    feh
    cliphist
  ];  



  services.xrdp.enable = true;
  services.xrdp.openFirewall = true;
  
  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;
  nix.settings = {
    substituters = [
      "https://mirrors.ustc.edu.cn/nix-channels/store"
      "https://cache.nixos.org"
    ];
    experimental-features = [ "nix-command" "flakes" ];
  };
  users.users.visionary = {
    isNormalUser = true;
    description = "visionary";
    extraGroups = [ "networkmanager" "input" "wheel" "video" "audio" "tss" ];
    shell = pkgs.fish;
  };
  system.stateVersion = "25.05"; # Did you read the comment?
}
