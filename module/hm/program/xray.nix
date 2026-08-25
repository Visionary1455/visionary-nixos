{
  config,
  pkgs,
  dotfile_dir,
  ...
}:

let
  # 配置文件部署路径（由下方 xdg.configFile 从 dotfile 模板注入凭据后生成）
  configPath = "${config.xdg.configHome}/xray/config.json";

  # 服务器凭据存于仓库外的本机文件（避免 UUID/域名进入 git/nix store）
  # 由于 flake 纯模式下无法读取仓库外文件，rebuild 时须加 --impure:
  #   sudo nixos-rebuild switch --impure --flake .
  credsPath = "${config.xdg.configHome}/xray/credentials.json";
  creds = builtins.fromJSON (
    if builtins.pathExists credsPath then
      builtins.readFile credsPath
    else
      throw ''
        未找到 ${credsPath}。
        请先创建该文件（格式如下）后重新执行 rebuild:
          {
            "id": "<VLESS UUID>",
            "address": "<服务器域名>"
          }
      ''
  );

  # 将 dotfile 模板中的占位符替换为真实凭据, 生成最终配置
  configJson =
    builtins.replaceStrings
      [
        "__XRAY_ID__"
        "__XRAY_ADDRESS__"
      ]
      [
        creds.id
        creds.address
      ]
      (builtins.readFile (dotfile_dir + /.config/xray/config.json));
in
{
  # xray 用户级服务（开机自启依赖系统侧的 linger, 见 module/system/default.nix）
  # 配置文件来自仓库内 dotfile/.config/xray/config.json（软链接管理）:
  #   编辑模板后执行 sudo nixos-rebuild switch --impure --flake . 生效
  # 常用命令:
  #   systemctl --user status xray       # 查看服务状态
  #   journalctl --user -u xray -f       # 查看日志
  systemd.user.services.xray = {
    Unit = {
      Description = "xray proxy service";
      After = [ "network-online.target" ];
    };
    Service = {
      Type = "simple";
      # 启动前校验配置, 失败（退出码 23）则服务不启动, 便于排查手改的配置
      ExecStartPre = "${pkgs.xray}/bin/xray -test -config ${configPath}";
      ExecStart = "${pkgs.xray}/bin/xray run -c ${configPath}";
      Restart = "always";
      RestartSec = 5;
      # 安全加固
      NoNewPrivileges = true;
      PrivateTmp = true;
      ProtectSystem = "strict";
      ProtectHome = "read-only";
      # ProtectHome=read-only 会导致 xray 无法打开日志文件(exit 23 崩溃循环),
      # 仅放行日志目录的写入, %h 为服务用户主目录
      ReadWritePaths = [ "%h/log/xray" ];
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };

  # xray 配置文件, 由 home-manager 生成: dotfile 模板 + credentials.json 注入
  xdg.configFile."xray/config.json".text = configJson;
}
