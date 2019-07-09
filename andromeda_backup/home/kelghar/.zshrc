ZSH=$HOME/.oh-my-zsh

plugins=(git)

ZSH_THEME="steeef"

# want your terminal to support 256 color schemes? I do ...
export TERM="xterm-256color"

# if you do a 'rm *', Zsh will give you a sanity check!
setopt RM_STAR_WAIT

# allows you to type Bash style comments on your command line
# good 'ol Bash
setopt interactivecomments

# Zsh has a spelling corrector
setopt CORRECT
source $ZSH/oh-my-zsh.sh

export EDITOR="vim"
export USE_EDITOR=$EDITOR
export VISUAL=$EDITOR

alias tm='tmuxinator andromeda'
alias ll='ls -l'
alias evim='$EDITOR ~/.vimrc'
alias etmux='$EDITOR ~/.tmux.conf'
alias ezsh='$EDITOR ~/.zshrc'
alias cl=clear
alias apt-search='sudo apt-cache search'
alias apt-install='sudo apt-get install'
#alias tm='tmux attach -t andromeda || tmux new -s andromeda'

