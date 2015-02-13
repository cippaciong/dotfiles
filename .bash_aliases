# Misc
alias fuck='sudo $(history -p \!\!)'
alias cdgit='cd /media/Dati/git'
alias lucchetto='yapet /media/Dati/Syncthing/Yapet/lucchetto.pet'
alias copia_apk='find /media/Dati/Syncthing/Raccoon/archives/default/apk_storage -name "*.apk" -exec rsync -e "ssh -p 110 -i /home/cippaciong/.ssh/cakeoven_key" -av --progress {} cippaciong@cakeboss.tk:"apks/" \;'

# SSH - MOSH
alias localberry='mosh -p 1194 localberry'
alias berry='mosh -p 1194 berry'
alias cakeoven='mosh -p 1194 cakeoven'
alias debiandroplet='mosh -p 1194 debiandroplet'
alias tels='mosh -p 1194 tels'
alias vpstels='mosh -p 1194 vpstels'
alias navigatoria='mosh -p 1194 navigatoria'
alias startx='ssh-agent startx'
#alias ssh='eval $(/usr/bin/keychain --eval --agents ssh -Q --quiet ~/.ssh/raspberry_key) && ssh'

# ls
alias ls='ls --color=auto'
alias ll='ls -lh'
alias la='ls -lha'

# grep
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# teamviewer
alias teamviewerstart='sudo systemctl start teamviewerd'
alias teamviewerstop='sudo systemctl stop teamviewerd'

# redshift
alias redstart='systemctl --user restart redshift'
