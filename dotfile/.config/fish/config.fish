# 编辑器统一使用 neovim。
# home-manager 的 programs.neovim.defaultEditor 只写
# /etc/profiles/per-user/visionary/etc/profile.d/hm-session-vars.sh，而 fish 不读取
# POSIX 的 profile.d，所以 EDITOR/VISUAL 必须在这里显式导出（-g 全局、-x 传给子进程）。
# 同时覆盖掉登录时残留在 systemd user 环境里的 EDITOR=nano。
set -gx EDITOR nvim
set -gx VISUAL nvim

if status is-interactive
    # Commands to run in interactive sessions can go here
    starship init fish | source

    # zoxide：智能目录跳转，替换 cd（cd 匹配历史目录，回退到真实 cd）
    zoxide init fish --cmd cd | source

    # 现代命令替代
    alias ls='eza' # 文件列表（带图标、Git 状态）
    alias grep='rg' # 递归搜索（默认忽略隐藏文件与 .gitignore）
    alias df='duf' # 磁盘使用情况
    alias du='duf' # 目录/磁盘使用情况
end

set -U fish_greeting

# 仅在交互式 SSH 登录时自动接入 tmux 的 main 会话（服务见 module/hm/program/tmux.nix）：
# 本地 kitty 窗口行为完全不变（不自动 attach、无嵌套），tmux 内的 shell 仍是 fish。
# 需要一次「裸」SSH 登录（不进 tmux）时：NO_TMUX=1 ssh visionary@10.10.10.10
if status is-interactive; and set -q SSH_CONNECTION; and not set -q TMUX; and not set -q NO_TMUX
    if command -q tmux
        tmux new-session -A -s main
    end
end
