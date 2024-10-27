# Ls
alias ls='ls --color=auto'
alias ll='ls -lh'
alias la='ls -lha'

# System
alias vim='nvim'
alias vimdiff='nvim -d'
alias startx='ssh-agent startx'
alias suspend='lock.sh && systemctl suspend'
alias sudo='sudo -E '
alias grep='grep --color'
alias tsp='trackspeed.sh'

# Docker
alias dockerip='docker inspect --format="{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}" '

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
alias debiandroplet='mosh -p 1194 debiandroplet'
alias cakeoven='mosh -p 1194 cakeoven'
alias mediacenter='mosh -p 1194 mediacenter'
alias vpstels='mosh -p 1194 vpstels'

# Misc
alias ptop='sudo powertop --auto-tune'
alias wgjournal='wordgrinder ~/Sync/Nextcloud/Writing/journal.wg'
alias wgblog='wordgrinder ~/Sync/Nextcloud/Writing/blog.wg'
