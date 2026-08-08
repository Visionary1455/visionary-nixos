{ config, lib, pkgs, ... }:
{
  # Tailscale VPN
  services.tailscale = {
    enable = true;
    # 启用后 tailscaled 随系统启动（开机自启动）
    port = 41641;
  };

  # Tailscale 通过加密的 UDP 隧道工作，需放行对应端口
  networking.firewall = {
    allowedUDPPorts = [ config.services.tailscale.port ];
    # Tailscale 使用直接连接的路径时需要进行路径反转校验，这里关闭避免连接失败
    checkReversePath = false;
  };

  environment.systemPackages = with pkgs; [
    tailscale
  ];
}
