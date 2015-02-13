#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

#Load urxvt settings
xrdb -merge ~/.Xresources

#Fix QGtkStyle theme detection 
#export GTK2_RC_FILES="$HOME/.gtkrc-2.0"

# Fix cursor displayed as an X
xsetroot -cursor_name left_ptr

# start lxpolkit
lxpolkit &

# Load fonts
xset +fp /usr/share/fonts/local
xset fp rehash

#Set Wallpaper
sh ~/.fehbg &

sxhkd &

xrandr --setprovideroutputsource modesetting NVIDIA-0
xrandr --auto

# Fix blank GUI in Java apps
#https://bbs.archlinux.org/viewtopic.php?pid=1067489#p1067489
wmname LG3D

#Launch Windows Manager
#exec i3
exec bspwm
