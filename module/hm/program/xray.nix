{
  config,
  pkgs,
  lib,
  ...
}:

let
  # sops-nix 通过 sops.templates 渲染完整配置文件，凭据在 activation 阶段注入
  configPath = config.sops.templates.xray-config.path;
in
{
  # activation 阶段创建日志目录（xray 服务以 ProtectHome=read-only 运行，无法自行创建）
  home.activation.createXrayLogDir = lib.hm.dag.entryAfter [ "mutableGeneration" ] ''
    mkdir -p "${config.home.homeDirectory}/log/xray"
  '';
  # 声明 sops 机密（加密存储于 sops/secrets.yaml，由 sops-nix 在 activation 时解密）
  sops.secrets.xray-id = { };
  sops.secrets.xray-address = { };

  # xray 完整配置模板，凭据通过 sops.placeholder 注入
  sops.templates.xray-config = {
    content = builtins.toJSON {
      log = {
        loglevel = "warning";
        access = "${config.home.homeDirectory}/log/xray/access.log";
        error = "${config.home.homeDirectory}/log/xray/error.log";
      };
      reverse = {
        bridges = [
          {
            tag = "reverse-in";
            domain = "reverse.home.internal";
          }
        ];
      };
      routing = {
        domainStrategy = "IPIfNonMatch";
        rules = [
          {
            type = "field";
            inboundTag = [ "reverse-in" ];
            domain = [ "reverse.home.internal" ];
            outboundTag = "reverse-connection";
          }
          {
            type = "field";
            inboundTag = [ "reverse-in" ];
            outboundTag = "home-direct";
          }
        ];
      };
      outbounds = [
        {
          protocol = "freedom";
          tag = "direct";
        }
        {
          protocol = "vless";
          tag = "reverse-connection";
          settings = {
            vnext = [
              {
                address = config.sops.placeholder.xray-address;
                port = 443;
                users = [
                  {
                    id = config.sops.placeholder.xray-id;
                    encryption = "none";
                    flow = "xtls-rprx-vision";
                  }
                ];
              }
            ];
          };
          streamSettings = {
            network = "tcp";
            security = "tls";
            tlsSettings = {
              serverName = config.sops.placeholder.xray-address;
              allowInsecure = false;
            };
          };
        }
        {
          protocol = "freedom";
          tag = "home-direct";
          settings = {
            domainStrategy = "UseIPv4";
            finalRules = [
              {
                action = "allow";
                network = "tcp,udp";
                ip = [ "10.10.10.0/24" ];
              }
            ];
          };
        }
      ];
    };
    path = "${config.xdg.configHome}/xray/config.json";
  };

  # xray 用户级服务（开机自启依赖系统侧的 linger, 见 module/system/default.nix）
  systemd.user.services.xray = {
    Unit = {
      Description = "xray proxy service";
      After = [ "network-online.target" ];
    };
    Service = {
      Type = "simple";
      ExecStartPre = "${pkgs.xray}/bin/xray -test -config ${configPath}";
      ExecStart = "${pkgs.xray}/bin/xray run -c ${configPath}";
      Restart = "always";
      RestartSec = 5;
      # 安全加固
      NoNewPrivileges = true;
      PrivateTmp = true;
      ProtectSystem = "strict";
      ProtectHome = "read-only";
      ReadWritePaths = [ "%h/log/xray" ];
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
