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
    firewall = {
      # 4096: opencode server（Basic Auth）
      # 5900: wayvnc VNC 服务端（见 module/hm/program/wayvnc.nix）
      allowedTCPPorts = [
        4096
        5900
      ];
      allowedUDPPorts = [ 4096 ];
    };
  };

  environment.systemPackages = with pkgs; [
    iwgtk
  ];
}
