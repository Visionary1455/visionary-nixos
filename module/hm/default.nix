{ lib, pkgs, ... }:
let
  USERNAME = "visionary";
in
{
  # 创建 Hypr 相关目录（供 home.file 的 logo 目录使用）
  home.activation.createHyprConfigs = lib.hm.dag.entryAfter [ "mutableGeneration" ] ''
    mkdir -p "$HOME/.config/fastfetch/logo"
  '';

  # 将 xray 核心二进制链接到 v2rayN 期望的位置
  home.activation.v2rayNXray = lib.hm.dag.entryAfter [ "mutableGeneration" ] ''
    mkdir -p "$HOME/.local/share/v2rayN/bin/xray"
    ln -sf /run/current-system/sw/bin/xray "$HOME/.local/share/v2rayN/bin/xray/xray"
  '';

  # 链接 v2ray 数据文件（geoip.dat、geosite.dat）到 v2rayN 期望的位置
  home.activation.v2rayNDataFiles = lib.hm.dag.entryAfter [ "mutableGeneration" ] ''
    ln -sf ${pkgs.v2ray-geoip}/share/v2ray/geoip.dat "$HOME/.local/share/v2rayN/bin/geoip.dat"
    ln -sf ${pkgs.v2ray-domain-list-community}/share/v2ray/geosite.dat "$HOME/.local/share/v2rayN/bin/geosite.dat"
  '';

  home = {
    username = USERNAME;
    homeDirectory = "/home/${USERNAME}";
    stateVersion = "26.05";
  };

  imports = [
    ./base/mutable.nix
    ./base/xdg.nix
    ./base/qt.nix

    ./program

    # Nix-index-database - for comma and command-not-found
    # inputs.nix-index-database.hmModules.nix-index
  ];
}
