[ -d "$HOME/.bin" ] && PATH="$PATH:$HOME/.bin"
[ -d "$HOME/.local/bin" ] && PATH="$PATH:$HOME/.local/bin"
[ -d "$HOME/.cargo/bin" ] && PATH="$PATH:$HOME/.cargo/bin"
[ -d "$HOME/.deno/bin" ] && PATH="$PATH:$HOME/.deno/bin"
[ -d "$HOME/.cabal/bin" ] && PATH="$PATH:$HOME/.cabal/bin"
[ -d "$HOME/.ghcup/bin" ] && PATH="$PATH:$HOME/.ghcup/bin"
[ -d "$HOME/.rbenv/bin" ] && PATH="$PATH:$HOME/.rbenv/bin"
[ -d "$HOME/.pyenv/bin" ] && PATH="$PATH:$HOME/.pyenv/bin"

# If not running interactively, don't do the rest
case $- in
  *i*) ;;
  *) return;;
esac

[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"
[ -f "$HOME/.fzf.bash" ] && . "$HOME/.fzf.bash"
[ -f "$HOME/.config/broot/launcher/bash/br" ] && . "$HOME/.config/broot/launcher/bash/br"
check kitty && eval "$(kitty + complete setup bash)"
check pazi && eval "$(pazi init bash)"
check rbenv && eval "$(rbenv init - bash)"
check pyenv && eval "$(pyenv init - bash)"
check rustup && eval "$(rustup completions bash)"

if check fnm; then
    eval "$(fnm completions)"
    eval "$(fnm env)"
fi

if check exa; then 
    alias ls='exa'
    alias ll='exa -alg --git'
    alias lt='exa -T'
    alias llt='exa -lT'
    alias l='exa'
fi

# enable colors in grep by default
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

if check kak; then
    export GIT_EDITOR=kak
    export EDITOR=kak
fi

[ -z $skin ] && export skin=onedark

# Various settings for bash itself

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
if [ $(uname) != 'Darwin' ]; then
  shopt -s globstar
fi

# append to the history file, don't overwrite it
shopt -s histappend

# History

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth
HISTSIZE=10000
HISTFILESIZE=10000
export HISTIGNORE="&:[ ]*:exit:ls:lt:ll:bg:fg:history:clear"

# make less more friendly for non-text input files, see lesspipe(1)
# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# enable programmable completion features
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

prompt() {
    red='\033[0;31m'
    
    last_status=$?
    if [ $last_status != 0 ]; then
        printf '%s[%s] ' $red $last_status
    fi

    yellow='\033[1;33m'
    printf '%s%s ' $yellow "$(whoami)"

    purple='\033[0;35m'
    printf '%s%s' $purple "$(hostname)"

    orange='\033[0;33m'
    if git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
        printf ' %s %s' $orange "$(git branch | grep \* | cut -d ' ' -f2-)"
    fi

    green='\033[0;32m'
    printf ' %s%s' $green "$(pwd)"

    normal='\033[0m'
    if [ $(id -u) -eq 0 ]; then
        printf '%s# ' $normal
    else
        printf '%s> ' $normal
    fi
}

PS1="$(prompt)"

# Local additions can be put in .bashrc.local
[ -f "$HOME/.bashrc.local" ] && . "$HOME/.bashrc.local"
