#!/nix/store/xy4jjgw87sbgwylm5kn047d9gkbhsr9x-bash-5.2p37/bin/bash

# enable float
WinFloat=$(hyprctl -j clients | jq '.[] | select(.focusHistoryID == 0) | .floating')
WinPinned=$(hyprctl -j clients | jq '.[] | select(.focusHistoryID == 0) | .pinned')

if [ "${WinFloat}" == "false" ] && [ "${WinPinned}" == "false" ] ; then
    hyprctl dispatch togglefloating active
fi

# toggle pin
hyprctl dispatch pin active

# disable float
WinFloat=$(hyprctl -j clients | jq '.[] | select(.focusHistoryID == 0) | .floating')
WinPinned=$(hyprctl -j clients | jq '.[] | select(.focusHistoryID == 0) | .pinned')

if [ "${WinFloat}" == "true" ] && [ "${WinPinned}" == "false" ] ; then
    hyprctl dispatch togglefloating active
fi

