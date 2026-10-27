# 主机级系统配置
# 依赖 nixos-hardware 提供的硬件模块，并根据本机硬件启用对应模块
{
  pkgs,
  inputs,
  identity,
  ...
}:
{
  imports = [
    # === GPU 配置 ===
    # 驱动通过 nixos-hardware 加载，更多选项见:
    # https://github.com/NixOS/nixos-hardware
    #
    # NVIDIA: inputs.nixos-hardware.nixosModules.common-gpu-nvidia
    # AMD:    inputs.nixos-hardware.nixosModules.common-gpu-amd
    inputs.nixos-hardware.nixosModules.common-gpu-amd

    # === CPU 配置 ===
    # 本机为 AMD CPU/核显（故启用 common-cpu-amd / common-gpu-amd）
    # Intel: inputs.nixos-hardware.nixosModules.common-cpu-intel
    inputs.nixos-hardware.nixosModules.common-cpu-amd

    # === 其他通用模块 ===
    inputs.nixos-hardware.nixosModules.common-pc
    inputs.nixos-hardware.nixosModules.common-pc-ssd
  ];

  # 时区
  time.timeZone = "Asia/Shanghai";

  nixpkgs.config.allowUnfree = true;

  # 远程桌面：lamco-rdp-server 用户服务使用 NLA/CredSSP 认证。
  # 服务、凭据与端口在 home/program/lamco-rdp-server.nix 和
  # system/base/networking.nix 中声明。
  # 允许 lamco 的 FUSE 剪贴板文件传输使用 allow_other。
  programs.fuse.userAllowOther = true;

  # 禁用睡眠/休眠，避免 NUC/台式机挂起问题
  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;

  users.users.${identity.username} = {
    isNormalUser = true;
    description = identity.username;
    extraGroups = [
      "networkmanager"
      "input"
      "wheel"
      "video"
      "audio"
      "tss"
    ];
    shell = pkgs.fish;
  };

  system.stateVersion = identity.stateVersion;
}
