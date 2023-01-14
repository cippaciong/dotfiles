#!/bin/sh

player_status=$(playerctl status 2> /dev/null)

#songinfo="$(playerctl metadata artist) - $(playerctl metadata title) - $(date -d@$(playerctl position) -u +%M:%S)"
songtitle="$(playerctl metadata title 2> /dev/null)"

if [ "$player_status" = "Playing" ]; then
    echo " ${songtitle}"
elif [ "$player_status" = "Paused" ]; then
    echo " ${songtitle}"
else
    echo ""
fi
