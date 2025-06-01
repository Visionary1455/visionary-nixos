#!/nix/store/xy4jjgw87sbgwylm5kn047d9gkbhsr9x-bash-5.2p37/bin/bash

scrDir="$(dirname "$(realpath "$0")")"
source "${scrDir}/globalcontrol.sh"

# Generate the unbind config
"${scrDir}/keybinds.hint.py" --show-unbind >"$HYDE_STATE_HOME/unbind.conf"
# hyprctl -q keyword source "$HYDE_STATE_HOME/unbind.conf"
