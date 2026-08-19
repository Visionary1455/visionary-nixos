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
      allowedTCPPorts = [ 4096 ];
      allowedUDPPorts = [ 4096 ];
    };
  };

  # 代理环境变量（v2rayN 默认监听 10808 端口）
  environment.variables = {
    http_proxy = "http://127.0.0.1:10808";
    https_proxy = "http://127.0.0.1:10808";
    all_proxy = "socks5://127.0.0.1:10808";
    no_proxy = "localhost,127.0.0.1,::1";
  };

  environment.systemPackages = with pkgs; [
    iwgtk
  ];
}
