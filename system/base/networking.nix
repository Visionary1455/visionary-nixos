{ pkgs, identity, ... }:
{
  # 网络
  networking = {
    hostName = identity.hostname;
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
      # 4096: opencode server（Basic Auth，HTTP over TCP）
      # 5900: wayvnc VNC 服务端（见 home/program/wayvnc.nix）
      allowedTCPPorts = [
        4096
        5900
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    iwgtk
  ];
}
