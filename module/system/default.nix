{ pkgs, lib, inputs, ... }:
let
  # 微软官方 CDN 下载地址，用于绕过被墙的 update.code.visualstudio.com
  # 注意：VSCode 升级时需同步更新该 URL（commit 与 build 号会变），hash 由 nixpkgs 记录
  vscodeCdnUrl = "https://vscode.download.prss.microsoft.com/dbazure/download/stable/8b640eef5a6c6089c029249d48efa5c99adf7d51/code-stable-x64-1778006615.tar.gz";
in
{
  environment.systemPackages = with pkgs; [
    # 基础工具
    vim    wget
    curl
    unzip
    lshw
    grc
    btop

    # Wayland / 桌面
    wl-clipboard
    swaynotificationcenter
    libnotify
    cliphist
    feh

    # 输入法相关网络工具
    networkmanager

    # 编辑器
    (vscode.override {
      commandLineArgs = [
        "--enable-wayland-ime"
        "--ozone-platform-hint=wayland"
      ];
      # 仅替换主程序下载地址；vscode-server（commit: 前缀）保持原样
      fetchurl =
        args:
        pkgs.fetchurl (
          args
          // lib.optionalAttrs (
            lib.hasPrefix "https://update.code.visualstudio.com/" args.url
            && !lib.hasPrefix "https://update.code.visualstudio.com/commit:" args.url
          ) { url = vscodeCdnUrl; }
        );
    })

    # 代理
    v2ray
    v2rayn
    xray
    v2ray-geoip
    v2ray-domain-list-community

    # AI 助手
    (inputs.nixpkgs-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system}.opencode)
  ];

  imports = [
    ./nixos/bootloader.nix
    ./nixos/auto-upgrade.nix
    ./nixos/gc.nix
    ./nixos/fonts.nix
    ./nixos/nix.nix

    ./base/networking.nix
    ./base/tailscale.nix
    ./base/open-ssh.nix
    # ./base/nvidia.nix
    ./base/opengl.nix
    ./base/audio.nix
    # ./base/usb.nix
    ./base/bluetooth.nix
    ./base/fcitx5.nix
    ./base/gaming.nix
    ./base/hardware.nix

    # ./displaymanager/display-manager.nix
    ./displaymanager/sddm.nix

    ./program/shell.nix
    # ./program/hyprland.nix
    ./program/lsp.nix
    ./program/niri.nix

    # 新增（默认禁用）
    # ./program/dms.nix
    # ./program/flatpak-module.nix
    # ./program/virtualization.nix
  ];

  # 开启 visionar's linger，使 home-manager 的用户级服务
  # （如 module/hm/program/ddns-go.nix 中的 ddns-go）在开机后无需登录即可自启
  users.users.visionary.linger = true;
}
