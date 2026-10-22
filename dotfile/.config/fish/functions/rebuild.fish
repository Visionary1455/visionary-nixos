function rebuild --description 'NixOS rebuild：默认使用当前目录的 flake，可传参数覆盖'
    set -l flake "."
    if test (count $argv) -gt 0
        set flake $argv[1]
    end
    # 纯求值即可：凭据由 sops-nix 在 activation 阶段注入，无需 --impure。
    # 注意：纯模式只读取 git 已跟踪的文件，新增文件请先 `git add`，
    # 或临时改用 `path:.`（如 `sudo nixos-rebuild switch --flake path:.`）。
    sudo nixos-rebuild switch --flake $flake
end
