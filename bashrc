#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Don't save command beginning with whitespace in history
export HISTCONTROL='ignoreboth:erasedups'

# Eternal bash history.
# ---------------------
# Undocumented feature which sets the size to "unlimited".
# http://stackoverflow.com/questions/9457233/unlimited-bash-history
export HISTFILESIZE=
export HISTSIZE=
export HISTTIMEFORMAT="[%F %T] "
# Change the file location because certain bash sessions truncate .bash_history file upon close.
# http://superuser.com/questions/575479/bash-history-truncated-to-500-lines-on-each-login
export HISTFILE=~/.bash_eternal_history
# Force prompt to write history after every command.
# http://superuser.com/questions/20900/bash-history-loss
PROMPT_COMMAND="history -a; $PROMPT_COMMAND"

####### COLORS #######
force_color_prompt=yes
color_prompt=yes

# Check for an interactive session
[ -z "$PS1" ] && return

# ANSI color codes
RS="\[\033[0m\]"        # reset
HC="\[\033[1m\]"    # hicolor
UL="\[\033[4m\]"    # underline
INV="\[\033[7m\]"   # inverse background and foreground
FBLK="\[\033[0;30m\]"   # foreground black
FRED="\[\033[0;31m\]"   # foreground red
FGRN="\[\033[0;32m\]"   # foreground green
FYEL="\[\033[0;33m\]"   # foreground yellow
FBLE="\[\033[0;34m\]"   # foreground blue
FMAG="\[\033[0;35m\]"   # foreground magenta
FCYN="\[\033[0;36m\]"   # foreground cyan
FWHT="\[\033[0;37m\]"   # foreground white
BBLK="\[\033[0;40m\]"   # background black
BRED="\[\033[0;41m\]"   # background red
BGRN="\[\033[0;42m\]"   # background green
BYEL="\[\033[0;43m\]"   # background yellow
BBLE="\[\033[0;44m\]"   # background blue
BMAG="\[\033[0;45m\]"   # background magenta
BCYN="\[\033[0;46m\]"   # background cyan
BWHT="\[\033[0;47m\]"   # background white

PS1="$FBLE┌─ $HC$FGRN\u $HC$FWHT[\w]\n$RS$FBLE└─ $FWHT"

###### KUBERNETES CLUSTER PROMPT ######
# function prompt_right() {
#   # context="$(kubectl config current-context | cut -d '/' -f 2)"
#   context=" "
#   echo -e "$FYEL[$context]$RS"
# }

# function prompt_left() {
#   echo -e "$FBLE┌─ $FGRN\\\t $HC$FWHT[\w]"
# }

# function prompt() {
#     compensate=19
#     PS1=$(printf "%*s\r%s\n\[\033[0;34m\]└─ $FWHT\\\$ " "$(($(tput cols)+${compensate}))" "$(prompt_right)" "$(prompt_left)")
# }
# PROMPT_COMMAND=prompt

####### ALIAS & EXPORT #######
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

eval $(dircolors ~/.dircolors)

# Disable XON/XOFF in order to use forward history search with Crtl+S
stty -ixon

# Load bashmarks
source /usr/share/bashmarks/bashmarks.sh

# Ruby
export PATH="$(ruby -e 'print Gem.user_dir')/bin:$PATH"
export GEM_HOME=$(ruby -e 'print Gem.user_dir')

# Go
export GOPATH="$HOME/.go"
export PATH="$PATH:$GOPATH/bin"
export GO111MODULE=auto

# Nodejs / npm
export npm_config_prefix="$HOME/.node_modules"
export PATH="$PATH:$npm_config_prefix/bin"

# Terraform12
# export PATH="/opt/terraform12:$PATH"

# Terraform13
# export PATH="/opt/terraform13:$PATH"

# fzf
# <CTRL+T> list files+folders in current directory (e.g., git commit <CTRL+T>, select a few files using <TAB>, finally <Return>)
# <CTRL+R> search history of shell commands
# <ALT+C> fuzzy change directory
source /usr/share/fzf/key-bindings.bash
source /usr/share/fzf/completion.bash

# Kubectl bash completion
source <(kubectl completion bash)
complete -F __start_kubectl k

# Kustomize bash completion
complete -C /usr/bin/kustomize kustomize

# Don't escape $ during path tab completion
# https://askubuntu.com/questions/70750/how-to-get-bash-to-stop-escaping-during-tab-completion
shopt -s direxpand
