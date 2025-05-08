# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  # Set your time zone.
  time.timeZone = "Asia/Shanghai";

  nixpkgs.config.allowUnfree = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "zh_CN.UTF-8";
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.waylandFrontend = true;
    fcitx5.addons = with pkgs; [
      rime-data
      fcitx5-chinese-addons
      fcitx5-rime
    ];
  };
  fonts.packages = with pkgs; [   
    noto-fonts
    noto-fonts-color-emoji
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    jetbrains-mono
    nerd-font-patcher
  ];

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  environment.systemPackages = with pkgs; [
     vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
     wget
     neofetch
     git
     curl
     lshw
   
     v2raya
     #clash-verge-rev
     # ush fish shell
     fishPlugins.done
     fishPlugins.fzf-fish
     fishPlugins.forgit
     fishPlugins.hydro
     fzf
     fishPlugins.grc
     grc

     hyprland
     hyprpaper
     swaylock
     waybar
     wlogout
     wl-clipboard
     wofi
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
  programs.xfconf.enable = true;
  services.gvfs.enable = true; # Mount, trash, and other functionalities
  services.tumbler.enable = true; # Thumbnail support for images
  programs.thunar.plugins = with pkgs.xfce; [
    thunar-archive-plugin
    thunar-volman
  ];
  programs.thunar.enable = true;

  # 代理
  # programs.clash-verge.enable = true;

  programs.fish.enable = true;
  #users.defaultUserShell = pkgs.fish;
  programs.bash = {
    interactiveShellInit = ''
      if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
      then
        shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
        exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
      fi
    '';
  };

  #use chinese input method  
  environment.variables = {
    GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
  };

  #use hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
  environment.sessionVariables.WLR_NO_HARDWARE_CURSORS = "1";
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  # services.xserver.displayManager.gdm.enable = true;

  nix.settings = {
    substituters = [
      "https://mirrors.ustc.edu.cn/nix-channels/store"
      "https://cache.nixos.org"
    ];
  };
  system.stateVersion = "24.11"; # Did you read the comment?

}
