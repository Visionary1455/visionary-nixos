# 主机级系统配置
# 依赖 nixos-hardware 提供的硬件模块，并根据本机硬件启用对应模块
{ pkgs, inputs, ... }:
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
    # 本机为 Intel CPU（见 hardware-configuration.nix 中 kvm-intel）
    # inputs.nixos-hardware.nixosModules.common-cpu-intel
    inputs.nixos-hardware.nixosModules.common-cpu-amd

    # === 其他通用模块 ===
    inputs.nixos-hardware.nixosModules.common-pc
    inputs.nixos-hardware.nixosModules.common-pc-ssd
  ];

  # 时区
  time.timeZone = "Asia/Shanghai";

  nixpkgs.config.allowUnfree = true;

  # 远程桌面
  services.xrdp.enable = true;
  services.xrdp.openFirewall = true;

  # 禁用睡眠/休眠，避免 NUC/台式机挂起问题
  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;

  users.users.visionary = {
    isNormalUser = true;
    description = "visionary";
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

  system.stateVersion = "26.05";
}
