#!/nix/store/xy4jjgw87sbgwylm5kn047d9gkbhsr9x-bash-5.2p37/bin/bash

echo "This script will be deprecated. Please use theme.switch.sh instead."
scrDir="$(dirname "$(realpath "$0")")"
"${scrDir}"/theme.switch.sh "$@"
