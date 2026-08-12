{ config, lib, pkgs, ... }:
{
  # Tailscale VPN
  services.tailscale = {
    enable = true;
    # 启用后 tailscaled 随系统启动（开机自启动）
    port = 41641;
    # server: 子网路由需要启用 IP 转发（net.ipv4.ip_forward）
    useRoutingFeatures = "server";
    # 宣告局域网子网路由，使 tailnet 内其他设备可访问 192.168.0.0/24
    # 启动时执行 `tailscale set --advertise-routes=...`
    # 还需在 Tailscale 管理后台 (login.tailscale.com/admin) 批准路由
    extraSetFlags = [ "--advertise-routes=192.168.0.0/24" ];
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
