{
  inputs,
  pkgs,
  ...
}:

{
  # Bootloader.
  # 内核来自 nixpkgs-unstable（稳定分支里没有 linuxPackages_7_1），
  # 用 pkgs.stdenv.hostPlatform.system 而非硬编码架构，与其他模块保持一致。
  boot.kernelPackages =
    inputs.nixpkgs-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system}.linuxPackages_7_1;
  boot.loader.systemd-boot.enable = true;
  # 限制保留的启动条目数，防止 ESP 分区被旧内核/initrd 占满
  boot.loader.systemd-boot.configurationLimit = 8;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 2;
  boot.initrd.enable = true;
  boot.initrd.verbose = false;
  boot.initrd.systemd.enable = true;
  # boot.initrd.availableKernelModules = [ "i915" ];
  # boot.initrd.kernelModules          = [ "i915" ];
  # boot.consoleLogLevel = 3;
  # boot.plymouth = {
  #   enable = true;
  #   font = "${pkgs.jetbrains-mono}/share/fonts/truetype/JetBrainsMono-Regular.ttf";
  #   themePackages = [ pkgs.catppuccin-plymouth ];
  #   theme = "catppuccin-macchiato";
  # };
}
