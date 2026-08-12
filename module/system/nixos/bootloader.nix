{
  inputs,
  pkgs,
  ...
}:

{
  # Bootloader.
  boot.kernelPackages =
    inputs.nixpkgs-unstable.legacyPackages.x86_64-linux.linuxPackages_7_1;
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
