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
    ./base/mutable.nix
    ./base/xdg.nix
    ./base/qt.nix

    ./program

    # Nix-index-database - for comma and command-not-found
    # inputs.nix-index-database.hmModules.nix-index
  ];
}
