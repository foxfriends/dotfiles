# If not running interactively, don't do anything
case $- in
  *i*) ;;
  *) return;;
esac

# Various settings

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
export HISTIGNORE="&:[ ]*:exit:ls:la:lt:ll:bg:fg:history:clear"

# enable programmable completion features
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# run the custom scripts in the config directory
for file in $(ls "${HOME}/.config/bash/"); do
  . "$HOME/.config/bash/$file"
done

export GIT_EDITOR=kak
export EDITOR=kak

# Local stuff can be put in .bashrc2
[ -f "$HOME/.bashrc2" ] && . "$HOME/.bashrc2"
