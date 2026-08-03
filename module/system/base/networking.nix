{ pkgs, ... }:
{
  # 网络
  networking = {
    hostName = "visionary-computer"; # 与 flake.nix 中的主机配置名保持一致
    networkmanager.enable = true;
    # wireless = {
    #   enable = true;
    #   networks = {
    #     "1912-2" = {
    #       pskRaw = "d8c55e70a8f2209ced73ea8cdfc33ef0a1ab88386bca85fdf1f67d5c37a856dd";
    #     };
    #   };
    #   # iwd = {
    #   #   enable = true;
    #   #   settings = {
    #   #     IPv6 = {
    #   #       Enabled = true;
    #   #     };
    #   #     Settings = {
    #   #       AutoConnect = true;
    #   #     };
    #   #   };
    #   # };
    # };
  };

  environment.systemPackages = with pkgs; [
    iwgtk
  ];
}
