#!/bin/bash
STATE="/tmp/.kitty-width-wide"
SOCKET="unix:$(ls /tmp/kitty-* 2>/dev/null | head -1)"
if [ -f "$STATE" ]; then
    kitty @ --to "$SOCKET" set-spacing padding-left=250 padding-right=250
    rm "$STATE"
else
    kitty @ --to "$SOCKET" set-spacing padding-left=10 padding-right=10
    touch "$STATE"
fi
