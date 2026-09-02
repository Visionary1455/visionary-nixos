{
  config,
  lib,
  pkgs,
  ...
}:
let
  # sops-nix 通过 sops.templates 渲染完整配置文件，凭据在 activation 阶段注入
  configPath = config.sops.templates.ddns-go-config.path;
in
{
  home.packages = with pkgs; [
    ddns-go
  ];

  # 声明 sops 机密（加密存储于 sops/secrets.yaml，由 sops-nix 在 activation 时解密）
  sops.secrets.ddns-access-key-id = { };
  sops.secrets.ddns-access-key-secret = { };

  # ddns-go 完整配置模板，凭据通过 sops.placeholder 注入
  sops.templates.ddns-go-config = {
    content = ''
      # ddns-go 配置 (home-manager + sops-nix 生成)
      dnsconf:
        - name: 阿里云
          ipv4:
            enable: false
            gettype: url
            url: https://4.ipw.cn
            netinterface: ""
            cmd: ""
            domains: []
          ipv6:
            enable: true
            gettype: url
            url: https://api6.ipify.org,https://ipv6.icanhazip.com
            netinterface: ""
            cmd: ""
            ipv6reg: ""
            domains:
              - nixosv6.tangbk.top
          dns:
            name: alidns
            id: ${config.sops.placeholder.ddns-access-key-id}
            secret: ${config.sops.placeholder.ddns-access-key-secret}
            extparam: ""
          ttl: ""
          httpinterface: ""
      username: ""
      password: ""
      webhookurl: ""
      webhookrequestbody: ""
      webhookrequestheaders: ""
      webhookrequestmethod: ""
      notallowwanaccess: true
      lang: zh
    '';
    path = "${config.xdg.configHome}/ddns-go/config.yaml";
  };

  # ddns-go 用户级服务（开机自启依赖系统侧的 linger, 见 module/system/default.nix）
  systemd.user.services.ddns-go = {
    Unit = {
      Description = "ddns-go DDNS client";
      After = [ "network-online.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.ddns-go}/bin/ddns-go -c ${configPath} -l 127.0.0.1:9876";
      Restart = "always";
      RestartSec = 5;
      # 安全加固
      NoNewPrivileges = true;
      PrivateTmp = true;
      ProtectSystem = "strict";
      ProtectHome = "read-only";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
