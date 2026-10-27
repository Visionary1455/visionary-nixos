{
  config,
  pkgs,
  ...
}:
let
  # lamco-rdp-server 未进入 nixpkgs，使用仓库内的 callPackage 派生。
  lamcoRdpServer = pkgs.callPackage ../../overlays/lamco-rdp-server.nix { };

  configDir = "${config.xdg.configHome}/lamco-rdp-server";
  configPath = "${configDir}/config.toml";
in
{
  # RDP 服务端本体；niri 属于 wlroots，使用原生 wlr 截屏/输入后端。
  home.packages = [ lamcoRdpServer ];

  # 服务配置。TLS 证书不存在时，lamco 会在首次启动时自动生成到同一目录。
  # NLA/CredSSP 需要静态凭据，无法直接走 PAM；这里的密码应与系统登录密码
  # 保持一致，修改系统密码后要同步更新 sops 机密并 rebuild，否则 NLA 会失败。
  # sops 中存 TOML basic string 的转义形式（由设置脚本处理），模板外层引号
  # 解析后还原原始密码。
  sops.secrets."lamco-rdp-password" = { };

  sops.templates."lamco-rdp-config" = {
    path = configPath;
    content = ''
      # lamco-rdp-server 配置（home-manager + sops-nix 生成）

      [server]
      listen_addr = "[::]:3389"
      max_connections = 4
      session_timeout = 0
      # niri 是 wlroots 合成器，直接走原生 Wayland 协议，不使用外部 portal 守护进程。
      use_portals = false

      [security]
      cert_path = "${configDir}/cert.pem"
      key_path = "${configDir}/key.pem"
      enable_nla = false
      # Hybrid = NLA/CredSSP；mstsc 会先完成 NLA，再进入桌面。
      security_mode = "hybrid"
      auth_method = "none"
      require_tls_13 = false

      [security.credssp_credentials]
      username = "visionary"
      password = "${config.sops.placeholder."lamco-rdp-password"}"

      [input]
      input_protocol = "wlr"
      keyboard_layout = "auto"
      enable_touch = false
    '';
  };

  # 用户级服务，随 niri 图形会话启动；Wayland/PipeWire 环境从 systemd user manager 继承。
  systemd.user.services.lamco-rdp-server = {
    Unit = {
      Description = "Lamco RDP server for niri";
      Documentation = [ "https://github.com/lamco-admin/lamco-rdp-server" ];
      After = [
        "graphical-session.target"
        "niri.service"
        # sops-nix 先渲染 config.toml（内含 NLA 凭据），否则服务读不到配置。
        "sops-nix.service"
      ];
      Requires = [ "sops-nix.service" ];
      PartOf = [ "graphical-session.target" ];
      ConditionEnvironment = "WAYLAND_DISPLAY";
    };
    Service = {
      Type = "simple";
      ExecStart = "${lamcoRdpServer}/bin/lamco-rdp-server --config ${configPath}";
      Restart = "on-failure";
      RestartSec = 3;
      Environment = [ "RUST_LOG=info" ];
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
