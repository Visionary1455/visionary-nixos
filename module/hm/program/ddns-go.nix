{ config, lib, pkgs, ... }:
let
  # 阿里云 AccessKey 存于仓库外的本机文件（避免密钥进入 git/nix store）
  # 由于 flake 纯模式下无法读取仓库外文件，rebuild 时须加 --impure:
  #   sudo nixos-rebuild switch --impure --flake .
  csvPath = "${config.xdg.configHome}/ddns-go/AccessKey.csv";
  csv = builtins.readFile csvPath;

  # 解析 CSV: 跳过表头与空行, 取第一行数据 "AccessKey ID,AccessKey Secret"
  dataLines = builtins.filter (
    l:
      l != ""
      && !(lib.hasPrefix "AccessKey" l)
      && builtins.match "^[^,]+,[^,]+$" l != null
  ) (lib.splitString "\n" csv);

  dataLine =
    if builtins.length dataLines == 0 then
      throw ''
        未在 ${csvPath} 中找到有效的 AccessKey 数据行。
        请确保文件存在且格式为:
          AccessKey ID,AccessKey Secret
          LTAIxxx,xxxx
      ''
    else
      builtins.head dataLines;

  fields = lib.splitString "," dataLine;
  accessKeyId = lib.elemAt fields 0;
  accessKeySecret = lib.elemAt fields 1;
in
{
  home.packages = with pkgs; [
    ddns-go
  ];

  # ddns-go 用户级服务（开机自启依赖系统侧的 linger, 见 module/system/default.nix）
  # 常用命令:
  #   systemctl --user status ddns-go    # 查看服务状态
  #   journalctl --user -u ddns-go -f    # 查看日志
  #   http://127.0.0.1:9876              # Web 管理界面（仅本机可访问）
  systemd.user.services.ddns-go = {
    Unit = {
      Description = "ddns-go DDNS client";
      After = [ "network-online.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.ddns-go}/bin/ddns-go -c ${config.xdg.configHome}/ddns-go/config.yaml -l 127.0.0.1:9876";
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

  # ddns-go 配置文件, 由 home-manager 生成, 凭据从 AccessKey.csv 注入
  xdg.configFile."ddns-go/config.yaml".text = ''
    # ddns-go 配置 (home-manager 生成, 凭据来源: AccessKey.csv)
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
            - nixos.tangbk.top
        dns:
          name: alidns
          id: ${accessKeyId}
          secret: ${accessKeySecret}
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
}
