#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

## PATH
export PATH="$PATH:$HOME/.bspwm_scripts:$HOME/.scripts"

# Define bspwm socket, backup and ewmhstatus fifo file
export BSPWM_SOCKET=/tmp/bspwm-socket
export BSPWM_BACKUP=/tmp/bspwm-backup
export PANEL_FIFO=/tmp/panel-fifo
export SXHKD_SHELL=/bin/dash
export EWMHSTATUS_FIFO=/tmp/ewmhstatus-fifo

## Variables for XDG
## See https://bbs.archlinux.org/viewtopic.php?pid=1237930#p1237930
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-"$HOME/.config"}
export XDG_DATA_HOME=${XDG_DATA_HOME:-"$HOME/.local/share"}
export XDG_CACHE_HOME=${XDG_CACHE_HOME:-"$HOME/.cache"}

## Define custom terminal for i3-sensible-terminal
export TERMINAL=termite
## Define default browser for termite and others
export BROWSER=chromium

