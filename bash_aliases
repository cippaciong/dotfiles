# Ls
alias ls='ls --color=auto'
alias ll='ls -lh'
alias la='ls -lha'

# System
alias vim='nvim'
alias vimconfig='vim ~/.config/nvim/init.vim'
alias vimdiff='nvim -d'
alias startx='ssh-agent startx'
alias suspend='lock.sh && systemctl suspend'
alias sudo='sudo -E '
alias grep='grep --color'
alias tattach='tmux attach-session -t '
alias auracle='auracle --chdir ~/.build'
alias tsp='trackspeed.sh'

# Docker
alias dockerip='docker inspect --format="{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}" '

# Kubernetes
alias k='kubectl'

# Multi Monitor
# VGA
alias emc='xrandr --output VGA1  --mode 1600x900 --left-of LVDS1 && xrandr --output LVDS1 --off && ~/.fehbg && eval $(grep setx ~/.xinitrc)'
alias emcdual='xrandr --output VGA1  --mode 1600x900 --left-of LVDS1 && ~/.fehbg && eval $(grep setx ~/.xinitrc)'
alias emd='xrandr --output VGA1  --mode 1600x900 --left-of LVDS1 && ~/.fehbg && eval $(grep setx ~/.xinitrc)'
alias emo='xrandr --output LVDS1 --mode 1366x768  --left-of VGA1  && xrandr --output VGA1  --off && ~/.fehbg && eval $(grep setx ~/.xinitrc)'
# HDMI
# alias emc='xrandr --output HDMI3  --mode 1920x1080 --left-of LVDS1 && xrandr --output LVDS1 --off && ~/.fehbg && eval $(grep setx ~/.xinitrc)'
# alias emd='xrandr --output HDMI3  --mode 1920x1080 --left-of LVDS1 && ~/.fehbg && eval $(grep setx ~/.xinitrc)'
# alias emo='xrandr --output LVDS1 --mode 1366x768  --left-of HDMI3  && xrandr --output HDMI3  --off && ~/.fehbg && eval $(grep setx ~/.xinitrc)'
alias wallpaper='bash ~/.fehbg'

# Mosh
alias conciergelocal='mosh -p 1194 conciergelocal'
alias concierge='mosh -p 1194 concierge'
alias localarchdroid='mosh -p 1194 localarchdroid'
alias archdroid='mosh -p 1194 archdroid'
alias localberry='mosh -p 1194 localberry'
alias mediacenter='mosh -p 1194 mediacenter'
alias debiandroplet='mosh -p 1194 debiandroplet'
alias cumulonembo='mosh -p 1194 cumulonembo'
alias cakeoven='mosh -p 1194 cakeoven'
alias tels='mosh -p 1194 tels'
alias vpstels='mosh -p 1194 vpstels'

# Misc
alias ptop='sudo powertop --auto-tune'
alias spiceitup='spicetify backup apply'
