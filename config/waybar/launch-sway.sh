#!/bin/sh

# Replace the current instance so a Sway config reload also reloads Waybar.
pkill -x waybar 2>/dev/null || true
exec waybar --config "$HOME/.config/waybar/config-sway.jsonc"
