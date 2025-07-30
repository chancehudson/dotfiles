# Directory name completion
autoload -Uz compinit
compinit

# VCS info for prompt
autoload -Uz vcs_info

zstyle ':vcs_info:git:*' actionformats '(%F{yellow}%b|%a%f) '
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' unstagedstr '%B%F{red}!%f%b'
zstyle ':vcs_info:git:*' formats '(%F{magenta}%b%u%f) '

# Terminal window name
preexec() {
    print -Pn "\e]0;%~ - $1\a"
}

# Terminal window name (idle)
precmd() {
    vcs_info
    print -Pn "\e]0;%~ - zsh\a"
}

setopt PROMPT_SUBST
PROMPT='%F{green}%m%f %F{yellow}%~%f %(?.%F{green}Y%f.%F{red}N%f) ${vcs_info_msg_0_}%f$ '

HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000

setopt AUTO_CD

alias ls="ls -la"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias ~="cd ~"

# vim mode
bindkey -v

# prefixed history search
bindkey '^[OA' history-beginning-search-backward
bindkey '^[[B' history-beginning-search-forward

# Rust path stuff
. "$HOME/.cargo/env"
