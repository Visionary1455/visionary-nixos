function rebuild --description 'NixOS rebuild：默认 flake 为 .#visionary-computer，可传入参数覆盖 flake 位置'
    set -l flake ".#visionary-computer"
    if test (count $argv) -gt 0
        set flake $argv[1]
    end
    # 纯求值即可：凭据由 sops-nix 在 activation 阶段注入，无需 --impure。
    # 注意：纯模式只读取 git 已跟踪的文件，新增文件请先 `git add`，
    # 或临时改用 `path:.`（如 `sudo nixos-rebuild switch --flake path:.`）。
    sudo nixos-rebuild switch --flake $flake
end
