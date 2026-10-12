{ lib, ... }:
let
  USERNAME = "visionary";
in
{
  # 创建 Hypr 相关目录（供 home.file 的 logo 目录使用）
  home.activation.createHyprConfigs = lib.hm.dag.entryAfter [ "mutableGeneration" ] ''
    mkdir -p "$HOME/.config/fastfetch/logo"
  '';

  home = {
    username = USERNAME;
    homeDirectory = "/home/${USERNAME}";
    stateVersion = "26.05";
  };

  imports = [
    ./sops.nix

    ./base/mutable.nix
    ./base/xdg.nix
    ./base/qt.nix

    ./program

    # Nix-index-database - for comma and command-not-found
    # 注：对应的 flake input 已移除；如需启用，先恢复 flake.nix 中的
    # nix-index-database input，再取消下一行注释。
    # inputs.nix-index-database.hmModules.nix-index
  ];
}
