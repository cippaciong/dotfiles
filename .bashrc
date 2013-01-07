#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

###### COLOURS ######

# ANSI color codes
RS="\[\033[0m\]"    # reset
HC="\[\033[1m\]"    # hicolor
UL="\[\033[4m\]"    # underline
INV="\[\033[7m\]"   # inverse background and foreground
FBLK="\[\033[30m\]" # foreground black
FRED="\[\033[31m\]" # foreground red
FGRN="\[\033[32m\]" # foreground green
FYEL="\[\033[33m\]" # foreground yellow
FBLE="\[\033[34m\]" # foreground blue
FMAG="\[\033[35m\]" # foreground magenta
FCYN="\[\033[36m\]" # foreground cyan
FWHT="\[\033[37m\]" # foreground white
BBLK="\[\033[40m\]" # background black
BRED="\[\033[41m\]" # background red
BGRN="\[\033[42m\]" # background green
BYEL="\[\033[43m\]" # background yellow
BBLE="\[\033[44m\]" # background blue
BMAG="\[\033[45m\]" # background magenta
BCYN="\[\033[46m\]" # background cyan
BWHT="\[\033[47m\]" # background white

color_prompt=yes
force_color_prompt=yes


#PS1='\[\e[0;31m\]\u\[\e[m\] \[\e[1;34m\]\w\[\e[m\] \[\e[0;31m\]\$ \[\e[m\]\[\e[0;32m\] '
#PS1="$HC$FYEL┌─ $HC$FCYN\u: $HC$FYEL[\w]\n$HC$FYEL└─ $HC$FWHT"
PS1="$FYEL┌─ $FCYN\u: $FYEL[\w]\n$FYEL└─ $FWHT"

#Bash completion
complete -cf gksu 
complete -cf man
complete -cf packer

###### ALIAS & EXPORT ######

export EDITOR=vim

# Output colorato pacman
#alias sudo='A=`alias` sudo '
alias pacman='pacman-color'
alias packer='packer-color'

#Systemd
alias reboot='systemctl reboot'
alias suspend='systemctl suspend'
alias poweroff='systemctl poweroff'

#Archives
alias sudo="sudo -E"
alias tarbz2="tar jxf"
alias targz="tar xzvf"
alias tarbz="tar -xjf"
alias tarxz="tar xJf"
alias bz2="bunzip2"
#alias rar="unrar x"
alias tar_normal="tar xvf"
alias tbz2="tar jxvf"
alias tgz="tar xzf"
#alias zip="tar zxf"

#Files
alias grep='grep --color=auto'
alias ls='ls --color=auto'

###### SHORTCUTS SYSTEMD ######
# simplified systemd command, for instance "sudo systemctl stop xxx.service" - > "0.stop xxx"
# start systemd service
    0.start() {
        sudo systemctl start $1.service
    }
# restart systemd service
    0.restart() {
        sudo systemctl restart $1.service
    }
# stop systemd service
    0.stop() {
        sudo systemctl stop $1.service
    }
# enable systemd service
    0.enable() {
        sudo systemctl enable $1.service
    }
# disable a systemd service
    0.disable() {
        sudo systemctl disable $1.service
    }
# show the status of a service
    0.status() {
        systemctl status $1.service
    }
# reload a service configuration
    0.reload() {
        sudo systemctl reload $1.service
    }
# list all running service
    0.list() {
        systemctl
    }
# list all failed service
    0.failed () {
        systemctl --failed
    }
# list all systemd available unit files
    0.list-files() {
        systemctl list-unit-files
    }
# check the log
    0.log() {
        sudo journalctl
    }
# show wants
    0.wants() {
        systemctl show -p "Wants" $1.target
    }
# analyze the system
    0.analyze() {
        systemd-analyze $1
    }


PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
