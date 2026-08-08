{ pkgs, inputs, ... }:
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
    })

    # 代理
    v2ray
    v2rayn

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
