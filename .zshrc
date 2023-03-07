# Add themes to fpath
fpath=(~/.zprompt $fpath)
fpath+=$HOME/.zsh/typewritten

ZSH_THEME=""
autoload -U promptinit; promptinit
prompt typewritten
EDITOR=nvim
# The following lines were added by compinstall
zstyle ':completion:*' completer _complete _ignored _correct _approximate
zstyle ':completion:*' matcher-list ''
zstyle :compinstall filename '/home/alex/.zshrc'

autoload -Uz compinit
compinit

# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -e

# Check interactive mode
[[ $- != *i* ]] && return
[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx

# Set the prompt to a custom 'bart'x'adam2'
#prompt_hyper_setup() {
#    NEWLINE=$'\n'
#    CAP=$'\e[A'
#    TICK='\`'
#    #RPS1="$CAP%D %F{cyan}%T%f$NEWLINE"
#    PS1="%F{cyan}%m %f%F{black}%B(%b%f %F{blue}%~%f %F{black}%B)%b%f $NEWLINE%f%F{cyan}%B$TICK--%f> "
#}

# prompt_themes+=( hyper )

export FZF_DEFAULT_OPTS=" \
--color=bg+:#363a4f,bg:#24273a,spinner:#f4dbd6,hl:#ed8796 \
--color=fg:#cad3f5,header:#ed8796,info:#c6a0f6,pointer:#f4dbd6 \
--color=marker:#f4dbd6,fg+:#cad3f5,prompt:#c6a0f6,hl+:#ed8796"

# Enable relevant plugins
plugins=(archlinux rust git zsh-autosuggestions zsh-syntax-highlighting)

export COLORTERM="truecolor"
if [[ "$TERM" == "dumb" ]]
then
  unsetopt zle
  unsetopt prompt_cr
  unsetopt prompt_subst
  unfunction precmd
  unfunction preexec
  PS1='$ '
fi
