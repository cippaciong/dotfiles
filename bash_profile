#
# ~/.bash_profile
#

if [ -d "$HOME/.bin" ] ; then
    PATH="$HOME/.bin:$PATH"
fi

export EDITOR=nvim
export KUBECTL_EXTERNAL_DIFF=meld

# AWS cli autocompletion
complete -C /usr/bin/aws_completer aws

# Scaling workaround for alacritty
# https://github.com/jwilm/alacritty/issues/1339#issuecomment-394315012
export WINIT_HIDPI_FACTOR=1.3
export TERMINAL=alacritty

# Silence 'Picked up _JAVA_OPTIONS' message on command line
# https://web.archive.org/web/20190507235748/https://wiki.archlinux.org/index.php/Java#Silence_'Picked_up_JAVA_OPTIONS'_message_on_command_line
export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel'
_SILENT_JAVA_OPTIONS="$_JAVA_OPTIONS"
unset _JAVA_OPTIONS
alias java='java "$_SILENT_JAVA_OPTIONS"'

# Qt5
export QT_QPA_PLATFORMTHEME=qt5ct

# Bat
export BAT_THEME=base16

# IEx history (https://www.adiiyengar.com/blog/20180503/iex-shell-history)
export ERL_AFLAGS="-kernel shell_history enabled -kernel shell_history_file_bytes 2097152"

# Ruby
export GEM_HOME="$(gem env user_gemhome)"
export PATH="$PATH:$GEM_HOME/bin"

# Go
export GOPATH="$HOME/.go"
export PATH="$PATH:$GOPATH/bin"

# Initialize rbenv (added by `rbenv init`)
eval "$(rbenv init - --no-rehash bash)"

# Load secrets and API keys
[[ -f ~/.env ]] && . ~/.env

# Load .bashrc
[[ -f ~/.bashrc ]] && . ~/.bashrc

# Autostart X at login
if [ -z "$DISPLAY" ] && [ -n "$XDG_VTNR" ] && [ "$XDG_VTNR" -eq 1 ]; then
    exec ssh-agent /usr/bin/startx
fi
