function rebuild --description 'NixOS rebuild：默认 flake 为 .#visionary-computer，可传入参数覆盖 flake 位置'
    set -l flake ".#visionary-computer"
    if test (count $argv) -gt 0
        set flake $argv[1]
    end
    sudo nixos-rebuild switch --flake $flake --impure
end
