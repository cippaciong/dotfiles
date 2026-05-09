#!/usr/bin/env bash
set -u

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
    COLOR_SCHEME="prefer-dark"
else
    GTK_THEME="HighContrast"
    GTK_DARK=false
    COLOR_SCHEME="prefer-light"
fi

set_ini_value() {
    local file="$1"
    local key="$2"
    local value="$3"

    mkdir -p "$(dirname "$file")"
    touch "$file"

    if grep -q "^${key}=" "$file"; then
        sed -i "s|^${key}=.*|${key}=${value}|" "$file"
    else
        printf '%s=%s\n' "$key" "$value" >> "$file"
    fi
}

set_xsettings_value() {
    local file="$1"
    local key="$2"
    local value="$3"

    mkdir -p "$(dirname "$file")"
    touch "$file"

    if grep -q "^${key} " "$file"; then
        sed -i "s|^${key} .*|${key} ${value}|" "$file"
    else
        printf '%s %s\n' "$key" "$value" >> "$file"
    fi
}

# GSettings is what current Firefox and many GTK/libadwaita apps use for
# prefers-color-scheme. GTK config files are kept for apps started later.
if command -v gsettings >/dev/null 2>&1; then
    gsettings set org.gnome.desktop.interface gtk-theme "$GTK_THEME" 2>/dev/null || true
    gsettings set org.gnome.desktop.interface color-scheme "$COLOR_SCHEME" 2>/dev/null || true
fi

# GTK 3
set_ini_value "$HOME/.config/gtk-3.0/settings.ini" "gtk-theme-name" "$GTK_THEME"
set_ini_value "$HOME/.config/gtk-3.0/settings.ini" "gtk-application-prefer-dark-theme" "$GTK_DARK"

# GTK 2
set_ini_value "$HOME/.gtkrc-2.0" "gtk-theme-name" "\"$GTK_THEME\""

# XSettings is needed for live GTK theme updates under i3/X11. If xsettingsd is
# installed and running, HUP makes it publish the new values to open apps.
XSETTINGSD_CONFIG="$HOME/.config/xsettingsd/xsettingsd.conf"
set_xsettings_value "$XSETTINGSD_CONFIG" "Net/ThemeName" "\"$GTK_THEME\""
set_xsettings_value "$XSETTINGSD_CONFIG" "Net/PreferDarkTheme" "$( [ "$GTK_DARK" = true ] && echo 1 || echo 0 )"
if command -v xsettingsd >/dev/null 2>&1; then
    if pgrep -x xsettingsd >/dev/null 2>&1; then
        pkill -HUP -x xsettingsd 2>/dev/null || true
    else
        xsettingsd >/dev/null 2>&1 &
    fi
fi

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
