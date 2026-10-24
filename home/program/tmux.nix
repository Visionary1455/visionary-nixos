{ config, pkgs, ... }:

let
  # 开机服务与 SSH 自动 attach 共用同一个会话名
  sessionName = "main";
in
{
  # tmux 只作为「会话宿主」引入：不接管 kitty，也不替换 fish，
  # 终端模拟器仍是 kitty，tmux 内部的 shell 仍是 fish。
  programs.tmux = {
    enable = true;
    # 开机自启的 tmux server 由 systemd 拉起，其环境里没有登录 shell 信息，
    # 显式指定 default-shell 才能保证面板里跑的是 fish。
    shell = "${pkgs.fish}/bin/fish";
    # tmux-256color 的 terminfo 由 ncurses 提供（/run/current-system/sw/share/terminfo），
    # 比默认 screen-256color 更贴合现代终端。
    terminal = "tmux-256color";
    historyLimit = 50000;
    baseIndex = 1;
    mouse = true;
    keyMode = "vi";
    clock24 = true;
    focusEvents = true;
    # 降低 ESC 延迟，vim/nvim 按键响应更跟手
    escapeTime = 0;
    extraConfig = ''
      # kitty 支持真彩色与下划线，透传给 tmux 面板内的程序
      set -as terminal-features ",xterm-kitty:RGB:usstyle"
      # 关闭窗口后重排编号，避免编号跳空
      set -g renumber-windows on
      # 与系统剪贴板互通（kitty 支持 OSC 52）
      set -g set-clipboard on
    '';
  };

  # 开机即拉起一个分离的 main 会话（用户级 linger 已在 system/default.nix 开启，
  # 无需图形登录）；会话已存在时保持原样，不会踢掉已 attach 的客户端。
  systemd.user.services.tmux-main = {
    Unit = {
      Description = "tmux detached session (${sessionName})";
      Documentation = [ "man:tmux(1)" ];
    };
    Service = {
      Type = "oneshot";
      RemainAfterExit = true;
      WorkingDirectory = "%h";
      ExecStart = "${pkgs.bash}/bin/bash -c '${pkgs.tmux}/bin/tmux has-session -t ${sessionName} 2>/dev/null || exec ${pkgs.tmux}/bin/tmux new-session -d -s ${sessionName}'";
    };
    Install.WantedBy = [ "default.target" ];
  };
}
