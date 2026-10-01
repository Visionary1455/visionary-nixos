{
  config,
  pkgs,
  lib,
  ...
}:
let
  # wayvnc 是 wlroots 系 Wayland 合成器的 VNC 服务端
  # niri 实现了 wlr-screencopy / wlr-virtual-pointer 协议，wayvnc 可直接截屏并注入输入
  # 配置放在 ~/.config/wayvnc/config，systemd 用户服务负责自启
  #
  # sops-nix 通过 sops.templates 渲染完整配置文件，密码凭据在 activation 阶段注入
  configPath = config.sops.templates.wayvnc-config.path;
in
{
  # 安装 wayvnc（服务端）与 wlvncc（对应的 VNC 客户端，可选）
  home.packages = with pkgs; [
    wayvnc
    wlvncc
  ];

  # 声明 sops 机密（加密存储于 sops/secrets.yaml，由 sops-nix 在 activation 时解密）
  sops.secrets.wayvnc-password = { };

  # wayvnc 完整配置模板，密码通过 sops.placeholder 注入
  # wayvnc 0.10 不支持 password_file，密码必须内嵌在配置中，故整体走 sops.templates
  sops.templates.wayvnc-config = {
    content = ''
      # wayvnc 配置 (home-manager + sops-nix 生成)
      address=0.0.0.0
      port=5900
      enable_auth=true
      relax_encryption=true
      allow_broken_crypto=true
      username=visionary
      password=${config.sops.placeholder.wayvnc-password}
    '';
    path = "${config.xdg.configHome}/wayvnc/config";
  };

  # wayvnc 用户级服务（自启，依赖 Wayland socket 就绪）
  systemd.user.services.wayvnc = {
    Unit = {
      Description = "wayvnc VNC server for niri";
      After = [
        "graphical-session.target"
        "niri.service"
      ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      Type = "simple";
      # WAYLAND_DISPLAY 从 systemd user manager 环境继承（避免硬编码）
      ExecStart = "${pkgs.wayvnc}/bin/wayvnc --render-cursor --config ${configPath}";
      Restart = "on-failure";
      RestartSec = 3;
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
