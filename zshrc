# Path to your oh-my-zsh installation.
export ZSH="/home/user/.oh-my-zsh"

# What's my theme?
ZSH_THEME="xxf"

# Plugins?
plugins=(
  git
  tmux
  zsh-autosuggestions
)

bindkey '^ ' forward-word

HOST="[IDE] ($PROJECT_NAME)"

alias vim="nvim"
alias dive="docker run --rm -it -v /var/run/docker.sock:/var/run/docker.sock wagoodman/dive:latest $@"

source $ZSH/oh-my-zsh.sh