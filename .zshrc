
# The following lines were added by compinstall
zstyle :compinstall filename '/home/chance/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt autocd beep
bindkey -v
# End of lines configured by zsh-newuser-install

. "$HOME/.cargo/env"

eval "$(starship init zsh)"

preexec() {
    print -Pn "\e]0;%~ - $1\a"
}

precmd() {
    print -Pn "\e]0;%~ - zsh\a"
}
