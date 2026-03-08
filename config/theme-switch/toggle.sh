#!/bin/bash

THEME_FILE="$HOME/.config/theme-switch/current"
CURRENT=$(cat "$THEME_FILE" 2>/dev/null || echo "dark")

if [ "$CURRENT" = "dark" ]; then
    NEW_THEME="light"
else
    NEW_THEME="dark"
fi

echo "$NEW_THEME" > "$THEME_FILE"

# ── GTK / system ──────────────────────────────────────────────
if [ "$NEW_THEME" = "dark" ]; then
    GTK_THEME="Nordic-darker"
    GTK_DARK=true
else
    GTK_THEME="HighContrast"
    GTK_DARK=false
fi

# GTK 3
sed -i "s/^gtk-theme-name=.*/gtk-theme-name=$GTK_THEME/" \
    "$HOME/.config/gtk-3.0/settings.ini"
sed -i "s/^gtk-application-prefer-dark-theme=.*/gtk-application-prefer-dark-theme=$GTK_DARK/" \
    "$HOME/.config/gtk-3.0/settings.ini"

# GTK 2
sed -i "s/^gtk-theme-name=.*/gtk-theme-name=\"$GTK_THEME\"/" \
    "$HOME/.gtkrc-2.0"

# ── Neovim ────────────────────────────────────────────────────
for socket in /run/user/$(id -u)/nvim.*; do
    [ -S "$socket" ] && nvim --server "$socket" \
        --remote-send "<Cmd>lua ApplyTheme()<CR>" 2>/dev/null
done

# ── Alacritty ─────────────────────────────────────────────────
ln -sf "$HOME/.config/alacritty/themes/${NEW_THEME}.toml" \
       "$HOME/.config/alacritty/themes/theme.toml"
touch "$HOME/.config/alacritty/alacritty.toml"

# ── i3 ────────────────────────────────────────────────────────
ln -sf "$HOME/.config/i3/i3-${NEW_THEME}.conf" \
       "$HOME/.config/i3/i3-colors.conf"
i3-msg reload 2>/dev/null

# ── Polybar ───────────────────────────────────────────────────
ln -sf "$HOME/.config/polybar/colors-${NEW_THEME}.ini" \
       "$HOME/.config/polybar/colors.ini"
~/.config/polybar/launch.sh 2>/dev/null &
