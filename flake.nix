{
  description = "Visionary's NixOS configuration";

  # 让首次 `nixos-rebuild`（此时系统级 nix.settings 尚未生效）也走国内镜像。
  # extra- 前缀是「追加」而非覆盖：默认的 cache.nixos.org 仍保留，镜像内容由
  # 默认信任的 cache.nixos.org-1 签名，因此无需额外公钥即可使用。
  # 注意：这类设置不在 Nix 的白名单内，需要 `accept-flake-config` 才会自动生效，
  # 否则交互式会提示、非交互式会忽略（见 module/system/nixos/nix.nix）。
  nixConfig = {
    extra-substituters = [
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
      "https://mirror.iscas.ac.cn/nix-channels/store"
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    # nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    quickshell = {
      url = "git+https://git.outfoxxed.me/quickshell/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dms = {
      url = "github:AvengeMedia/DankMaterialShell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "git+https://gh-proxy.com/https://github.com/Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # opencode 2（V2 CLI，安装为 opencode2 命令，nixpkgs 里的 opencode 仍是 1.x）。
    # 不做 nixpkgs follows：本仓库锁定的 nixpkgs-unstable 较旧、缺
    # installAgentSkills 等参数，而该 flake 求值 packages 集合时会强制求值全部
    # 包的 meta，导致整个集合求值失败；沿用其自带的 nixpkgs 即可。
    llm-agents.url = "github:numtide/llm-agents.nix";
  };

  outputs =
    inputs@{ nixpkgs, ... }:
    let
      system = "x86_64-linux";
      hostname = "visionary-computer";
      dotfile_dir = ./dotfile;

      nixosConfig = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs dotfile_dir;
        };
        modules = [
          ./host/configuration.nix
          ./host/hardware-configuration.nix
          ./module/system

          inputs.home-manager.nixosModules.home-manager
          {
            home-manager = {
              verbose = true;
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "backhm";
              extraSpecialArgs = {
                inherit inputs dotfile_dir;
              };
              users.visionary = ./module/hm;
            };
          }
        ];
      };
    in
    {
      nixosConfigurations.${hostname} = nixosConfig;

      # nix flake check 会求值（并可构建）该检查，等价于构建完整系统闭包，
      # 因此本地快速校验请用 `nix flake check --no-build`。
      checks.${system}.default = nixosConfig.config.system.build.toplevel;

      formatter.${system} = nixpkgs.legacyPackages.${system}.nixfmt;
    };
}
