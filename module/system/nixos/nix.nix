{ config, lib, ... }:

{
  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      substituters = [
        "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
        "https://mirrors.ustc.edu.cn/nix-channels/store"
        "https://cache.nixos.org/"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
      # 增大下载缓存，防止大文件下载中断 (500MB)
      download-buffer-size = 524288000;
    
      connect-timeout = 5;
      fallback = true;
    };
  };
  nix.extraOptions = ''
     !include /etc/nix/github-access-tokens
   '';

  environment.variables = {
    NIXPKGS_ALLOW_UNFREE = "1";
    GOPROXY = "https://goproxy.cn,direct";
  };

  systemd.services.nix-daemon.environment = {
    GOPROXY = "https://goproxy.cn,direct";
  };
}
