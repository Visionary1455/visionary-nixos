{ pkgs, inputs, ... }:

{
  # Clash Verge Rev（mihomo 内核 GUI 客户端）
  # 使用 unstable 频道获取最新版本
  programs.clash-verge = {
    enable = true;
    package = inputs.nixpkgs-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system}.clash-verge-rev;
    tunMode = true;
    serviceMode = true;
    autoStart = true;
  };
}
