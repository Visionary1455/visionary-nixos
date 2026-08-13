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
