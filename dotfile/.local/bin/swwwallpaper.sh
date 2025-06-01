#!/nix/store/xy4jjgw87sbgwylm5kn047d9gkbhsr9x-bash-5.2p37/bin/bash
# shellcheck disable=SC2154

cat <<EOF
DEPRECATION: This script is deprecated, please use 'wallpaper.sh' instead."

-------------------------------------------------
example: 
wallpaper.sh ${@} --backend swww --global
-------------------------------------------------
EOF

"wallpaper.sh" "${@}" --backend swww --global
