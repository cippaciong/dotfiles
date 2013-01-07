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

#Define custom terminal for i3-sensible-terminal
export TERMINAL=termite

#Define default browser for termite and others
export BROWSER=firefox

#Fix QGtkStyle theme detection 
export GTK2_RC_FILES="$HOME/.gtkrc-2.0"

#Set Wallpaper
sh ~/.fehbg &

#sxhkd

#Launch Windows Manager
exec i3
#exec bspwm
